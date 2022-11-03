library(shiny)
ui<-fluidPage(
  # 1.整體網頁佈局設計：大標題
  titlePanel("不同所得家庭水準所面對的物價指數變化"),
  navlistPanel(
    tabPanel("Nav 1"),
    tabPanel("Nav 2"),
    tabPanel("Nav 3")
  ),
  sidebarLayout(
    sidebarPanel(
      # 2. Input佈局設計：使用checkboxGroupInput
      checkboxGroupInput("income.levels",
                         label="請選擇所得水準",
                         choices=list("最低20%"=1,"中間60%"=2,"最高20%"=3),
                         selected=c(1,3))),

    mainPanel(
      # 3. Output佈局設計：使用textOutput
      textOutput("number.selected"))
    )
)
server <- function(input, output) {
  output$number.selected <- renderText(
    {
      input$income.levels
    }
  )
}
shinyApp(ui = ui, server = server)
