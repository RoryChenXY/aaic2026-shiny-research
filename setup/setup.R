pkglist <- c( "shiny",
              "bslib",
              "ggplot2",
              "plotly",
              "sf",
              "leaflet",
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

usethis::edit_r_environ()
