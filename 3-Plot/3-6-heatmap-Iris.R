#################################################
#其它繪圖功能 optional
#Heatmap
#################################################
# ============================================================
# 3-6 矩陣、熱圖 (Heatmap) 與 3D 散布圖
# ============================================================
# 熱圖用「顏色深淺」表示數值大小，適合一次看大量數字的模式。
# 這個範例教你：
#   1. 認識矩陣 (matrix) 的建立方式
#   2. 用 dist() 計算距離矩陣，再用 heatmap()、pheatmap() 畫熱圖
#   3. 用 ggplot2 的 geom_tile() 畫「x × y 格子、顏色 = 數值」的熱圖
#   4. 用 scatterplot3d 畫 3D 散布圖
#
# 說明：#> 是 R 4.6.1 實際執行的結果；圖形用文字描述。
# ============================================================

if (!require("ggplot2")) install.packages("ggplot2")
library(ggplot2)

# ------------------------------------------------------------
# 第一部分：矩陣 (matrix)
# ------------------------------------------------------------
#################################################
### matrix 介紹
# matrix 物件是由包含相同的元素組成的2維物件
#################################################
# 【補充】矩陣和資料框的差別：
#   矩陣 (matrix)：所有格子必須是「同一種型態」（例如全部都是數字）
#   資料框 (data.frame)：每一欄可以是不同型態（數字、文字、類別混用）
#matrix(data=NA, nrow=1, ncol=1, byrow=FALSE, dimnames=NULL)
mdat <- matrix(c(1,2,3, 11,12,13), nrow = 2, ncol = 3, byrow = TRUE,
               dimnames = list(c("row1", "row2"),
                               c("C.1", "C.2", "C.3")))
#  nrow = 列數、ncol = 欄數
#  byrow = TRUE：資料「一列一列」填入（先填滿第 1 列，再填第 2 列）
#  dimnames = list(列名稱, 欄名稱)
mdat
#>      C.1 C.2 C.3
#> row1   1   2   3
#> row2  11  12  13

a = c(1,2,3)
b= as.matrix(dist(a))
#  dist()：計算每兩個值之間的距離，as.matrix() 轉成方形矩陣
#  1 和 2 距離 1、1 和 3 距離 2、2 和 3 距離 1；對角線（自己和自己）是 0
#  b 的內容：
#>   1 2 3
#> 1 0 1 2
#> 2 1 0 1
#> 3 2 1 0

c=matrix(1:12, 3, 4)    #建立 3列 * 4 行矩陣 bycol
c
#  沒有寫 byrow 時，預設「一欄一欄」填入（先填滿第 1 欄，再填第 2 欄）
#>      [,1] [,2] [,3] [,4]
#> [1,]    1    4    7   10
#> [2,]    2    5    8   11
#> [3,]    3    6    9   12
d=matrix(1:12, ncol=4)
d
#  只指定 4 欄，R 會自動算出需要 12 ÷ 4 = 3 列，結果和 c 相同
e= matrix(1:12)
e
#  沒指定列數和欄數 → 預設 1 欄，變成 12 列 × 1 欄
#>       [,1]
#>  [1,]    1
#>  [2,]    2
#>  ...（省略）...
#> [12,]   12

# ------------------------------------------------------------
# 第二部分：距離矩陣熱圖
# ------------------------------------------------------------
###

irisMatrix = as.matrix(dist(iris[,1:4])) #dist() Distance Matrix Computation，euclidean distance is the default

#  dist()：計算 150 朵花「兩兩之間」的距離，預設是歐氏距離（直線距離）：
#    用 4 個欄位當座標，距離越小代表兩朵花越相似
#  結果是 150 × 150 的矩陣，第 i 列第 j 欄 = 第 i 朵和第 j 朵花的距離
#irisMatrix = as.matrix(iris)  #error , x must be a numeric matrix
#  如果把整個 iris（含文字欄 Species）轉成矩陣，所有格子都會變成文字，熱圖無法計算
irisMatrix
#>             1         2         3 ...
#> 1   0.0000000 0.5385165 0.5099020 ...
#> 2   0.5385165 0.0000000 0.3000000 ...
#>  ...（150 × 150，省略）...
heatmap(irisMatrix)
#  R 內建熱圖：顏色越深（紅）代表距離越小、越相似
#  上方和左方的樹狀圖是「階層式分群」的結果，相似的花會被自動排在一起，
#  所以可以看到幾個明顯的方塊，大致對應不同品種

# ------------------------------------------------------------
# 第三部分：比較漂亮的熱圖 pheatmap
# ------------------------------------------------------------
#################################################
#Pretty Heatmap
#################################################
if (!require("pheatmap")) install.packages("pheatmap")
library(pheatmap)
pheatmap(irisMatrix)
#  pheatmap = pretty heatmap，同樣會自動分群，但預設配色比較好看，
#  右邊還有顏色對應數值的圖例（藍色 = 距離小，紅色 = 距離大，和 heatmap() 相反）

# ------------------------------------------------------------
# 第四部分：用 ggplot2 的 geom_tile() 畫格子熱圖
# ------------------------------------------------------------
#################################################
#指定行列，值為顏色深淺 ( 3 variables)
#################################################
if (!require("RColorBrewer")) install.packages("RColorBrewer")
library(RColorBrewer)
#  RColorBrewer 提供很多配色好看的「色盤」

nw <- read.csv("NWSales.csv")
nw
ggplot(nw, aes(x = Year, y = ShipCountry, fill = Sales)) +
  geom_tile()
#  geom_tile()：畫格子。x = 年份、y = 國家、格子顏色 = 銷售額
#  同一個「年份 × 國家」通常有很多筆訂單，這些格子會「疊在同一個位置」，
#  最後看到的顏色只是其中一筆（最後畫上去的那筆），不是總和或平均。
#  正確做法是先彙總，再畫圖，例如：
nw_sum <- aggregate(Sales ~ Year + ShipCountry, data = nw, FUN = sum)
ggplot(nw_sum, aes(x = Year, y = ShipCountry, fill = Sales)) + geom_tile()

pal_c <- colorRampPalette((brewer.pal(6,"YlGnBu")), space="Lab") #6 colors of YlGnBu
#see https://bookdown.org/xiangyun/notesdown/subsec-color-palettes.html
#  brewer.pal(6, "YlGnBu")：從 RColorBrewer 取出「黃 → 綠 → 藍」6 個顏色
#  colorRampPalette()：用這 6 個顏色做出「漸層產生器」pal_c
#    之後 pal_c(100) 就會產生 100 個平滑漸層的顏色
#  space = "Lab"：在 Lab 色彩空間內插，漸層看起來比較自然

nw_sum2 <- aggregate(Sales ~ Year + ShipCountry + EmployeeID, data = nw, FUN = sum)
ggplot(nw_sum2, aes(x = EmployeeID, y = ShipCountry, fill = Sales)) +
  aes(label = Sales) +
  geom_tile(colour="white") + #框線白色
  scale_fill_gradientn(colours = pal_c(100))   #色盤
#  x = 員工、y = 年份及國家、顏色 = 銷售額
#  geom_tile(colour = "white")：格子之間用白線分隔
#  scale_fill_gradientn(colours = ...)：用自訂的 100 色漸層取代預設的藍色漸層
#  aes(label = Sales)：設定了文字標籤，但沒有加 geom_text()，所以圖上不會顯示數字
#    想在格子上顯示數字：加上 + geom_text()

ggplot(nw_sum2, aes(x = Year, y = ShipCountry, fill = Sales)) +
  aes(label = Sales) +
  geom_tile(colour="white") + #框線白色
  scale_fill_gradientn(colours = pal_c(100))   #色盤
# 你能解釋以上的熱區圖說了什麼？
# ------------------------------------------------------------
# 第五部分：3D 散布圖
# ------------------------------------------------------------
#################################################
# Scatterplot3d
#################################################
install.packages("scatterplot3d")
#  每次執行都會重新安裝；建議改成 if (!require("scatterplot3d")) install.packages("scatterplot3d")
library("scatterplot3d")
scatterplot3d(iris)
#  直接丟進整個資料框時，只會用前 3 欄當作 x、y、z 軸
#  （Sepal.Length、Sepal.Width、Petal.Length）
scatterplot3d(iris$Sepal.Length,iris$Sepal.Width,iris$Petal.Length)
#  明確指定三個軸，結果和上一張相同
#  加上顏色區分品種：scatterplot3d(iris[,1:3], color = as.numeric(iris$Species))




# ============================================================
# 重點整理
# ============================================================
# | 函數                    | 用途                                     |
# |-------------------------|------------------------------------------|
# | matrix()                | 建立矩陣，byrow 決定填入方向             |
# | dist()                  | 計算兩兩之間的距離                       |
# | heatmap() / pheatmap()  | 畫熱圖，並自動分群排序                   |
# | geom_tile()             | ggplot2 的格子熱圖（先彙總再畫）         |
# | colorRampPalette()      | 自訂漸層色盤                             |
# | scatterplot3d()         | 3D 散布圖                                |
