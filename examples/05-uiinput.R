library(shiny)
library(bslib)

# Define UI ----
ui <- page_fillable(
  titlePanel("Basic widgets"),
  layout_columns(
    card(
      card_header("Single checkbox"),
      checkboxInput("checkbox", "Checkbox",value = FALSE)
    ),
    card(
      card_header("Radio buttons"),
      radioButtons(
        "radio",
        "Select option",
        choices = list("Choice 1" = 1, "Choice 2" = 2, "Choice 3" = 3),
        selected = 1
      )
    ),
    card(
      card_header("Select box"),
      selectInput(
        "select",
        "Select option",
        choices = list("Choice 1" = 1, "Choice 2" = 2, "Choice 3" = 3),
        selected = 1
      )
    ),
    card(
      card_header("Checkbox group"),
      checkboxGroupInput(
        "checkGroup",
        "Select all that apply",
        choices = list("Choice 1" = 1, "Choice 2" = 2, "Choice 3" = 3),
        selected = 1
      )
    ),
    card(
      card_header("Select (Multiple)"),
      selectInput(
        "selectmulti",
        "Select option (Multiple)",
        choices = list("Choice 1" = 1, "Choice 2" = 2, "Choice 3" = 3),
        selected = 1,
        multiple = TRUE
      ),
    ),
    card(
      card_header("Date input"),
      dateInput("date", "Select date", value = "2026-07-10")
    ),
    card(
      card_header("Date range input"),
      dateRangeInput("dates", "Select dates")
    ),
    card(
      card_header("Numeric input"),
      numericInput("num", "Input number", value = 1)
    ),
    
    card(
      card_header("Sliders"),
      sliderInput(
        "slider1",
        "Set value",
        min = 0,
        max = 100,
        value = 50
      )
    ),
    card(
      card_header("Slider range"),
      sliderInput(
        "slider2",
        "Set value range",
        min = 0,
        max = 100,
        value = c(25, 75)
      )          
    ),
    
    col_widths = c(2,3,4,3, 
                   5, 3,4,
                   -1,2, 4, 5),
    row_heights = c(4,5,3)
      
  )
)


server <- function(input, output, session) {

  
}

# Run the app -----
shinyApp(ui = ui, server = server)