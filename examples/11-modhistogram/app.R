# Load packages
library(shiny)
library(bslib)
library(here)
library(ggplot2)
library(plotly)

# Source the module file
source("histogram_module.R")

# Load data
oasis_df <- readRDS(here("data", "oasis_df.rds")) |> 
  filter(visit == 1)

# Define UI ----
ui <- page_sidebar(
  ## App title ----
  title = "OASIS Data Explorer",
  ## Sidebar ----
  sidebar = sidebar(
    ## Choose grouping variable
    selectInput(
      inputId = "gvar",
      label = "Grouping:",
      choices = c("group", "mf", "ses", "cdr"),
      selected = "group"
    )
  ),
  ## Main Panel ----
  navset_tab(
    nav_panel("MMSE", histogramUI("mmse", "MMSE Histogram")),
    nav_panel("eTIV", histogramUI("etiv", "eTIV Histogram")),
    nav_panel("nWBV", histogramUI("nwbv", "nWBV Histogram")),
    nav_panel("ASF", histogramUI("asf", "ASF Histogram"))
  )
)

# Define server ----
server <- function(input, output, session) {
  # Create a reactive for the grouping variable
  grouping_var <- reactive({
    input$gvar
  })
  # Call histogram modules for each variable
  histogramServer("mmse", data = oasis_df, variable = "mmse", grouping_var = grouping_var)
  histogramServer("etiv", data = oasis_df, variable = "etiv", grouping_var = grouping_var)
  histogramServer("nwbv", data = oasis_df, variable = "nwbv", grouping_var = grouping_var)
  histogramServer("asf", data = oasis_df, variable = "asf", grouping_var = grouping_var)
}

# Create a Shiny app object
shinyApp(ui = ui, server = server)