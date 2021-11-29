library(shiny)

# Define UI for IRIS application
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Shiny IRIS Dataset: 這是標題"),
  
  # Sidebar 
  sidebarPanel(
    
    h3("請選擇二個觀察變數"),
    selectInput("variable1", "X軸",
                list("Sepal length" = "Sepal.Length",
                     "Sepal width"  = "Sepal.Width",
                     "Petal length" = "Petal.Length",
                     "Petal width"  = "Petal.Width")),
    
    selectInput("variable2", "Y軸",
                list("Petal length" = "Petal.Length",
                     "Petal width"  = "Petal.Width",
                     "Sepal length" = "Sepal.Length",
                     "Sepal width"  = "Sepal.Width"))
  ),

  mainPanel(
    tabsetPanel(
      tabPanel("Plot",  # tab 的顯示字
               h3 ("* Here, The plot of the two selected variables:"),
               h3(textOutput("caption")),
               plotOutput("plot")),
      tabPanel("Readme", # tab 的顯示字
               h3("感謝https://rpubs.com/meldow/Shiny-IRIS提供範例"),
               h3(""),
               h3(""),
               h3("The head of IRIS dataset:"),
               verbatimTextOutput("head")),

    ))
))