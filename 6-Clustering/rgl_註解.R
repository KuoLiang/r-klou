
# ============================================================
# rgl.R：用 rgl 畫可以旋轉的 3D 散布圖，並存成網頁
# ============================================================
# rgl 套件可以畫出互動式 3D 圖：用滑鼠拖曳旋轉、滾輪縮放。
# 這個範例用 iris 的三個尺寸當 x、y、z 軸，依品種上色，
# 最後存成 HTML 網頁，用瀏覽器打開就能旋轉觀看（同資料夾的 3dscatter.html 就是成品）。
#
# ⚠️ 執行前提（Mac）：
#   rgl 在 macOS 上需要先安裝 XQuartz（https://www.xquartz.org），
#   否則 library(rgl) 會出現「無法載入共享物件 … libGLU.1.dylib」的錯誤。
#   安裝 XQuartz 後要登出再登入（或重新開機）。Windows 不需要。
#   因為這台電腦沒有 XQuartz，這個範例沒有實際執行，以下是依照程式說明預期的結果。
# ============================================================

#install.packages("rgl")
options(rgl.useNULL = TRUE)
#  rgl.useNULL = TRUE：不打開獨立的 3D 視窗，改成在 RStudio 的 Viewer 或網頁中顯示
#  （一定要在 library(rgl) 之前設定才有效）
library(rgl)
open3d()
#  開啟一個新的 3D 繪圖空間
# This is to output a rgl plot in a rmarkdown document.
# setupKnitr()
#  （在 R Markdown 文件中使用 rgl 時才需要 setupKnitr()）

# Data: the iris data is provided by R
data <- iris
#  （提醒：data 也是 R 內建函數 data() 的名稱，能執行但容易混淆，建議取名 iris_data）

# Add a new column with color
mycolors <- c('royalblue1', 'darkcyan', 'oldlace')
data$color <- mycolors[ as.numeric(data$Species) ]
#  as.numeric(Species)：把品種轉成 1、2、3
#  mycolors[1、2、3]：依編號取出顏色 → setosa 寶藍、versicolor 深青、virginica 米白
#  新增 color 欄，每朵花對應一個顏色
#  （oldlace 是很淡的米白色，在白色背景上不太明顯，可以換成 "tomato" 等深一點的顏色）

# Plot
plot3d(
  x=data$`Sepal.Length`, y=data$`Sepal.Width`, z=data$`Petal.Length`,
  col = data$color,
  type = 's',
  radius = .1,
  xlab="Sepal Length", ylab="Sepal Width", zlab="Petal Length")
#  plot3d()：3D 散布圖
#    x、y、z：三個軸的資料（欄位名稱外的反引號 ` ` 在名稱沒有特殊字元時可以省略）
#    col：每個點的顏色
#    type = 's'：畫成球體 (sphere)；'p' 是點
#    radius = .1：球的半徑，要依資料的數值範圍調整
#    xlab、ylab、zlab：三個軸的標題

# To display in an R Markdown document:
# rglwidget()
#  rglwidget()：在 RStudio 的 Viewer 窗格中顯示可以旋轉的 3D 圖

# To save to a file:
htmlwidgets::saveWidget(rglwidget(width = 520, height = 520),
                        file = "3dscatter.html",
                        libdir = "libs",
                        selfcontained = FALSE
)
#  把 3D 圖存成網頁檔：
#    width、height：圖的大小（像素）
#    file：檔名，存在目前的工作目錄
#    libdir = "libs"：網頁需要的 JavaScript 程式庫放在 libs 資料夾
#    selfcontained = FALSE：網頁和 libs 資料夾分開存放；
#      要分享給別人時，html 檔和 libs 資料夾要一起給
#      （改成 TRUE 會把所有東西包成單一檔案，但需要安裝 pandoc）
#  ⚠️ 注意：執行後會覆蓋這個資料夾中原有的 3dscatter.html

# ============================================================
# 重點整理
# ============================================================
# | 函數                       | 用途                               |
# |----------------------------|------------------------------------|
# | options(rgl.useNULL = TRUE)| 不開獨立視窗，改用網頁顯示         |
# | open3d()                   | 開啟 3D 繪圖空間                   |
# | plot3d(x, y, z, col, type) | 3D 散布圖                          |
# | rglwidget()                | 在 Viewer 顯示可旋轉的圖           |
# | htmlwidgets::saveWidget()  | 存成網頁檔                         |
#
# 練習題
# 1. 把 z 軸換成 Petal.Width，觀察三個品種是否分得更開
# 2. 把 type 改成 'p'，比較球體和點的差別
# 3. 改用 kmeans 分群結果上色（見 1-KMeans-HClust-Iris.R）：mycolors[kmeans(iris[,1:4], 3)$cluster]
