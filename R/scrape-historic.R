# load packages / functions -----------------------------------------------

library(glue)
library(fs)
library(lubridate)
library(tidyverse)
library(rvest)

source("R/functions.R")
fs::dir_create("data")

# scrape ------------------------------------------------------------------

# get all listings URLs
listing_urls <- gather_month_listing_urls()

# get all event URLs
event_urls <- gather_event_urls(listing_urls)

# get event data
events <- map(event_urls, get_event_info)

# export ------------------------------------------------------------------

write_csv(events, "data/berghain-events.csv")
write_csv(lineups_result, "data/berghain-lineups.csv")
