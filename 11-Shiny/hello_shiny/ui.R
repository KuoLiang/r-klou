
shinyUI(
  fluidPage(
  titlePanel("Hello"),
  titlePanel("World"),
  titlePanel("I am klou")
  )
)

#fluidPage(): AWD的概念，建議使用
#fixedPage(): 頁面固定，以fixedRow()排版
#navbarPage(): 導覽頁簽式，以tabPanel()設定
#bootstrapPage(): HTML/CSS客製化設定頁面
#fillPage(): 填滿頁面，不建議使用
