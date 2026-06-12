library(NeuroDataSets)
library(dplyr)

data(OASIS_long_tbl_df)


# some column names contain spaces or symbols
# remove space
oasis_df <- OASIS_long_tbl_df |>
  rename_with(\(x) {
    x |>
      tolower() |>
      gsub(" ", "_", x = _, fixed = TRUE) |>
      gsub("/", "", x = _, fixed = TRUE)
  }) |>
  mutate(
    across(c(group, mf, hand, ses, cdr),  as.factor)
  )

saveRDS(oasis_df, "./data/oasis_df.rds")
