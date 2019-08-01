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

# get events
events <- map_dfr(events_date_range, get_page_events)

# get lineups
lineups <- map(events$event_url, safely(get_event_lineup))

lineups_result <- bind_rows(transpose(lineups)[['result']])

# export ------------------------------------------------------------------

write_csv(events, "data/berghain-events.csv")
write_csv(lineups_result, "data/berghain-lineups.csv")
