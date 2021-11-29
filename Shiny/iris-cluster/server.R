library(datasets)
function(input, output, session) {
  
  # Combine the selected variables into a new data frame
  selectedData <- reactive(
    {
      iris[, c(input$xcol, input$ycol)]
    })
  
  clusters <- reactive(
    {
      kmeans(selectedData(), input$clusters)
    })
  
  output$plot1 <- renderPlot({
    palette(c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3",
              "#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999"))
    
    par(mar = c(5.1, 4.1, 0, 1)) #set the margin
    
    plot(selectedData(),
         col = clusters()$cluster,
         pch = 20, cex = 3)
    #col : color
    #pch : plot character 4 = X ; 3 = + ; etc.
    #cex : expand the mark
    
    points(clusters()$centers, pch = 3, cex = 4, lwd = 4) 
    #point out the center

    #lwd : line width
  })
  
}
