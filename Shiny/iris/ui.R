library(shiny)

# Define UI for IRIS application
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("這是標題，感謝Moawia Eldow 提供範例"),
  
  
  # Sidebar with controls to select the variables to plot 
  sidebarPanel(
    h3("https://github.com/moawia-eldow/Shiny-IRIS"),
    h3("請選擇"),
    selectInput("variable1", "X軸",
                list("萼長" = "Sepal.Length",
                     "萼寬"  = "Sepal.Width",
                     "瓣長" = "Petal.Length",
                     "瓣寬"  = "Petal.Width")),
    
    selectInput("variable2", "Y軸",
                list("Petal length" = "Petal.Length",
                     "Petal width"  = "Petal.Width",
                     "Sepal length" = "Sepal.Length",
                     "Sepal width"  = "Sepal.Width"))
  ),
  
  #在 server.R 中對應的程式碼如下
  #output$plot <- renderPlot({
  #  p <- ggplot(iris, aes_string(x=input$variable1, 
  #                               y=input$variable2, 
  #                               colour="Species")) + geom_point()
  #  print(p)
  #})
  
  mainPanel(
    tabsetPanel(                   #標簽集
      tabPanel("2D圖示",plotOutput("plot")),
      tabPanel("範例2",plotOutput("plot2",width="100%",height="600px")),
      tabPanel("範例3",plotOutput("plot3")), 
      tabPanel("關於本範例",verbatimTextOutput("head")),
      
      h3 ("Foot note here")
    ))
))