library(rvest)
library(stringr)
library(dplyr)

setwd("C:/Users/olov_/git_repo/oericson/hockey_stats")
source("utils.R")

base_url <- "http://stats.swehockey.se/ScheduleAndResults/Overview/7132"

team_nodes <- read_html(base_url) %>% 
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

team_data <- data.frame(matrix(unlist(stat_list), nrow = 14, byrow = T), stringsAsFactors = F)
names(team_data) <- new_headers

team_data <- team_data %>% 
  mutate(
    goals_for = str_extract(`goals_for:goals_against_(goal_difference)`, '^[0-9]+'),
    goals_against = str_extract(`goals_for:goals_against_(goal_difference)`, '(?<=:)[\\d]+'),
    goal_difference = str_extract(`goals_for:goals_against_(goal_difference)`, '(?<=\\()-?[\\d]+')
    ) %>% 
  select(-`goals_for:goals_against_(goal_difference)`) %>% 
  mutate_if(char_is_numeric, as.numeric) 


