library(shiny)
library(bslib)

# UI -----
ui <- bslib::page_fluid(
  h1("Hello, World!"),
  # Add input
  textInput(inputId = 'name',
            label = 'Your Name:'),
  # Add output
  textOutput('greeting')
)
# Server -----
server <- function(input, output, session) {
  # Define the output
  # This expression that generates a text is wrapped in a call
  # to renderText to indicate that:
  # 1. It is "reactive" and therefore should be automatically
  #    re-executed when inputs (input$name) change
  # 2. Its output type is a text
  output$greeting <- renderText({
    paste('Hello, ', input$name, "!", sep = '')
  }) 
}  

# Run the app -----
shinyApp(ui = ui, server = server)
