
# ============================================================
# 3d.R：用 rgl 畫學生學習資料的分群結果（3D 散布圖）
# ============================================================
# 這是 rgl.R 的延伸應用：把「學生學習資料」的分群結果畫成可旋轉的 3D 圖，
# 從不同的三個變數組合觀察各群學生的分布，並把每張圖存成網頁。
#
# 資料欄位（從程式內容推測）：
#   grade_point 平均成績、paytime 付出時間、fail_rate 不及格率、
#   a_ratio 認真度、cluster 分群結果（1~6 群）
#
# ⚠️ 執行前提：
#   1. 這個檔案沒有讀取資料的程式碼，執行前必須先準備好一個名為 data 的資料框，
#      裡面要有上面 5 個欄位（可能來自 5-Classfication/mysql_conn.R 讀取的 dp002_exam
#      資料表，再用 kmeans 等方法分群後加上 cluster 欄）。
#      如果沒有先建立 data，R 會把 data 當成內建函數 data()，在 data$color <- 那行出現錯誤：
#      「object of type 'closure' is not subsettable」
#   2. rgl 在 macOS 上需要先安裝 XQuartz（https://www.xquartz.org），說明見 rgl_註解.R
#   因為缺少資料和 XQuartz，這個範例沒有實際執行。
# ============================================================

#install.packages("rgl")
options(rgl.useNULL = TRUE)
#  不打開獨立的 3D 視窗，改在 Viewer 或網頁中顯示（要在 library(rgl) 之前設定）
library(rgl)
open3d()
#  開啟 3D 繪圖空間
# This is to output a rgl plot in a rmarkdown document.
# setupKnitr()

# Data: the iris data is provided by R
#data <- iris
#data <- data
#  以上是 rgl.R 留下的 iris 寫法，這裡改用學生資料，所以註解掉了

# Add a new column with color
mycolors <- c('royalblue1', 'darkcyan', 'oldlace','purple','red','yellow')
#  準備 6 種顏色，對應最多 6 個群
#data$color <- mycolors[ as.numeric(data$Species) ]
data$color <- mycolors[ as.numeric(data$cluster) ]
#  依分群編號 (1~6) 取出顏色，新增 color 欄
#  ⚠️ 如果還沒建立 data 資料框，這行會出錯（見開頭說明）

# Plot
#plot3d(
#  x=data$`Sepal.Length`, y=data$`Sepal.Width`, z=data$`Petal.Length`,
#  col = data$color,
#  type = 's',
#  radius = .1,
#  xlab="Sepal Length", ylab="Sepal Width", zlab="Petal Length")

# ------------------------------------------------------------
# 第一張圖：平均成績 × 付出時間 × 不及格率
# ------------------------------------------------------------
plot3d(
  x=data$`grade_point`, y=data$`paytime`, z=data$`fail_rate`,
  col = data$color,
  type = 's',
  radius = .01,
  xlab="平均成積", ylab="付出時間", zlab="不及格率")
#  type = 's' 畫成球體；radius = .01 球的半徑
#  （半徑要配合資料的數值範圍：資料可能已經正規化到 0~1，所以用很小的 0.01）
#  （「平均成積」應為「平均成績」，只是標籤文字，不影響執行）
rglwidget()
#  在 RStudio 的 Viewer 窗格中顯示可旋轉的 3D 圖
htmlwidgets::saveWidget(rglwidget(width = 800, height = 800),
                        file = "gpf.html",
                        libdir = "libs",
                        selfcontained = FALSE
)
#  存成網頁 gpf.html（g = grade、p = paytime、f = fail_rate），
#  需要的程式庫放在 libs 資料夾（分享時要和 html 一起給）

# ------------------------------------------------------------
# 第二張圖：平均成績 × 認真度 × 不及格率
# ------------------------------------------------------------
plot3d(
  x=data$`grade_point`, y=data$`a_ratio`, z=data$`fail_rate`,
  col = data$color,
  type = 's',
  radius = .01,
  xlab="平均成積", ylab="認真度", zlab="不及格率")
rglwidget()
htmlwidgets::saveWidget(rglwidget(width = 800, height = 800),
                        file = "gaf.html",
                        libdir = "libs",
                        selfcontained = FALSE
)
#  ⚠️ open3d() 只在最前面呼叫一次，plot3d() 預設會清除畫面再畫，
#     所以每張網頁只會有當時這張圖。如果發現圖疊在一起，可以在每個 plot3d() 前加 open3d()

# ------------------------------------------------------------
# 第三張圖：平均成績 × 付出時間 × 認真度
# ------------------------------------------------------------
plot3d(
  x=data$`grade_point`, y=data$`paytime`, z=data$`a_ratio`,
  col = data$color,
  type = 's',
  radius = .01,
  xlab="平均成積", ylab="付出時間", zlab="認真度")
rglwidget()
htmlwidgets::saveWidget(rglwidget(width = 1024, height = 968),
                        file = "gpa.html",
                        libdir = "libs",
                        selfcontained = FALSE
)

# ------------------------------------------------------------
# 第四張圖：不及格率 × 付出時間 × 認真度
# ------------------------------------------------------------
plot3d_(
  x=data$`fail_rate`, y=data$`paytime`, z=data$`a_ratio`,
  col = data$color,
  type = 's',
  radius = .01,
  xlab="不及格率", ylab="付出時間", zlab="認真度")
#  ⚠️ plot3d_ 多了一個底線，沒有這個函數，會出現「沒有這個函式 "plot3d_"」的錯誤。
#     修正：改成 plot3d(
#     因為這張圖畫不出來，接下來存的 fpa.html 會是「上一張圖」（第三張）的內容
rglwidget()
htmlwidgets::saveWidget(rglwidget(width = 1024, height = 968),
                        file = "fpa.html",
                        libdir = "libs",
                        selfcontained = FALSE
)

# To display in an R Markdown document:
rglwidget()

# To save to a file:
htmlwidgets::saveWidget(rglwidget(width = 1024, height = 968),
                        file = "3dscatter.html",
                        libdir = "libs",
                        selfcontained = FALSE
)
#  ⚠️ 會覆蓋這個資料夾中原有的 3dscatter.html（那是 rgl.R 產生的 iris 3D 圖）

# ============================================================
# 重點整理
# ============================================================
# 1. 分群後，用群編號 cluster 當顏色，就能在 3D 圖中看出各群的分布
# 2. 同一份資料換不同的三個變數組合，可以從不同角度觀察分群結果
# 3. saveWidget() 存成網頁，方便放在報告或分享
#
# 練習題
# 1. 用 iris 練習：data <- iris; data$cluster <- kmeans(iris[,1:4], 3)$cluster，再執行本檔
# 2. 修正 plot3d_ 的錯字，確認 fpa.html 顯示的是不及格率、付出時間、認真度
# 3. 把 radius 調大或調小，找出最容易觀察的球體大小
