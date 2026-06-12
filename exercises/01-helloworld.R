library(shiny)
library(bslib)
# UI -----
ui <- bslib::page_fluid(
  h1("Hello, World!")
)
# Server -----
server <- function(input, output, session) {
}
# Run the app -----
shinyApp(ui = ui, server = server)