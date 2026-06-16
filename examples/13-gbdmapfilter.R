# Load packages
library(shiny)
library(bslib)
library(sf)
library(leaflet)
library(here)
library(dplyr)
library(DT)

# Load data
gbd_60plus <- readRDS(here("data", "alz_gbd_60plus_sf.rds"))

# Define UI
ui <- page_sidebar(
  # App title ----
  title = "GBD Data Explorer",
  sidebar = sidebar(
    ## [EXERCISE] Add three `selectInput()` for users to select sex, measure and metric.
    
    ## Filter for sex
    selectInput(
      inputId  = "selected_sex",
      label    = "Select Sex:",
      choices  = levels(gbd_60plus$sex),
      selected = "Both"),
    ## Filter for measure
    selectInput(
      inputId  = "selected_measure",
      label    = "Select Measure:",
      choices  = levels(gbd_60plus$measure),
      selected = "Prevalence"),
    ## Filter for measure
    selectInput(
      inputId  = "selected_metric",
      label    = "Select Metric:",
      choices  = levels(gbd_60plus$metric),
      selected = "Percent")
  ),
  
  card(
    card_header("Interactive Map and Data Table"),
    navset_tab(
      nav_panel("Choropleth Map", leafletOutput(outputId = "choropleth_map")),
      nav_panel("Data", dataTableOutput(outputId = "datadt")),
      nav_panel("Map Filter", 
                actionButton("resetmap", "Reset Map"),
                br(),
                leafletOutput(outputId = "mapfilter"),
                verbatimTextOutput(outputId = "filtered_country"),
                dataTableOutput(outputId = "mapfiltered_dt"))
      
    ))
  
)

# Define server
server <- function(input, output, session) {
  
  ## [EXERCISE] Define the reactive expression to filter the data based on the selected inputs.
  filtered_data <- reactive({
    req(input$selected_sex,
        input$selected_measure, 
        input$selected_metric
    )
    
    gbd_60plus |>
      filter(
        sex == input$selected_sex,
        measure == input$selected_measure,
        metric == input$selected_metric
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
  
  ## Choropleth_map
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
  
  ## MAP FILTER -----------------------
  
  # Define reactive values
  rv <- shiny::reactiveValues(selected_countries = NULL, # Initialize reactive value for selected counties
                              last_click_id = NULL,
                              map_filtered_data = filtered_data())
  
  # Define the map filter object
  output$mapfilter <- leaflet::renderLeaflet({ # rendering the filter map
    
    leaflet::leaflet() |> 
      leaflet::addTiles() |> # The is the base map
      leaflet::addPolygons(data = filtered_data(), 
                           color = '#316879', 
                           weight = 1,
                           layerId = ~country,
                           label = ~country,
                           fillColor = "#7fe7dc",
                           fillOpacity = .5,
                           highlightOptions = highlightOptions(
                             fillOpacity = 1,
                             bringToFront = TRUE
                           )) |>
      leaflet::setView(zoom = 1, lng = 0, lat = 50)
    
  })
  
  shiny::observeEvent(input$mapfilter_shape_click, { 
    click <- input$mapfilter_shape_click
    req(click$id) # Ensures click$id exists before running code
    
    rv$last_click_id <- click$id 
    
    ########## map behavior ################
    
    # Toggle country selection using the true country ID
    if (click$id %in% rv$selected_countries) {
      # If already selected, remove it
      rv$selected_countries <- rv$selected_countries[rv$selected_countries != click$id]
    } else {
      # If not selected, add it
      rv$selected_countries <- c(rv$selected_countries, click$id)
    }
    

    # Now update the leaflet map smoothly
    leaflet::leafletProxy("mapfilter", session) |>
      leaflet::addPolygons(
        data = map_filtered_data,
        layerId = ~country,  # ALWAYS keep the original country ID here
        label = ~country,
        fillColor = ifelse(map_data$country %in% rv$selected_countries, "#F47A60", "#7fe7dc"), 
        color = "#316879",
        weight = 2,
        fillOpacity = ifelse(map_data$country %in% rv$selected_countries, 1, 0.5),
        highlightOptions = leaflet::highlightOptions(
          fillOpacity = 1,
          bringToFront = TRUE
        )
      )
  })

  
  
}

# Create a Shiny app object
shinyApp(ui = ui, server = server)