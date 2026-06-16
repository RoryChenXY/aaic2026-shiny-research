pkglist <- c( "shiny",
              "bslib",
              "ggplot2",
              "plotly",
              "sf",
              "leaflet",
              "here",
              "usethis",
              "dplyr",
              "DT",
              "gt",
              "gtsummary",
              "modeldata", 
              "ellmer",
              "shinychat",
              "querychat")

# install packages if not already installed

new.packages <- pkglist[!(pkglist %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

# Use this to add your API keys to your .Renviron file at the workshop.
# API key will be distributed at the workshop and disabled after. 
# Do not share your API key with anyone else.

usethis::edit_r_environ()
