# create event page range
gen_event_page_range <- function(start_mon, start_year, end_mon, end_year) {
  
  date_range <- seq(as.Date(paste(start_year, start_mon, "01", sep = "-")),
                    as.Date(paste(end_year, end_mon, "01", sep = "-")), 
                    "months")
  
  format(date_range, "%Y-%m")
  
}

# get pages events 
get_page_events <- function(x) {
  
  # construct event page url
  events_url <- glue("http://berghain.de/events/{x}")
  
  # get events page
  events_page <- read_html(events_url) %>% 
    html_nodes("h4 a")
  
  # get event titles
  event_titles <- html_attr(events_page, "title")
  
  # split event date / name
  event_titles <- str_split_fixed(event_titles, pattern = ":", n = 2)
  
  # get event dates
  event_dates <- str_trim(event_titles[, 1])
  
  # get event dates
  event_names <- str_trim(event_titles[, 2])
  
  # get event links
  event_links <- html_attr(events_page, "href")
  
  tibble(
    event_name = event_names,
    event_date = dmy(event_dates),
    event_url = event_links
  )
}

get_event_lineup <- function(x) {
  
  # construct event page url
  event_url <- glue("http://berghain.de{x}")

  # get event context
  event_context <- read_html(event_url) %>% 
    html_nodes(".col_context") 
  
  # get venues
  venues <- event_context %>% 
    html_nodes(".type_stage_color")
  
  if (length(venues) == 0) {
    venues <- event_context %>% 
      html_nodes(".type_dancefloor_color") 
  }
    
  venues <- venues %>% 
    html_text() %>% 
    str_remove("Running Order") %>% 
    str_trim()
  
  # get running order
  running_order <- event_context %>% 
    html_nodes(".type_stage_color + .running_order")
  
  if (length(running_order) == 0) {
    running_order <- event_context %>% 
      html_nodes(".type_dancefloor_color + .running_order")
  }
  
  # get artist names
  artist_names <- lapply(running_order, function(x) {
    
    x %>% 
      html_nodes(".running_order_name") %>% 
      html_text() %>%
      str_trim() %>%
      str_remove_all("\t")
  })

  # return a data frame
  tibble(venue = rep(venues, sapply(artist_names, length)),
         artist_name = unlist(artist_names),
         event_url = x
         )
}


