library(rvest)
library(stringr)
library(dplyr)
library(magrittr)

setwd("C:/Users/olov_/git_repo/oericson/hockey_stats")
source("utils.R")

ep_link <- link_concat("http://www.eliteprospects.com/")
ep_league_link = link_concat(ep_link("league_home.php?leagueid=1&startdate="))

seasons <- 2010:2016

ep_season_data <- map_df(seasons, get_ep_season_data)





