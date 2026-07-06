# Load packages
library(shiny)
library(bslib)
library(DT)
library(ggplot2)
library(plotly)
library(here)

# Source the module file
source("histogram_module.R")
## [EXERCISE] Source scatter plot module

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
  navset_card_underline(
    nav_panel("DataTable", DT::dataTableOutput(outputId = "oasis_DT")),
    nav_panel("MMSE", histogramUI("mmse", "MMSE Histogram")),
    nav_panel("nWBV", histogramUI("nwbv", "nWBV Histogram")),
    ## [EXERCISE] Add panels and call the scatter plot module
    )
  )

# Define server ----
server <- function(input, output, session) {
  # Create a reactive for the grouping variable
  grouping_var <- reactive({
    input$gvar
  })
  
  output$oasis_DT <- renderDT({
    
    DT::datatable(
      oasis_df,
      options = list(
        pageLength = 10,
        searchHighlight = TRUE,
        scrollX = TRUE
      ),
      rownames = FALSE
    )
  })
  
  # Call histogram modules for each variable
  histogramServer("mmse", data = oasis_df, variable = "mmse", grouping_var = grouping_var)
  histogramServer("nwbv", data = oasis_df, variable = "nwbv", grouping_var = grouping_var)

  #  [EXERCISE]  Call scatter module server for MMSE vs eTIV and nwbv vs asf
  
}

# Create a Shiny app object

shinyApp(ui = ui, server = server)