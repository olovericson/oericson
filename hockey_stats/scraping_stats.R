library(rvest)
library(stringr)
library(dplyr)
base_url <- "http://stats.swehockey.se/ScheduleAndResults/Overview/7132"

team_nodes <- read_html(base_url) %>% 
  html_nodes(".tblBorderNoPad") %>% 
  html_nodes(".tblContent") %>% 
  magrittr::extract2(2) %>% 
  html_nodes("tr") %>% 
  tail(-1)

header_nodes <- team_nodes %>% 
  head(1)
  
headers <- header_nodes %>% 
  html_nodes("span") %>% 
  html_attr("title")

new_headers <- character(12)
new_headers[c(1,3:12)] <- str_to_lower(headers) %>% str_replace_all(" ", "_")
new_headers[2] <- "team"

get_team_stats <- function(input_nodes){
  input_nodes %>% 
    html_nodes("td") %>% 
    html_text() %>% 
    str_replace_all("[\n\r]", "")
}

input_nodes <- tail(team_nodes, -1)

stat_list <- lapply(input_nodes, get_team_stats)
stat_list[stat_list == ""] <- NULL

team_data <- data.frame(matrix(unlist(stat_list), nrow = 14, byrow = T), stringsAsFactors = F)
names(team_data) <- new_headers

mutate_if(team_data, is.numeric, as.factor)

