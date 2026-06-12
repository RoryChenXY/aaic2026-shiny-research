pkglist <- c( "shiny",
              "bslib",
              "ggplot2",
              "plotly",
              "leaflet",
              "dplyr",
              "DT",
              "gt",
              "gtsummary",
              "modeldata", 
              "ellmer",
              "querychat")

# install packages if not already installed

new.packages <- pkglist[!(pkglist %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)