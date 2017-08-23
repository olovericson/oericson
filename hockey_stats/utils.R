# Utilities ---------------------------------------------------------------
char_is_numeric <- function(x){
  all(!is.na(as.numeric(x)))
}

link_concat <- function(site){
  force(site)
  function(link){
    paste0(site, link)
  }
}

get_link_and_text <- function(.){
  html_nodes(., "a") %>% 
    tibble(name = html_text(.), link = html_attr(., "href")) %>% 
    select(-.)
}

# Specific stats-scraping -------------------------------------------------
get_team_stats <- function(input_nodes){
  input_nodes %>% 
    html_nodes("td") %>% 
    html_text() %>% 
    str_replace_all("[\n\r]", "")
}

get_overview_link <- function(link) {
  read_html(stats_link(link)) %>% 
    html_nodes(".open") %>%
    get_link_and_text() %>% 
    filter(name %in% c("SHL", "Elitserien")) %>% 
    select(link) %>% 
    as.character()
}

get_team_data <- function(url, season){
  message(stats_link(url))
  team_nodes <- read_html(stats_link(url)) %>% 
    html_nodes(".tblBorderNoPad") %>% 
    html_nodes(".tblContent") %>% 
    magrittr::extract2(2) %>% 
    html_nodes("tr") %>% 
    tail(-1)
  
  headers <- team_nodes %>% 
    head(1) %>%  
    html_nodes("span") %>% 
    html_attr("title")
  
  new_headers <- character(12)
  new_headers[c(1,3:12)] <- str_to_lower(headers) %>% str_replace_all(" ", "_")
  new_headers[2] <- "team"
  
  input_nodes <- tail(team_nodes, -1)
  
  stat_list <- lapply(input_nodes, get_team_stats)
  stat_list[stat_list == ""] <- NULL
  
  team_data <- data.frame(matrix(unlist(stat_list), ncol = 12, byrow = T), stringsAsFactors = F)
  names(team_data) <- new_headers
  
  team_data <- team_data %>% 
    mutate(
      goals_for = str_extract(`goals_for:goals_against_(goal_difference)`, '^[0-9]+'),
      goals_against = str_extract(`goals_for:goals_against_(goal_difference)`, '(?<=:)[\\d]+'),
      goal_difference = str_extract(`goals_for:goals_against_(goal_difference)`, '(?<=\\()-?[\\d]+')
    ) %>% 
    select(-`goals_for:goals_against_(goal_difference)`) %>% 
    mutate_if(char_is_numeric, as.numeric) %>% 
    mutate(season = season)
}
