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
    tabsetPanel(
      tabPanel("圖示", 
               h3 ("* Here, The plot of the two selected variables:"),
               h3(textOutput("caption")),
               plotOutput("plot")),
      
      
      tabPanel("關於本範例", 
               h3 ("* Here, The documentaion about this application:"),
               h3 (""),
               h3("This shiny application used to plot two variables from IRIS data set."),
               h3("The head of IRIS dataset:"),
               verbatimTextOutput("head")),
      h3 (""),
      h3 ("To start, you need to select two variables from the list."),
      h3 ("Then, you can see the plot in the plot panel using species as colors."),
      h3 (""),
      h3 ("ENJOY IT")
    ))
))