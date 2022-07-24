# berghain

[![scrape berghain listings](https://github.com/ewenme/berghain/actions/workflows/main.yml/badge.svg)](https://github.com/ewenme/berghain/actions/workflows/main.yml)

Data from [Bergain's](http://berghain.de/) event listings, collated in July 2022.

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

`/R` directory contains all code used to gather this data.
