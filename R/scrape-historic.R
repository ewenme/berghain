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

# scrape ------------------------------------------------------------------

# get all listings URLs
listing_urls <- gather_month_listing_urls()

# get all event URLs
event_urls <- gather_event_urls(listing_urls)

# get event data
event_data <- map(event_urls, possibly(get_event_info, otherwise = NULL))

# export ------------------------------------------------------------------

events <- tidy_events(event_data)
lineups <- tidy_lineups(event_data)

write_csv(events, "data/events.csv")
write_csv(lineups, "data/lineups.csv")
