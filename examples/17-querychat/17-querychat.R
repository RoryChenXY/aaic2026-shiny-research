library(shiny)
library(bslib)
library(here)
library(dplyr)
library(ggplot2)
library(sf)
library(leaflet)
library(ellmer)
library(querychat)
library(DT)

# Load data 
gbd_60plus <- readRDS(here("data", "alz_gbd_60plus_sf.rds"))

gbd_60plus_nogeo <- gbd_60plus |>
  sf::st_drop_geometry() 

# Step 1: Initialize QueryChat
qc <- QueryChat$new(
  gbd_60plus_nogeo, 
  'gbd_60plus_nogeo', 
  greeting = 'gbd_60plus_greeting.md',
  data_description = 'gbd_60plus_description.md',
  client = "claude/claude-sonnet-4-5")

# Step 2: Add UI component
ui <- page_sidebar(
  # App title ----
  title = "GBD Data Explorer",
  sidebar = qc$sidebar(),
  card(
    fill = FALSE,
    card_header("SQL Query"),
    verbatimTextOutput("sql")
  ),
  card(
    card_header("Interactive Map and Data Table"),
    navset_tab(
      nav_panel("Data", dataTableOutput(outputId = "datadt"))
  ))
)

# Step 3: Use reactive values in server
server <- function(input, output, session) {
  qc_vals <- qc$server()
  
  output$sql <- renderText({
    qc_vals$sql() %||% "SELECT * FROM gbd_60plus"
  })
  
  ## DT
  output$datadt <- renderDataTable({
    qc_vals$df() |>
      datatable(
        filter = "top", # Enable built-in filters at the top of the columns
        options = list(
          pageLength = 25, # Control initial page size
          autoWidth = TRUE, # Auto adjusting column width
          search = list(smart = TRUE, regex = TRUE), # Enable "smart" space-separated searching globally
          scrollX = TRUE # Enable horizontal scrolling for wide data frames
        )
      )
  })
}

# Create a Shiny app object
shinyApp(ui = ui, server = server)