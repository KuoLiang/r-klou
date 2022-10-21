irisMatrix = as.matrix(dist(iris[,1:4]))
irisMatrix
heatmap(irisMatrix)

install.packages("scatterplot3d")
library("scatterplot3d")
scatterplot3d(iris)
scatterplot3d(iris$Sepal.Length,iris$Sepal.Width,iris$Petal.Length)

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