get_team_stats <- function(input_nodes){
  input_nodes %>% 
    html_nodes("td") %>% 
    html_text() %>% 
    str_replace_all("[\n\r]", "")
}

char_is_numeric <- function(x){
  all(!is.na(as.numeric(x)))
}
