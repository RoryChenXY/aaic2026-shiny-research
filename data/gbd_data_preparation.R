library(sf)
library(dplyr)
library(rnaturalearthdata)
library(countrycode)


# Get the SF data
data(countries50) #rnaturalearthdata
sf_ref <- countries50 |>
  select(sovereignt, adm0_a3, continent, income_grp, geometry) |>
  filter(!st_is_empty(geometry))


# Read in the GBD data in csv
alz_gbd_60plus <- read.csv("data/GBD_2023_60plus.csv")

gbd_country <- tibble(location = unique(alz_gbd_60plus$location)) |>
  mutate(iso3 = countrycode(
    location,
    origin = "country.name",
    destination = "iso3c"
  )) |>
  left_join(sf_ref, by = join_by(iso3 == adm0_a3)) |>
  rename(country = sovereignt) |>
  filter(!st_is_empty(geometry))


alz_gbd_60plus_sf <- right_join(gbd_country, alz_gbd_60plus, by = join_by(location == location)) |>
  select(c(iso3, country, income_grp, continent, measure, sex, metric, val, geometry)) |>
  mutate(across(c(income_grp, continent, measure, sex, metric), as.factor)) |>
  filter(!st_is_empty(geometry)) |>
  st_as_sf() |>
  arrange(iso3)

saveRDS(alz_gbd_60plus_sf, "data/alz_gbd_60plus_sf.rds")

names(gbd_60plus_nogeo)




  
