library(sf)
library(dplyr)
library(rnaturalearthdata)
library(countrycode)


# Get the SF data
data(countries50) #rnaturalearthdata
sf_ref <- countries50 |>
  select(sovereignt, adm0_a3, geometry) |>
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
  select(c(iso3, country, geometry, measure, sex, metric, val)) |>
  mutate(across(c(measure, sex, metric), as.factor)) |>
  filter(!st_is_empty(geometry)) |>
  st_as_sf()

saveRDS(alz_gbd_60plus_sf, "data/alz_gbd_60plus_sf.rds")

names(alz_gbd_60plus_sf)




# Output




alz_gbd_60 <- alz_gbd_sf |>
  filter(age_id == 231) |>
  select(-c(ends_with("id"), age_name, location_name, year, ) |>
  
