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
  
  league_data <- html_table(league_table) 
  names(league_data) <- league_data %>% head(1) %>% str_trim()
  
  league_data %>% 
    tail(-1) %>% 
    mutate_if(char_is_numeric, as.numeric) %>% 
    inner_join(team_links) %>% 
    mutate(season = season)
}


