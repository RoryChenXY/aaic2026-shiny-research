# Load packages
library(shiny)
library(bslib)
library(ggplot2)
library(plotly)

# Source the module file
source("histogram_module.R")

# Load data
oasis_df <- readRDS("oasis_df.rds") |> filter(visit == 1)

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
  layout_columns(
    histogramUI("mmse", "MMSE Histogram"),
    histogramUI("etiv", "eTIV Histogram"),
    histogramUI("nwbv", "nWBV Histogram"),
    histogramUI("asf", "ASF Histogram"),
    col_widths = c(6, 6, 6, 6)
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