library(shiny)
library(qrcode)

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      textInput("link", "Enter Link here", "www.google.com"),
      downloadButton("save", "Download QR")
    ),
    mainPanel(
      plotOutput("tplot" ) 
    )
  )
)

server <- function(input, output) {
  tplot <- reactive({
    qr <- qr_code(input$link)
    plot(qr)
    
  })
  output$tplot <- renderPlot({
    tplot()
  })
  
  # downloadHandler contains 2 arguments as functions, namely filename, content
  output$save <- downloadHandler(
    filename =  function() {
      paste("myplot.pdf")
    },
    # content is a function with argument file. content writes the plot to the device
    content = function(file) {
      pdf(file) # open the pdf device
      plot(qr_code(input$link)) # draw the plot
      dev.off()  # turn the device off
    } 
  )
}

# Run the app -----
shinyApp(ui = ui, server = server)