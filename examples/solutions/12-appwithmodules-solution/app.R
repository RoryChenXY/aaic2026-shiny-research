# Load packages
library(shiny)
library(bslib)
library(DT)
library(ggplot2)
library(plotly)
library(here)

# Source the module file
source("histogram_module.R")
source("scatter_module.R")

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
    nav_panel("MMSE vs eTIV", scatterUI("mmse_etiv", "MMSE vs eTIV Scatter Plot")),
    nav_panel("nWBV vs ASF", scatterUI("nwbv_asf", "nWBV vs ASF Scatter Plot"))
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

  # Call scatter module for MMSE vs eTIV and nwbv vs asf
  scatterServer("mmse_etiv", data = oasis_df, xvar = "mmse", yvar = "etiv", colorvar = grouping_var)
  scatterServer("nwbv_asf", data = oasis_df, xvar = "nwbv", yvar = "asf", colorvar = grouping_var)

}

# Create a Shiny app object

shinyApp(ui = ui, server = server)