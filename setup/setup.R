pkglist <- c( "shiny",
              "bslib",
              "rsconnect",
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
if(length(new.packages)) {
  warning("The following packages are not installed: ", paste(new.packages, collapse = ", "), 
          "\nPlease run setup.R to install the required packages before proceeding with the workshop.")
  install.packages(new.packages)
  } else {
    message("All required packages are already installed.") 
  }

# Use this to add your API keys to your .Renviron file at the workshop.
# API key will be distributed at the workshop and disabled after. 
# Do not share your API key with anyone else.

usethis::edit_r_environ()

# Refer to https://shiny.posit.co/r/articles/share/shinyapps/
# for instructions on how to deploy your Shiny app to shinyapps.io. 
# You will need to create an account and set up your account information in R 
# using rsconnect::setAccountInfo() before you can deploy your app.
