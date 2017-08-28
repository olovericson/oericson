# Utilities ---------------------------------------------------------------
char_is_numeric <- function(x){
  all(!is.na(as.numeric(x)))
}

link_concat <- function(site){
  force(site)
  function(link = ""){
    paste0(site, link)
  }
}

get_link_and_text <- function(.){
  html_nodes(., "a") %>% 
    tibble(name = html_text(.), link = html_attr(., "href")) %>% 
    select(-.)
}


add_names_from_first_row <- function(data){
  names(data) <- data %>% head(1) %>% str_trim()
  tail(data, -1)
}

# Specific ep-scraping -------------------------------------------------
ep_link <- link_concat("http://www.eliteprospects.com/")
ep_season_link = link_concat(ep_link("league_home.php?leagueid=1&startdate="))

get_ep_season_data <- function(season){
  league_table <- read_html(ep_season_link(season)) %>% 
    html_nodes("#ads-fullpage-site") %>%  
    html_nodes(".tableborder") %>% 
    extract2(1)
  
  team_links <- league_table %>%
    html_nodes("tr") %>% 
    tail(-1) %>%
    get_link_and_text() %>% 
    mutate(TEAM = str_trim(name)) %>% 
    select(-name)
  
  html_table(league_table) %>%
    add_names_from_first_row() %>%
    mutate_if(char_is_numeric, as.numeric) %>% 
    inner_join(team_links) %>% 
    mutate(season = season)
}

get_ep_season_transfers <- function(team, season){
  transfer_nodes <- read_html(paste0(ep_link("transfer.php?team="), team, "&filter=", season)) %>% 
    html_nodes("#ads-fullpage-site") %>%  
    html_nodes(".tableborder") %>% 
    extract2(1) 
  
  transfer_links <- transfer_nodes %>% 
    get_link_and_text() %>% 
    filter(name != "") %>% 
    mutate(
      player = ifelse(0 == (row_number() %% 2), lag(name), name),
      team = ifelse(0 == (row_number() %% 2), name, lead(name))
    ) %>% 
    group_by(player, team) %>% 
    summarise(player_link = min(link), team_link = max(link)) %>% 
    ungroup() %>% 
    mutate_all(function(x) str_trim(x, side="both"))
  
  transfer_nodes %>% 
    html_table() %>% 
    add_names_from_first_row() %>%
    select(-1, -SOURCE) %>% 
    filter(PLAYER != "Loans joining") %>%  
    tidyr::separate(PLAYER, c("date", "name"), "\\|") %>% 
    mutate_all(str_trim) %>% 
    left_join(transfer_links, by = c("name" = "player", "FROM" = "team")) %>% 
    mutate(type = "to", season = season, team = team)
}
