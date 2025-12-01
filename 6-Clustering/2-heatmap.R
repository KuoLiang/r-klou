##########################################
#Editor: Kuo-Liang Ou
#National Tsing Hua University ILST
##########################################
#矩陣 (matrix) 是二維資料物件
#由列 (row) 與行 (column) 組成
#dist Distance Matrix Computation
dist(c(1:10)) #try the dist function 10點一維空間距離
dist(cbind(c(1:10),c(1:10)),method="manhattan") # change the method
dist(cbind(c(1:10),c(1:10)),method="euclidean")  #10點二維空間距離 XY座標
dist(cbind(c(1:10),c(1:10),c(1:10)),method="euclidean") #10點三維空間距離

irisMatrix = as.matrix(dist(iris[,1:4])) #put the distances into Matrix
irisMatrix
heatmap(irisMatrix)  #因為 heapmap 只接受相同資料型態之二維 matrix 

#another heatmap :Pretty Heatmaps 不同的畫圖法
if(!require(pheatmap)) install.packages("pheatmap")
library(pheatmap)
pheatmap(irisMatrix,)
pheatmap(irisMatrix,kmeans_k = 2)  #搭配 kmenas
pheatmap(irisMatrix,kmeans_k = 3)
pheatmap(irisMatrix,kmeans_k = 4)
#各種內建調色盤
pheatmap(irisMatrix,kmeans_k = 4,heat.colors(100))
pheatmap(irisMatrix,kmeans_k = 4,terrain.colors(100))
pheatmap(irisMatrix,kmeans_k = 4,topo.colors(100))
pheatmap(irisMatrix,kmeans_k = 4,rainbow(100))
#######
# see https://r-graph-gallery.com/3d.html

install.packages("scatterplot3d")
library("scatterplot3d")
scatterplot3d(iris)
scatterplot3d(iris[,1:3],pch = 10, color="blue")
scatterplot3d(iris$Sepal.Length,iris$Sepal.Width,iris$Petal.Length)

colors <- c("red", "green", "blue")
colors <- colors[as.numeric(iris$Species)]
scatterplot3d(iris[,1:3], pch = 16, color=colors)
### matrix 介紹
#matrix(data=NA, nrow=1, ncol=1, byrow=FALSE, dimnames=NULL)
mdat <- matrix(c(1,2,3, 11,12,13), nrow = 2, ncol = 3, byrow = TRUE,
               dimnames = list(c("row1", "row2"),
                               c("C.1", "C.2", "C.3")))
mdat

a = c(1,2,3)
b= as.matrix(dist(a))

c=matrix(1:12, 3, 4)    #建立 3列 * 4 行矩陣 bycol
c
d=matrix(1:12, ncol=4)
d
e= matrix(1:12) 
e
