##########################################
#Editor: Kuo-Liang Ou
#National Tsing Hua University ILST
##########################################
# ============================================================
# 6-2 距離矩陣、熱圖與 3D 散布圖
# ============================================================
# 分群的基礎是「距離」：距離越近，越相似，越應該在同一群。
# 這個範例教你：
#   1. 用 dist() 計算距離，比較歐氏距離和曼哈頓距離
#   2. 用 heatmap()、pheatmap() 把距離矩陣畫成熱圖，並結合 k-means
#   3. 用 scatterplot3d 畫 3D 散布圖
#   4. 認識矩陣 (matrix)
#   （第 2~4 部分和 3-6 範例大致相同）
#
# 說明：#> 是 R 4.6.1 實際執行的結果；圖形用文字描述。
# ============================================================

# ------------------------------------------------------------
# 第一部分：dist() 距離計算
# ------------------------------------------------------------
#矩陣 (matrix) 是二維資料物件
#由列 (row) 與行 (column) 組成
#dist Distance Matrix Computation
dist(c(1:10)) #try the dist function 10點一維空間距離
#  10 個點排在一條數線上（1, 2, ..., 10），兩兩之間的距離
#  結果只顯示「下三角」，因為 A 到 B 和 B 到 A 的距離相同，對角線（自己到自己）都是 0
#>    1 2 3 4 5 6 7 8 9
#> 2  1
#> 3  2 1
#> 4  3 2 1
#> 5  4 3 2 1
#>  ...（省略）...
dist(cbind(c(1:10),c(1:10)),method="manhattan") # change the method
#  cbind() 組成 10 個二維座標點：(1,1)、(2,2)、...、(10,10)
#  曼哈頓距離 = |x1 - x2| + |y1 - y2|，像在棋盤狀的街道上只能直走、橫走
#  (1,1) 到 (2,2)：1 + 1 = 2
#>    1  2  3  4 ...
#> 2   2
#> 3   4  2
#>  ...（省略）...
dist(cbind(c(1:10),c(1:10)),method="euclidean")  #10點二維空間距離 XY座標
#  歐氏距離 = √((x1-x2)² + (y1-y2)²)，就是直線距離（dist 的預設方法）
#  (1,1) 到 (2,2)：√(1 + 1) = 1.414
#>           1         2 ...
#> 2   1.414214
#> 3   2.828427  1.414214
#>  ...（省略）...
dist(cbind(c(1:10),c(1:10),c(1:10)),method="euclidean") #10點三維空間距離
#  三維座標 (1,1,1)、(2,2,2)…：(1,1,1) 到 (2,2,2) 是 √3 = 1.732
#  dist() 可以處理任意維度，iris 就是 4 維

# ------------------------------------------------------------
# 第二部分：距離矩陣熱圖
# ------------------------------------------------------------
irisMatrix = as.matrix(dist(iris[,1:4])) #put the distances into Matrix
#  150 朵花兩兩之間的距離，as.matrix() 轉成完整的 150 × 150 方形矩陣
irisMatrix
#  印出來非常大（150 × 150）
heatmap(irisMatrix)  #因為 heapmap 只接受相同資料型態之二維 matrix
#  R 內建熱圖：顏色代表距離（紅 = 近、黃白 = 遠）
#  上方和左方的樹狀圖是自動做的階層式分群，相似的花會排在一起，形成幾個方塊

#another heatmap :Pretty Heatmaps 不同的畫圖法
if(!require(pheatmap)) install.packages("pheatmap")
library(pheatmap)
pheatmap(irisMatrix) # x y 分別為 150 iris 編號，顏色為距離
#  pheatmap 預設配色：藍 = 距離小、紅 = 距離大，右邊有顏色圖例
pheatmap(irisMatrix,kmeans_k = 2)  #搭配 kmenas x 為編號，y 為 cluster 中心，顏色為距離
#  kmeans_k = 2：先把 150 列用 k-means 分成 2 群，每群只畫一列（該群的平均）
#  所以圖變成 2 列 × 150 欄，列名稱會顯示「Cluster: 1 Size: …」
#  （kmeans 有隨機性，每次的群大小可能略有不同）
pheatmap(irisMatrix,kmeans_k = 3)
pheatmap(irisMatrix,kmeans_k = 4)
#  分別分成 3、4 群比較
#各種內建調色盤
pheatmap(irisMatrix,kmeans_k = 4,heat.colors(100))
#  第 2 個位置的參數是 color（色盤）；heat.colors(100) 產生 100 色的「熱度」漸層（紅 → 黃 → 白）
pheatmap(irisMatrix,kmeans_k = 4,terrain.colors(100))
#  地形色：綠 → 黃 → 棕 → 白
pheatmap(irisMatrix,kmeans_k = 4,topo.colors(100))
#  地圖色：藍 → 綠 → 黃
pheatmap(irisMatrix,kmeans_k = 4,rainbow(100))
#  彩虹色（顏色太多，通常不容易判讀大小，正式報告較少使用）

# ------------------------------------------------------------
# 第三部分：3D 散布圖
# ------------------------------------------------------------
#######
# see https://r-graph-gallery.com/3d.html

install.packages("scatterplot3d")
#  每次執行都會重新安裝；建議改成 if (!require("scatterplot3d")) install.packages("scatterplot3d")
library("scatterplot3d")
scatterplot3d(iris)
#  丟進整個資料框時，只用前 3 欄當 x、y、z 軸
scatterplot3d(iris[,1:3],pch = 10, color="blue")
#  pch = 10：點的形狀（圓圈內有十字）；color：點的顏色
scatterplot3d(iris$Sepal.Length,iris$Sepal.Width,iris$Petal.Length)
#  分別指定三個軸，結果和第一張相同

colors <- c("red", "green", "blue")
colors <- colors[as.numeric(iris$Species)]
#  as.numeric(Species) 把品種轉成 1、2、3，再取出對應的顏色
#  → 每朵花一個顏色（150 個），setosa 紅、versicolor 綠、virginica 藍
scatterplot3d(iris[,1:3], pch = 16, color=colors)
#  pch = 16：實心圓點；依品種上色，可以看出 setosa 和另外兩種明顯分開
#  （想畫可以旋轉的 3D 圖，請見同資料夾的 rgl.R）

# ------------------------------------------------------------
# 第四部分：矩陣介紹
# ------------------------------------------------------------
### matrix 介紹
#matrix(data=NA, nrow=1, ncol=1, byrow=FALSE, dimnames=NULL)
mdat <- matrix(c(1,2,3, 11,12,13), nrow = 2, ncol = 3, byrow = TRUE,
               dimnames = list(c("row1", "row2"),
                               c("C.1", "C.2", "C.3")))
#  nrow 列數、ncol 欄數；byrow = TRUE 一列一列填入；dimnames = list(列名, 欄名)
mdat
#>      C.1 C.2 C.3
#> row1   1   2   3
#> row2  11  12  13

a = c(1,2,3)
b= as.matrix(dist(a))
#  1、2、3 三個點的距離矩陣：
#>   1 2 3
#> 1 0 1 2
#> 2 1 0 1
#> 3 2 1 0

c=matrix(1:12, 3, 4)    #建立 3列 * 4 行矩陣 bycol
c
#  預設 byrow = FALSE，一欄一欄填入
#>      [,1] [,2] [,3] [,4]
#> [1,]    1    4    7   10
#> [2,]    2    5    8   11
#> [3,]    3    6    9   12
d=matrix(1:12, ncol=4)
d
#  只指定 4 欄，R 自動算出 3 列，結果和 c 相同
e= matrix(1:12)
e
#  沒有指定列數和欄數 → 12 列 × 1 欄

# ============================================================
# 重點整理
# ============================================================
# | 距離           | 公式                       | dist() 寫法                   |
# |----------------|----------------------------|-------------------------------|
# | 歐氏距離       | √(Σ(差)²)，直線距離        | dist(x)（預設）               |
# | 曼哈頓距離     | Σ|差|，只能直走橫走        | dist(x, method = "manhattan") |
#
# heatmap() / pheatmap()：把距離矩陣畫成熱圖，並自動做階層式分群
# pheatmap(..., kmeans_k = k)：先用 k-means 分群，每群畫一列
#
# 練習題
# 1. 計算 (0,0) 和 (3,4) 兩點的歐氏距離和曼哈頓距離：dist(rbind(c(0,0), c(3,4)), method = ...)
# 2. 先把 iris 標準化再算距離：dist(scale(iris[,1:4]))，熱圖有什麼不同？
# 3. 用 pheatmap(irisMatrix, kmeans_k = 3) 畫圖，三群的大小和 iris 三個品種各 50 朵接近嗎？
