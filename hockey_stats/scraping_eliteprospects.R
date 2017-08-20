library(rvest)
library(stringr)
library(dplyr)
base_url <- "http://www.eliteprospects.com/"
`%+%` <- function(x, y) paste0(x, y)

players_nodes <- read_html("http://www.eliteprospects.com/team.php?year0=&team=28") %>% 
  html_nodes(".tableborder2") %>%
  html_nodes("tr") %>% 
  tail(-1) 

players <- players_nodes %>% 
  html_nodes("a") %>%
  tibble(name = html_text(.), link = html_attr(., "href")) %>% 
  filter(row_number() %% 2 == 1) %>% 
  select(-.)

players %>% 
  head(1) %>%
  select(link) %>% 
  as.character(.) %>% 
  read_html(base_url %+% .)

arne <- function(hej){
  call <- match.call()
  call
} 
