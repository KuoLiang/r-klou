library(shiny)
library(datasets)
library(ggplot2)

data(iris)

# Define server logic required to plot variables
shinyServer(function(input, output) {
  
  # Create a reactive text
  text <- reactive({
    paste(input$variable1, 'versus', input$variable2)
  })
  
  # Return as text the selected variables
  output$caption <- renderText({
    text()
  })
  
  # Generate a plot of the selected variables
  output$plot <- renderPlot({
    p <- ggplot(iris, aes_string(x=input$variable1, 
                                 y=input$variable2, 
                                 colour="Species")) + geom_point()
    print(p)
  })
  
  # Generate a head of the data
  output$head <- renderPrint({
    head(iris)
  })
})