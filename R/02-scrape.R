# load packages / functions -----------------------------------------------

source("R/00-requirements.R")
source("R/01-functions.R")

fs::dir_create("data")

# setup -------------------------------------------------------------------

# date params
start_year = 2009
start_mon = 11
end_year = 2019
end_mon = 7

# generate dates to scrape
events_date_range <- gen_event_page_range(start_mon, start_year,
                                          end_mon, end_year)

# scrape ------------------------------------------------------------------

events <- map_dfr(events_date_range, get_page_events)

# export ------------------------------------------------------------------

write_csv(events, "data/berghain-events.csv")
