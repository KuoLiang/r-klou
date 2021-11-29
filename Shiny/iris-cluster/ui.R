#頁面(page),版型(layout)與版面(panel)
#fluidPage中常用titlePanel()定標題；並使用sidebarLayout()設定 page
  #在版型(layout)中再使用版面(panel)函數進階設定
  #sidebarLayout()函數中常用sidebarPanel()與mainPanel()

library(datasets)

vars <- setdiff(names(iris), "Species")

pageWithSidebar(
  headerPanel('Iris k-means clustering'),  #the title
  
  #read users' input
  sidebarPanel(
    selectInput('xcol', 'X Variable', vars), #input id , labels, choices vector
    selectInput('ycol', 'Y Variable', vars, selected = vars[[2]]),
    #numericInput('clusters', 'Cluster count', 3, min = 1, max = 9)
    sliderInput('clusters','Cluster count', min=1, max=9, value=3),
    
    textInput("txt", "Enter the text to display below:"),
    
    #文字區給 server.R 使用
    textOutput("text"),
    verbatimTextOutput("verb")
  ),
  #textOutput() is usually paired with renderText() in server.R
  #and puts regular text in <div> or <span>; 
  #verbatimTextOutput() is usually paired with renderPrint() in server.R
  #and provides fixed-width text in a <pre>.

  #圖形區；plot1 給 server.R 使用
  mainPanel(
    plotOutput('plot1')     
  )
)
