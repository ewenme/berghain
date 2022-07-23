# load packages / functions -----------------------------------------------

library(glue)
library(fs)
library(lubridate)
library(tidyverse)
library(rvest)

source("R/functions.R")

fs::dir_create("data")

# setup -------------------------------------------------------------------

# get all listings URLs
listing_urls <- gather_month_listing_urls()

# get all event URLs
event_urls <- gather_event_urls(listing_urls)

# scrape ------------------------------------------------------------------

# get events
events <- map_dfr(events_date_range, get_page_events)

# get lineups
lineups <- map(events$event_url, safely(get_event_lineup))

lineups_result <- bind_rows(transpose(lineups)[['result']])

# export ------------------------------------------------------------------

write_csv(events, "data/berghain-events.csv")
write_csv(lineups_result, "data/berghain-lineups.csv")
