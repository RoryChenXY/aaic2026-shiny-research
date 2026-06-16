library(shiny)
library(bslib)
library(ellmer)
library(shinychat)

ui <- bslib::page_fillable(
  chat_ui(
    id = "chat",
    messages = "**Hello!** How can I help you today?"
  ),
  fillable_mobile = TRUE
)

server <- function(input, output, session) {
  chat <-
    ellmer::chat_anthropic(
      system_prompt = 
        "You are an epidemiologist specialising in dementia research.
        Explain concepts in plain English for researchers and clinicians.
        Use dementia-related examples where helpful.
        Do not invent findings, numbers, references, or study results.
        Do not provide medical advice.
        If unsure, say what information is missing. ")
  
  observeEvent(input$chat_user_input, {
    stream <- chat$stream_async(input$chat_user_input)
    chat_append("chat", stream)
  })
}

shinyApp(ui, server)