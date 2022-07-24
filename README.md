# berghain

[![scrape berghain listings](https://github.com/ewenme/berghain/actions/workflows/main.yml/badge.svg)](https://github.com/ewenme/berghain/actions/workflows/main.yml)

[Bergain's](http://berghain.de/) event listings, as flat-files. Updated on the first day of each month at 12:00 UTC.

N.B. this is a work in progress and should be treated as such.

## Contents

### Data

Events - `data/events.csv`

| Header | Description | Data Type |
| --- | --- | --- |
| `event_id` | numeric ID of event | text |
| `event_name` | name of event | text |
| `event_date` | date of event | date |
| `event_url` | event url | text |

Lineups - `data/lineups.csv`

| Header | Description | Data Type |
| --- | --- | --- |
| `event_id` | numeric ID of event | text |
| `floor` | name of floor | text |
| `artist_name` | name of artist | text |
| `set_time_start` | start date/time of set (Berlin local time) | datetime |
| `set_time_end` | end date/time of set (Berlin local time) | datetime |

### Code

R:

- `R/scrape-new.R`: retrieves latest months data and appends new observations to CSVs in `data/`
- `R/scrape-historic.R`: retrieves all months data and overwrites CSVs in `data/`
- `R/functions.R`: local R functions used elsewhere

Actions:

- `.github/workflows/main.yml`: runs `R/scrape-new.R` once a month
