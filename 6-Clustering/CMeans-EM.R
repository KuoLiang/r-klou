library(e1071)
iris_sub = iris[,1:4]
set.seed(2020)
x=sample(nrow(diamonds),1000)
diamond_sub= diamonds[x,-c(2,3,4)]
#########################################
#Kmeans
###SSE sum of squares error
#########################################
resultkm1=kmeans(iris_sub,centers=3)
resultkm1
resultkm1$cluster
table(resultkm1$cluster,iris$Species)
### illustrate the SSE
install.packages("factoextra")
library(factoextra)
### for iris
fviz_nbclust(iris_sub, 
             FUNcluster = hcut,  # hierarchical clustering
             method = "wss",     # total within sum of square
             k.max = 12          # max number of clusters to consider
)
### for diamonds
fviz_nbclust(diamond_sub, 
             FUNcluster = hcut,  # hierarchical clustering
             method = "wss",     # total within sum of square
             k.max = 12          # max number of clusters to consider
)
#########################################
#Cmeans
#########################################
#cmeans(x, centers, iter.max = 100, verbose = FALSE,
#       dist = "euclidean", method = "cmeans", m = 2,
#       rate.par = NULL, weights = 1, control = list())
result_iris_cm2=cmeans(iris_sub,2)
result_iris_cm3=cmeans(iris_sub,3)
result_diad_cm2=cmeans(diamond_sub,2)
result_diad_cm3=cmeans(diamond_sub,3)
result_diad_cm3
result_diad_cm3$cluster
#########################################
#EM clustering
#Baysiean Information Criterion (BIC)
#########################################
install.packages("mclust")
library(mclust)
result_iris_mc =  Mclust(iris_sub)
summary(result_iris_mc) # display the best model
plot(result_iris_mc) # plot results 

#########################################
#SOM(data, grid = somgrid(), rlen = 10000, alpha, radii, init)
#scale(x, center = TRUE, scale = TRUE) center:SD(T) or mean square(F)
#                                      scale:
#########################################
a=scale(iris$Sepal.Length,center = TRUE, scale = TRUE)
b=scale(iris$Sepal.Length,center = T, scale = F)
c=scale(iris$Sepal.Length,center = F, scale = TRUE)
d=scale(iris$Sepal.Length,center = F, scale = F)
iris_scal=scale(iris_sub)
#install.packages("kohonen")
library(kohonen)
sg=somgrid(xdim=10,ydim=10,topo="hexagonal")
smodel=som(iris_scal,grid=sg)
plot(smodel,type="codes")
summary(smodel)
###diamonds
diad_scal=scale(diamond_sub)
library(kohonen)
sg=somgrid(xdim=10,ydim=10,topo="rectangular") #rectangular #hexagonal
smodel=som(diad_scal,grid=sg)
plot(smodel,type="codes")
#plot(smodel,type="count")
summary(smodel)
