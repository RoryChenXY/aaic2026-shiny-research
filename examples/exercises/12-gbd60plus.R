# Load packages
library(shiny)
library(bslib)
library(leaflet)
library(dplyr)
library(here)
library(DT)

# Load data
gbd_60plus <- readRDS(here("data", "alz_gbd_60plus_sf.rds"))

# Define UI
ui <- page_sidebar(
  # App title ----
  title = "GBD Data Explorer",
  sidebar = sidebar(
    ## [EXERCISE] Add three `selectInput()` for users to select sex, measure and metric.
  ),
  
  card(
    card_header("Interactive Map and Data Table"),
    navset_tab(
      nav_panel("Choropleth Map", leafletOutput(outputId = "choropleth_map")),
      nav_panel("Data", dataTableOutput(outputId = "datadt"))
    ))
  
)

# Define server
server <- function(input, output, session) {
  
  ## [EXERCISE] Define the reactive expression to filter the data based on the selected inputs.
  filtered_data <- reactive({
    req()
    
    gbd_60plus |>
      filter(
      )
  })
  
  ## DT
  output$datadt <- renderDataTable({
    
    filtered_data() |>
      st_drop_geometry() |>
      datatable(
        filter = "top", # Enable built-in filters at the top of the columns
        options = list(
          pageLength = 15, # Control initial page size
          autoWidth = TRUE, # Auto adjusting column width
          search = list(smart = TRUE, regex = TRUE), # Enable "smart" space-separated searching globally
          scrollX = TRUE # Enable horizontal scrolling for wide data frames
        )
      )

  })
  
  output$choropleth_map <- renderLeaflet({
    
    map_data <- filtered_data()
    
    pal <- colorNumeric(
      palette = "Purples",
      domain = map_data$val,
      na.color = "#f0f0f0"
    )
    
    leaflet(map_data) |>
      addProviderTiles(providers$CartoDB.Positron) |>
      addPolygons(
        fillColor = ~pal(val),
        fillOpacity = 0.8,
        color = "white",
        weight = 0.5,
        popup = ~paste0(
          "<strong>Country:</strong> ", country, "<br>",
          "<strong>Measure:</strong> ", measure, "<br>",
          "<strong>Sex:</strong> ", sex, "<br>",
          "<strong>Metric:</strong> ", metric, "<br>",
          "<strong>Value:</strong> ", round(val, 2)
        ),
        label = ~paste0(country, ": ", round(val, 2)),
        highlightOptions = highlightOptions(
          weight = 2,
          color = "#666",
          fillOpacity = 0.9,
          bringToFront = TRUE
        )
      ) |>
      addLegend(
        pal = pal,
        values = ~val,
        title = "Value",
        opacity = 0.8,
        position = "bottomright"
      )
  })
  
  
  
}

# Create a Shiny app object
shinyApp(ui = ui, server = server)