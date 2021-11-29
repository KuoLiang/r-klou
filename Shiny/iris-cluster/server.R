library(datasets)
i = 0
function(input, output, session) {
  
  # Combine the selected variables into a new data frame
  selectedData <- reactive(
    {
      iris[, c(input$xcol, input$ycol)] 
      #使用者在 ui.R 選擇的XY軸,作為 iris 欄位篩選用
    }) #set the reactive function as a function return to selectData()
  
  clusters <- reactive(
    {
      kmeans(selectedData(), input$clusters)
      #使用者在 ui.R 選擇的 cluster number 作為 kmeans 的第二個參數
    }) #set the reactive function as a function return to clusters()
  
  output$text = renderText({
    print(input$clusters)
  })
  
  output$plot1 <- renderPlot({
    palette(c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3",
              "#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999"))
    
    par(mar = c(5.1, 4.1, 0, 1)) #set the margin
    
    plot(selectedData(),
         col = clusters()$cluster,  #color
         pch = 20, cex = 3)         #set the point character and cex expand
    #col : color
    #pch : plot character 4 = X ; 3 = + ; etc.
    #cex : expand the mark
    
    points(clusters()$centers, pch = 3, cex = 4, lwd = 4) 
    #point out the center

    #lwd : line width
  })
  
}
