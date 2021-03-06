library(rvest)
library(stringr)
library(dplyr)
library(magrittr)

setwd("C:/Users/olov_/git_repo/oericson/hockey_stats")
source("utils.R")


# Data retreival ----------------------------------------------------------

ep_link <- link_concat("http://www.eliteprospects.com/")

seasons <- 2010:2016

ep_season_data <- purrr::map_df(seasons, get_ep_season_data) 

ep_season_data$team_no <- str_extract(ep_season_data$link, "\\d+")
team_numbers <- unique(ep_season_data$team_no)

transfers <- purrr::map2_df(ep_season_data$team_no, ep_season_data$season, get_ep_season_transfers)



# Prepare data for modelling ----------------------------------------------

last_season_score <- ep_season_data %>% 
  mutate(last_season = season-1, next_year_score = TP/GP, next_year_position = `#`) %>% 
  select(TEAM, last_season, next_year_score, next_year_position)

model_data <- ep_season_data %>% 
  left_join(last_season_score, c("TEAM", "season" = "last_season")) %>% 
  mutate(
    TP = TP / GP,
    W = W / GP,
    L = L / GP,
    OTW = OTW / GP,
    plus_minus = `+/-`/ GP,
    post_season = as.factor(POSTSEASON)
  ) %>% 
  filter(!is.na(next_year_score))


# Modelling ---------------------------------------------------------------

rf_model <- caret::train(next_year_score ~ TP + W + L + OTW + plus_minus + POSTSEASON, 
                         model_data, method = "rf", na.action = na.omit)


# Check the results -------------------------------------------------------

bind_cols(model_data, prediction = predict(rf_model, model_data)) %>% 
  select(season, TEAM, TP, `#`, next_year_position, next_year_score, prediction) %>% 
  mutate(error = abs(prediction - next_year_score)) %>% 
  arrange(desc(error)) %>% 
  View()
