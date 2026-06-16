# Load packages
library(shiny)
library(bslib)
library(here)
library(dplyr)
library(gt)
library(gtsummary)
library(DT)
library(ggplot2)
library(plotly)

# Load data
oasis_df <- readRDS(here("data", "oasis_df.rds"))

# Define UI
ui <- page_sidebar(
  # App title ----
  title = "OASIS Data Explorer",
  sidebar = sidebar(
    ## Filter for age range (slider)
    sliderInput(
      "selected_age",
      "Set age range",
      min = 60,
      max = 100,
      value = c(60, 100)), 
    ## Filter for Gender
    checkboxGroupInput(
      inputId  = "selected_gender",
      label    = "Select Gender:",
      choices  = levels(oasis_df$mf),
      selected = levels(oasis_df$mf)),
    ## Filter for Socioeconomic status score
    checkboxGroupInput(
      inputId  = "selected_ses",
      label    = "Select Socioeconomic Status:",
      choices  = levels(oasis_df$ses),
      selected = levels(oasis_df$ses)),
    
    ## Choose x-axis variable 
    selectInput(inputId = "xvar",
                label = "X-axis:",
                choices = c("age", "educ"),
                selected = "age"),
    ## Choose y-axis variable
    selectInput(inputId = "yvar", 
                label = "Y-axis:",
                choices = c("mmse", "etiv", "nwbv", "asf"),
                selected = "mmse"),
    ## Choose grouping variable
    selectInput(inputId = "gvar", 
                label = "Grouping:",
                choices = c("group", "mf", "ses", "cdr"),
                selected = "mf")
  ),
  
  card(
    card_header("Summary Table and Plots"),
    "Use the tabs below to explore the OASIS data.",
    uiOutput("filtered_n"),
    navset_tab(
      nav_panel("SummaryTable", gt_output(outputId = "summary")),
      nav_panel("Data", dataTableOutput(outputId = "datadt")),
      nav_panel("Scatter plot", plotlyOutput(outputId = "scatterplot"))
    ))
  
  
) 

# Define server
server <- function(input, output, session) {
  
  ## Create the reactive expression
  oasis_filtered <- reactive({
    req(
      input$selected_age,
      input$selected_gender,
      input$selected_ses
    )
    
    oasis_df |>
      filter(
        visit == 1,
        age >= input$selected_age[1],
        age <= input$selected_age[2],
        mf %in% input$selected_gender,
        ses %in% input$selected_ses
      )
  })
  
  output$filtered_n <- renderUI({
    n <- nrow(oasis_filtered())
    HTML(paste0("<b>Number of observations after filtering: ", n, "</b>"))
  })
  
  output$summary <- render_gt({
    oasis_filtered() |>
      tbl_summary(
        by = group,
        include = -c(subject_id, mri_id, visit, mr_delay, hand),
        label = list(
          age ~ "Age (Years)",
          mf ~ "Sex", 
          educ ~ "Education (Years)",
          ses ~ "Socioeconomic Status",
          mmse ~ "Mini-Mental State Exam",
          cdr ~ "Clinical Dementia Rating",
          etiv ~ "Estimated Total Intracranial Volume",
          nwbv ~ "Normalized Whole Brain Volume",
          asf ~ "Atlas Scaling Factor"
        ),
        type = list(
          everything() ~ "continuous",
          c(mf, ses, cdr) ~ "categorical"
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
  
  # Check <https://rstudio.github.io/DT/> for more options
  
  output$datadt <- renderDT({
    datatable(
      oasis_filtered(),
      filter = "top", # Enable built-in filters at the top of the columns
      options = list(
        pageLength = 15, # Control initial page size
        autoWidth = TRUE, # Auto adjusting column width
        search = list(smart = TRUE, regex = TRUE), # Enable "smart" space-separated searching globally
        scrollX = TRUE # Enable horizontal scrolling for wide data frames
      )
    )
  })
  
  output$scatterplot <- renderPlotly({
    p <- ggplot(
      oasis_filtered(),
      aes(
        x = .data[[input$xvar]],
        y = .data[[input$yvar]],
        colour = .data[[input$gvar]],
        text = paste(
          "Subject:", subject_id,
          "<br>Age:", age,
          "<br>Sex:", mf,
          "<br>Group:", group
        ))) +
      geom_point(size = 2, alpha = 0.8) +
      labs(
        title = paste(input$xvar, "and", input$yvar),
        x = input$xvar,
        y = input$yvar,
        colour = input$gvar
      ) +
      theme_minimal()
    
    ggplotly(p, tooltip = "text")
    
  })

}

# Create a Shiny app object
shinyApp(ui = ui, server = server)