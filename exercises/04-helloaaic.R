library(shiny)
library(bslib)

# Define UI for app that draws a histogram ----
ui <- page_sidebar(
  # App title ----
  ## [EXERCISE] Change the title to "Hello AAIC!"
  title = "Hello Shiny!",
  # Sidebar panel for inputs ----
  sidebar = sidebar(
    # Input: Slider for the number of bins ----
    sliderInput(
      inputId = "bins",
      label = "Number of bins:",
      min = 1,
      max = 50,
      value = 30
    )
    ## [EXERCISE] Add `textInput` to ask for the user's name in sidebar
  ),
  
  ## [EXERCISE] Add `textOutput` to greet the user in the main panel 
  
  # Output: Histogram ----
  plotOutput(outputId = "distPlot")
)

# Define server logic required to draw a histogram ----
server <- function(input, output) {
  
  ## [EXERCISE] Define the greeting output to display a personalized greeting using the user's name
  
  output$distPlot <- renderPlot({
    
    x    <- faithful$waiting
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    ## [EXERCISE] Change the histogram color to `#4a0d66` - AAIC purple
    hist(x, breaks = bins, col = "#007bc2", border = "white",
         xlab = "Waiting time to next eruption (in mins)",
         main = "Histogram of waiting times")
  })
  
}

shinyApp(ui = ui, server = server)