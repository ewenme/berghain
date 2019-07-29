# install pacman if missing
if (!require("pacman")) install.packages("pacman")

# install/load packages
pacman::p_load("fs", "glue", "lubridate", "rvest", "tidyverse")
