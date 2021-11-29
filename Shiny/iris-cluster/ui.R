#頁面(page),版型(layout)與版面(panel)
#fluidPage中常用titlePanel()定標題；並使用sidebarLayout()設定 page
  #在版型(layout)中再使用版面(panel)函數進階設定
  #sidebarLayout()函數中常用sidebarPanel()與mainPanel()


# k-means only works with numerical variables,
# so don't give the user the option to select
# a categorical variable
vars <- setdiff(names(iris), "Species")

pageWithSidebar(
  headerPanel('Iris k-means clustering'),
  sidebarPanel(
    selectInput('xcol', 'X Variable', vars),
    selectInput('ycol', 'Y Variable', vars, selected = vars[[2]]),
    numericInput('clusters', 'Cluster count', 3, min = 1, max = 9)
  ),
  mainPanel(
    plotOutput('plot1')
  )
)