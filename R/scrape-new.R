# load packages / functions -----------------------------------------------

library(glue)
library(fs)
library(lubridate)
library(stringr)
library(dplyr)
library(purrr)
library(rvest)
library(readr)

source("R/functions.R")
fs::dir_create("data")

events_history <- read_csv("data/events.csv")

# scrape ------------------------------------------------------------------

# get previous months listings
listing_url <- get_last_months_listing_url()

# get all event URLs
event_urls <- gather_event_urls(listing_url)

# get event data
event_data <- map(event_urls, possibly(get_event_info, otherwise = NULL))

# export ------------------------------------------------------------------

events <- tidy_events(event_data)
lineups <- tidy_lineups(event_data)

write_csv(events, "data/events.csv", append = TRUE)
write_csv(lineups, "data/lineups.csv", append = TRUE)
