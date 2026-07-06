# scatter_module.R

# Scatter Plot Module ----
## Module UI
scatterUI <- function(id, title) {
  ns <- NS(id)
  card(
    card_header(title),
    plotlyOutput(outputId = ns("plot"))
  )
}

## Module Server
scatterServer <- function(id, data, xvar, yvar, colorvar) {
  moduleServer(id, function(input, output, session) {
    
    output$plot <- renderPlotly({
      
      p <- plot_ly(
        data = data,
        x = ~.data[[xvar]], 
        y = ~.data[[yvar]] , 
        color  = ~.data[[colorvar()]], 
        colors = "Set1",
        type = "scatter",
        mode = "markers"
        ) |>
        layout(
          xaxis = list(title = toupper(xvar)),
          yaxis = list(title = toupper(yvar)),
          legend = list(title = list(text = colorvar(), orientation = "v"))
        )
      
      p
      
    })
    
  })
}