# Load packages
library(shiny)
library(bslib)
library(here)
library(dplyr)
library(gt)
library(gtsummary)
library(DT)
library(ggplot2)
library(plotly)

# Load data
oasis_df <- readRDS(here("data", "oasis_df.rds"))

# Define UI
ui <- page_sidebar(
) 

# Define server
server <- function(input, output, session) {
}

# Create a Shiny app object
shinyApp(ui = ui, server = server)