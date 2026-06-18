

# Reset the map filter
shiny::observeEvent(input$resetmap, {
  
  rv$selected_countries <- NULL
  rv$last_click_id <- NULL
  rv$filtered_data <- filtered_data()
  
  leafletProxy("mapfilter", session) |>
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
    leaflet::setView(zoom = 1, lng = 0, lat =50)
  
})


output$mapfiltered_dt <- renderDataTable({
  
  map_filtered() |>
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








# When a shape on the map is clicked, update the selected countries
# this is the logic behind the "click" of the map.



output$filtered_country <- shiny::renderPrint({
  paste(rv$selected_countries, collapse = ',')
})



# Return reactive values
return(
  list(
    value = shiny::reactive(rv$selected_countries),
    map_filtered  = shiny::reactive(rv$map_filtered_data)
  )
)


