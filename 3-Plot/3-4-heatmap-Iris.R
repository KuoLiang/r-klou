#################################################
#其它繪圖功能 optional
#Heatmap
#################################################

if (!require("ggplot2")) install.packages("ggplot2")
library(ggplot2)

#################################################
### matrix 介紹
# matrix 物件是由包含相同的元素組成的2維物件
#################################################
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

###

irisMatrix = as.matrix(dist(iris[,1:4])). #dist() Distance Matrix Computation，euclidean distance is the default
#irisMatrix = as.matrix(iris)  #error , x must be a numeric matrix
irisMatrix
heatmap(irisMatrix)

#################################################
#Pretty Heatmap
#################################################
if (!require("pheatmap")) install.packages("pheatmap")
library(pheatmap)
pheatmap(irisMatrix)

#################################################
#指定行列，值為顏色深淺 ( 3 variables)
#################################################
if (!require("RColorBrewer")) install.packages("RColorBrewer")
library(RColorBrewer)

nw <- read.csv("NWSales.csv")
nw
ggplot(nw, aes(x = Year, y = ShipCountry, fill = Sales)) + 
  geom_tile()

pal_c <- colorRampPalette((brewer.pal(6,"YlGnBu")), space="Lab") #6 colors of YlGnBu
#see https://bookdown.org/xiangyun/notesdown/subsec-color-palettes.html

ggplot(nw, aes(x = EmployeeID, y = ShipCountry, fill = Sales)) + 
  aes(label = Sales) +
  geom_tile(colour="white") + #框線白色
  scale_fill_gradientn(colours = pal_c(100))   #色盤

#################################################
# Scatterplot3d
#################################################
install.packages("scatterplot3d")
library("scatterplot3d")
scatterplot3d(iris)
scatterplot3d(iris$Sepal.Length,iris$Sepal.Width,iris$Petal.Length)



