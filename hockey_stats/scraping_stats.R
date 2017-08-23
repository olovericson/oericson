library(rvest)
library(stringr)
library(dplyr)
library(purrr)

setwd("C:/Users/olov_/git_repo/oericson/hockey_stats")
source("utils.R")

stats_link <-link_concat("http://stats.swehockey.se")

team_data <- read_html(stats_link("/ScheduleAndResults/Overview/8121")) %>% 
  html_node('#menuUl') %>% 
  html_nodes("li") %>% 
  get_link_and_text() %>% 
  filter(str_detect(name, "^\\d") & name != "2017-18") %>% 
  mutate(overview_link = sapply(link, get_overview_link)) %>% 
  mutate(standings_link = str_replace(overview_link, "Overview", "Standings")) %>% 
  rowwise() %>% 
  do(get_team_data(.["overview_link"], .["name"]))

