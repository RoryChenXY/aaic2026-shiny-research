library(shiny)
library(bslib)
library(here)
library(dplyr)
library(DT)
library(sf)
library(ellmer)
library(querychat)

# Load data 
gbd_60plus <- readRDS(here("data", "alz_gbd_60plus_sf.rds")) |>
  sf::st_drop_geometry() 

# Step 1: Initialize QueryChat
qc <- QueryChat$new(
  gbd_60plus, 
  'gbd_60plus', 
  greeting = 'Hello!',
  client = "claude/claude-sonnet-4-5")

# Step 2: Add UI component
ui <- page_sidebar(
  # App title ----
  title = "GBD ADOD Data Explorer",
  sidebar = qc$sidebar(),
  card(
    fill = FALSE,
    card_header("SQL Query"),
    verbatimTextOutput("sql")
  ),
  card(
    card_header("Interactive Data Table"),
    dataTableOutput(outputId = "datadt")
    )
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