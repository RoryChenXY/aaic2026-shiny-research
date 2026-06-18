library(shiny)
library(bslib)
library(modeldata)
library(ggplot2)
library(plotly)
library(gtsummary)
library(gt)

# Load example dataset ----
# ad_data is included in the modeldata package.
data(ad_data)

# Define UI for app that draws a histogram ----
ui <- page_sidebar(
  # App title ----
  title = "AD Data",
  # Sidebar panel for inputs ----
  sidebar = sidebar(
    # Input: Filter APOE  ----
    selectInput(
      inputId  = "selected_geno",
      label    = "Select APOE Genotype:",
      choices  = levels(ad_data$Genotype),
      selected = levels(ad_data$Genotype),
      multiple = TRUE)   
    
    ## [EXERCISE] Add input to filter gender
  ),
  
  card(
    card_header("Summary Table and Plots"),
    "Use the tabs below to explore the summary table and plots.",
    uiOutput("filtered_n"),
    navset_tab(
      nav_panel("SummaryTable", gt_output(outputId = "summary")),
      nav_panel("Scatter Plot", plotlyOutput(outputId = "plot1"))
    ## [EXERCISE] Add another plot with variable of your choices
  ))
)

# Define server logic required to draw a histogram ----
server <- function(input, output, session) {
  
  ## [EXERCISE] update the reactive expression to filter by APOE and gender
  ad_filtered <- reactive({
    req(input$selected_geno)
    filter(ad_data, Genotype %in% input$selected_geno)
  })
  
  output$filtered_n <- renderUI({
    n <- nrow(ad_filtered())
    HTML(paste0("<b>Number of observations after filtering: ", n, "</b>"))
  })
  
  output$summary <- render_gt({
    ad_filtered() |>
      tbl_summary(
        by = Class,
        type = list(
          everything() ~ "continuous",
          c(male, Genotype) ~ "categorical"
        ),
        statistic = list(
          all_continuous() ~ "{mean} ({sd})",
          all_categorical() ~ "{n} ({p}%)"
        ),
        digits = list(
          all_continuous() ~ 2, 
          all_categorical() ~ c(0, 1)),
        missing = "no"
      ) |>
      add_overall() |>
      as_gt()
  })  
      
  output$plot1 <- renderPlotly({
    
    p <- ggplot(
      ad_filtered(),
      aes(x = age, y = p_tau, color = Class)
    ) +
      geom_point() +
      labs(
        x = "age",
        y = "p_tau",
        title = "Scatter Plot of p_tau vs age"
      ) +
      theme_minimal()
    
    ggplotly(p)
  })
  
  ## [EXERCISE] Add another plot with variable of your choices
  
}

shinyApp(ui = ui, server = server)