library(shiny)
library(bslib)
library(modeldata)
library(DT)

# Load example dataset ----
# ad_data is included in the modeldata package.
data(ad_data)

# Define UI for app that draws a histogram ----
ui <- page_sidebar(
  # App title ----
  title = "Hello AAIC!",
  # Sidebar panel for inputs ----
  sidebar = sidebar(
    # Input: Slider for the number of rows ----
    sliderInput(
      inputId = "rows",
      label = "Number of rows:",
      min = 10,
      max = 30,
      value = 10
    ),
    
    # Input: Slider for the number of bins for Histogram ----
    sliderInput(
      inputId = "bins",
      label = "Number of bins:",
      min = 10,
      max = 30,
      value = 10
    ),
    
    
    textInput(inputId = "name",
              label = "Your Name:")
  ),
  
  # Output: Tables ----
  textOutput("greeting"),
  
  navset_card_underline(
    nav_panel("Plot", plotOutput(outputId = "adPlot")),
    nav_panel("Table", tableOutput(outputId = "adTable")),
    nav_panel("DataTable", DT::dataTableOutput(outputId = "adDataTable"))
  )
)

# Define server logic required to draw a histogram ----
server <- function(input, output) {
  
  
  output$greeting <- renderText({
    paste("Welcome to AAIC, ", input$name, "!", sep = "")
  }) 
  
  output$adPlot <- renderPlot({
    
    x    <- ad_data$p_tau
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    hist(x, breaks = bins, col = "#4a0d66", border = "white",
         xlab = "p_tau",
         main = "Histogram of p_tau")
  })
  
  output$adTable <- renderTable({
    head(ad_data, input$rows)
  })
  
  output$adDataTable <- renderDataTable({
    
    DT::datatable(
      ad_data,
      options = list(
        pageLength = 10,
        searchHighlight = TRUE,
        scrollX = TRUE
      ),
      rownames = FALSE
    )
  })
  
}

shinyApp(ui = ui, server = server)