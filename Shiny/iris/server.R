library(shiny)
library(datasets)
library(ggplot2)

data(iris)

# Define server logic required to plot variables
shinyServer(function(input, output) {
  
  # Create a reactive text
  text <- reactive({
    paste(input$variable1, '以及', input$variable2)
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
  
  #scatterplot3d(iris)
  output$plot2 <- renderPlot({
    colors <- c("red", "green", "blue")
    colors <- colors[as.numeric(iris$Species)]  #依品種編號123
    p3 <- scatterplot3d(iris[,1:3], pch = 16, color=colors)
    legend("right", legend = levels(iris$Species),
           col =  c("#999999", "#E69F00", "#56B4E9"), pch = 16)
    print(p3)
  })
  
  # Generate a head of the data
  output$head <- renderPrint({
    #head(iris)
    iris
  })
})