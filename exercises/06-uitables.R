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
    textInput(inputId = "name",
              label = "Your Name:")
  ),
  
  # Output: Tables ----
  textOutput("greeting"),
  
  navset_card_underline(
    
    ## [EXERCISE] set tableOutput's ouputID
    nav_panel("Table", tableOutput(outputId = ___________)),
    
    ## [EXERCISE] add DT::dataTableOutput()
    nav_panel("DataTable", _____________________________),
    
  )
  
  
  ,
  
)

# Define server logic required to draw a histogram ----
server <- function(input, output) {
  
  
  output$greeting <- renderText({
    paste("Welcome to AAIC, ", input$name, "!", sep = "")
  }) 
  
  ## [EXERCISE] Define tableOutput
  output$____________________ <- renderTable({
    head(ad_data, input$rows)
  })
  
  ## [EXERCISE] Define dataTableOutput
  output$____________________ <- renderDataTable({
    
    DT::datatable(
      ad_data,
      ## [OPTIONAL EXERCISE] Adjust the options following https://rstudio.github.io/DT/shiny.html
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