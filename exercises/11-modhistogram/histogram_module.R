# histogram_module.R

# Histogram Module ----
## Module UI
histogramUI <- function(id, title) {
  ns <- NS(id)
  card(
    card_header(title),
    plotlyOutput(outputId = ns("plot"))
  )
}

## Module Server
histogramServer <- function(id, data, variable, grouping_var) {
  moduleServer(id, function(input, output, session) {
    
    output$plot <- renderPlotly({
      
      # Get the grouping variable name for the legend
      gvar_name <- grouping_var()
      
      p <- plotly::plot_ly(
        data = data,
        x = ~.data[[variable]],
        color = ~.data[[gvar_name]],
        colors = "Pastel1",
        alpha = 0.6,
        hovertemplate = paste(
          paste0(toupper(variable), ': %{x}'),
          '<br>Counts: %{y}<br>'
        )
      ) |>
        plotly::add_histogram() |>
        plotly::layout(
          xaxis = list(title = toupper(variable)),
          yaxis = list(title = "Counts", showgrid = TRUE),
          legend = list(title = list(text = gvar_name), orientation = "v"),
          updatemenus = list(
            list(
              x = 1.2,
              y = 0.4,
              type = "buttons",
              buttons = list(
                list(
                  method = "relayout",
                  args = list("barmode", "group"),
                  label = "Group"
                ),
                list(
                  method = "relayout",
                  args = list("barmode", "stack"),
                  label = "Stack"
                ),
                list(
                  method = "relayout",
                  args = list("barmode", "overlay"),
                  label = "Overlay"
                )
              )
            )
          )
        )
      
      return(p)
    })
    
  })
}