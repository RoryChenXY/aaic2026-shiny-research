# Load packages
library(shiny)
library(bslib)
library(here)
library(dplyr)
library(ggplot2)
library(plotly)

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
    selectInput(inputId = "gvar", 
                label = "Grouping:",
                choices = c("group", "mf", "ses", "cdr"),
                selected = "group")
  ),
  ## Main Panel ----
  navset_tab(
    nav_panel("MMSE", 
              card(
                card_header("MMSE Histogram"),
                plotlyOutput(outputId = "mmseplot")
              )),
    nav_panel("eTIV", 
              card(
                card_header("eTIV Histogram"),
                plotlyOutput(outputId = "etivplot")
              )),
    nav_panel("nWBV", 
              card(
                card_header("nWBV Histogram"),
                plotlyOutput(outputId = "nwbvplot")
              )),
    nav_panel("ASF", 
              card(
                card_header("ASF Histogram"),
                plotlyOutput(outputId = "asfplot")
              ))
  )
) 

# Define server ----
server <- function(input, output, session) {
  

  ## MMSE Histogram ----
  output$mmseplot <- renderPlotly({
    
    p <- plotly::plot_ly(data = oasis_df,
                         x = ~.data[['mmse']],
                         color = ~.data[[input$gvar]],
                         colors = "Pastel1",
                         alpha = 0.6,
                         hovertemplate = paste('MMSE: %{x}',
                                               '<br>Counts: %{y}<br>')) |>
                           plotly::add_histogram() |>
                           plotly::layout(xaxis  = list(title = "MMSE"),
                                          yaxis  = list(title = "Counts", showgrid = T),
                                          legend = list(title = list(text = input$gvar), orientation = "v"),
                                          updatemenus = list(
                                            list(
                                              x = 1.3,
                                              y = 0.4,
                                              type = "buttons",
                                              buttons = list(
                                                list(method = "relayout",
                                                     args = list("barmode", "group"),
                                                     label = "Group"),
                                                list(method = "relayout",
                                                     args = list("barmode", "stack"),
                                                     label = "Stack"),
                                                list(method = "relayout",
                                                     args = list("barmode", "overlay"),
                                                     label = "Overlay"))))
                           )
                         
   return(p)  
                         
  })
  
    
  ## eTIV Histogram ----
  output$etivplot <- renderPlotly({
    
    p <- plotly::plot_ly(data = oasis_df,
                         x = ~.data[['etiv']],
                         color = ~.data[[input$gvar]],
                         colors = "Pastel1",
                         alpha = 0.6,
                         hovertemplate = paste('eTIV: %{x}',
                                               '<br>Counts: %{y}<br>')) |>
      plotly::add_histogram() |>
      plotly::layout(xaxis  = list(title = "eTIV"),
                     yaxis  = list(title = "Counts", showgrid = T),
                     legend = list(title = list(text = input$gvar), orientation = "v"),
                     updatemenus = list(
                       list(
                         x = 1.3,
                         y = 0.4,
                         type = "buttons",
                         buttons = list(
                           list(method = "relayout",
                                args = list("barmode", "group"),
                                label = "Group"),
                           list(method = "relayout",
                                args = list("barmode", "stack"),
                                label = "Stack"),
                           list(method = "relayout",
                                args = list("barmode", "overlay"),
                                label = "Overlay"))))
      )
    
    return(p)  
    
  })
  
  ## nWBV Histogram ----
  output$nwbvplot <- renderPlotly({
    
    p <- plotly::plot_ly(data = oasis_df,
                         x = ~.data[['nwbv']],
                         color = ~.data[[input$gvar]],
                         colors = "Pastel1",
                         alpha = 0.6,
                         hovertemplate = paste('nWBV: %{x}',
                                               '<br>Counts: %{y}<br>')) |>
      plotly::add_histogram() |>
      plotly::layout(xaxis  = list(title = "nWBV"),
                     yaxis  = list(title = "Counts", showgrid = T),
                     legend = list(title = list(text = input$gvar), orientation = "v"),
                     updatemenus = list(
                       list(
                         x = 1.3,
                         y = 0.4,
                         type = "buttons",
                         buttons = list(
                           list(method = "relayout",
                                args = list("barmode", "group"),
                                label = "Group"),
                           list(method = "relayout",
                                args = list("barmode", "stack"),
                                label = "Stack"),
                           list(method = "relayout",
                                args = list("barmode", "overlay"),
                                label = "Overlay"))))
      )
    
    return(p)  
    
  })
  
  
  ## eTIV Histogram ----
  output$asfplot <- renderPlotly({
    
    p <- plotly::plot_ly(data = oasis_df,
                         x = ~.data[['asf']],
                         color = ~.data[[input$gvar]],
                         colors = "Pastel1",
                         alpha = 0.6,
                         hovertemplate = paste('ASF: %{x}',
                                               '<br>Counts: %{y}<br>')) |>
      plotly::add_histogram() |>
      plotly::layout(xaxis  = list(title = "ASF"),
                     yaxis  = list(title = "Counts", showgrid = T),
                     legend = list(title = list(text = input$gvar), orientation = "v"),
                     updatemenus = list(
                       list(
                         x = 1.3,
                         y = 0.4,
                         type = "buttons",
                         buttons = list(
                           list(method = "relayout",
                                args = list("barmode", "group"),
                                label = "Group"),
                           list(method = "relayout",
                                args = list("barmode", "stack"),
                                label = "Stack"),
                           list(method = "relayout",
                                args = list("barmode", "overlay"),
                                label = "Overlay"))))
      )
    
    return(p)  
    
  })
  
  
  
}
# Create a Shiny app object
shinyApp(ui = ui, server = server)