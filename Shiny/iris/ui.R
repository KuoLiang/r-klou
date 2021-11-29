library(shiny)

# Define UI for IRIS application
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Moawia Eldow - Using Shiny with IRIS Dataset: Plotting Two Variables"),
  
  # Sidebar with controls to select the variables to plot 
  sidebarPanel(
    
    h3("* Select two varibles to be ploted:"),
    selectInput("variable1", "First variable:",
                list("Sepal length" = "Sepal.Length",
                     "Sepal width"  = "Sepal.Width",
                     "Petal length" = "Petal.Length",
                     "Petal width"  = "Petal.Width")),
    
    selectInput("variable2", "Second variable:",
                list("Petal length" = "Petal.Length",
                     "Petal width"  = "Petal.Width",
                     "Sepal length" = "Sepal.Length",
                     "Sepal width"  = "Sepal.Width"))
  ),
  
  mainPanel(
    tabsetPanel(
      tabPanel("Plot", 
               h3 ("* Here, The plot of the two selected variables:"),
               h3(textOutput("caption")),
               plotOutput("plot")),
      
      tabPanel("Readme", 
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