# get available years of listings
get_program_years <- function(
    base_url = "https://www.berghain.berlin"
) {
  
  page <- rvest::read_html(
    glue::glue("{base_url}/en/program/archive/")
    )
  
  years <- page %>% 
    rvest::html_element("#selectYear") %>% 
    rvest::html_elements("option") %>% 
    rvest::html_text2() %>% 
    stringr::str_subset("Select year", negate = TRUE)
  
  return(years)
}

# get urls of monthly listings for a given year
get_month_listing_urls <- function(
    year,
    base_url = "https://www.berghain.berlin"
) {
  
  page <- rvest::read_html(
    glue::glue("{base_url}/en/program/archive/{year}")
    )
  
  urls <- page %>% 
    rvest::html_elements("#months-index") %>% 
    rvest::html_elements("a") %>% 
    rvest::html_attr("href")
  
  return(urls)
}

# get all monthly listings urls for all available years
gather_month_listing_urls <- function() {
  
  years <- get_program_years()
  
  urls <- lapply(years, get_month_listing_urls)
  
  return(unlist(urls))
}

# get urls of events for a given months listings
get_event_urls <- function(
    month_listing_url,
    base_url = "https://www.berghain.berlin"
) {
  
  page <- rvest::read_html(
    glue::glue("{base_url}{month_listing_url}")
  )
  
  urls <- page %>% 
    rvest::html_elements(".upcoming-event") %>% 
    rvest::html_attr("href")
  
  return(urls)
}

# get all event listings for monthly archive url
gather_event_urls <- function(x) {
  
  urls <- lapply(x, get_event_urls)
  
  return(unlist(urls))
}

# get lineup info
get_lineup_data <- function(page, floor) {
  
  floor_name <- page %>% 
    rvest::html_elements(xpath = glue(".//div[@data-set-floor='{floor}']")) %>% 
    rvest::html_element("h2") %>% 
    rvest::html_text2()
  
  artists <- page %>% 
    rvest::html_elements(xpath = glue(".//div[@data-set-floor='{floor}']")) %>% 
    rvest::html_elements(".running-order-set") %>% 
    rvest::html_element(".running-order-set__info") %>%
    rvest::html_element(xpath = "span[1]/text()") %>% 
    html_text2()
  
  set_times <- page %>% 
    rvest::html_elements(xpath = glue(".//div[@data-set-floor='{floor}']")) %>% 
    rvest::html_elements(".running-order-set")
  
  # check if floor closed at all
  floor_closed <- page %>% 
    rvest::html_elements(xpath = glue(".//div[@data-set-floor='{floor}']")) %>% 
    rvest::html_elements(".running-order-set") %>% 
    rvest::html_attr("data-set-floor-closed")
  
  set_times <- set_times[is.na(floor_closed)]
  artists <- artists[is.na(floor_closed)]
  
  tibble(
    floor = floor_name,
    artist_name = artists,
    set_time_start = lubridate::as_datetime(
      html_attr(set_times, "data-set-item-start"), tz = "CET"
      ),
    set_time_end = lubridate::as_datetime(
      html_attr(set_times, "data-set-item-end"), tz = "CET"
    )
  )
}

# get all lineup data
gather_lineups <- function(page) {
  
  lineup_0 <- get_lineup_data(page, floor = 0)
  lineup_1 <- get_lineup_data(page, floor = 1)
  lineup_2 <- get_lineup_data(page, floor = 2)
  
  bind_rows(lineup_0, lineup_1, lineup_2)
}

# get all event info
get_event_info <- function(
    event_url, 
    base_url = "https://www.berghain.berlin"
    ) {
  
  page <- rvest::read_html(
    glue::glue("{base_url}{event_url}")
  )
  
  event_name <- page %>% 
    rvest::html_element("h1") %>% 
    rvest::html_text2()
  event_id <- basename(event_url)
  
  event_date <- page %>% 
    rvest::html_element("main") %>% 
    rvest::html_element("div:nth-of-type(2) > p") %>% 
    rvest::html_element("span") %>% 
    rvest::html_text2()
  
  is_event_cancelled <- str_detect(event_name, regex("cancelled", ignore_case = TRUE))
  
  if (is_event_cancelled) return(NULL)

  lineup <- gather_lineups(page)
  
  list(
    event_id = event_id,
    event_name = event_name,
    event_url = event_url,
    event_date = dmy(event_date),
    lineup = lineup
  )

}

tidy_events <- function(x) {
  
  df <- map_dfr(x, ~{
    .x[["lineup"]] = NULL
    .x
  })
  
  arrange(df, event_id)
}

tidy_lineups <- function(x) {
  
  df <- map_dfr(x, ~{
    .x[["lineup"]]$event_id = .x[["event_id"]]
    .x[["lineup"]]
  })
  
  df %>% 
    select(event_id, everything()) %>% 
    arrange(event_id) %>% 
    mutate(across(c(set_time_start, set_time_end), as.character))
}
