##########################################
#Editor: Kuo-Liang Ou
#National Tsing Hua University ILST
##########################################
library(e1071)
library(ggplot2)
iris_sample = iris[,1:4]
set.seed(2022)
sample_index=sample(nrow(diamonds),10000)
diamond_sample= diamonds[sample_index,-c(2,3,4)] #omitted the nominal

### illustrate the SSE
install.packages("factoextra")
library(factoextra)
### for iris
fviz_nbclust(iris_sample, 
             FUNcluster = kmeans,  #kmeans
             method = "wss",     # total Within Sum of Square
             k.max = 12          # max number of clusters to consider
)
fviz_nbclust(iris_sample, 
             FUNcluster = hcut,  # hierarchical clustering
             method = "wss",     # total Within Sum of Square
             k.max = 12          # max number of clusters to consider
)
### for diamonds
fviz_nbclust(diamond_sample, 
             FUNcluster = kmeans,  # kmeans
             method = "wss",     # total within sum of square
             k.max = 12          # max number of clusters to consider
)
fviz_nbclust(diamond_sample, 
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
result_iris2=cmeans(iris_sample,2)
result_iris3=cmeans(iris_sample,3)
result_iris3
table(result_iris3$cluster,iris$Species)
result_diam2=cmeans(diamond_sample,2)
result_diam3=cmeans(diamond_sample,3)
#how to show the table of diamonds?
result_diam3$cluster
#########################################
#EM clustering
#Baysiean Information Criterion (BIC)
#########################################
install.packages("mclust")
library(mclust)
result_iris_mc =  Mclust(iris_sample)
summary(result_iris_mc) # display the best model
plot(result_iris_mc) # plot results 

#########################################
#Self Organizing Maps 以類神經網路分群
#SOM(data, grid = somgrid(), rlen = 10000, alpha, radii, init)
#scale(x, center = TRUE, scale = TRUE) center:SD(T) or mean square(F)
#                                      scale:
# center 中心化，即減去均數
# scale 標準化，即除以這組數的均方根
#########################################
#先將資料中心化及標準化
a=scale(iris$Sepal.Length,center = TRUE, scale = TRUE)
b=scale(iris$Sepal.Length,center = T, scale = F)
c=scale(iris$Sepal.Length,center = F, scale = TRUE)
d=scale(iris$Sepal.Length,center = F, scale = F)
iris_scal=scale(iris_sample) #所有欄位都中心化標準化
##################################
#install.packages("kohonen")
library(kohonen)

#Plot SOM Fits for IRIS
sg=somgrid(5,5,topo="rectangular")
smodel=som(iris_scal,grid=sg)
plot(smodel,type="codes")
plot(smodel,type="count")
summary(smodel)
som.pred <- predict(smodel, iris_scal)
som.pred$unit.classif
# 顯示出分群結果
som.pred$unit.classif

####Plot SOM Fits for Diamonds
diad_scal=scale(diamond_sample)
sg=somgrid(xdim=10,ydim=10,topo="rectangular") #rectangular #hexagonal
smodel=som(diad_scal,grid=sg)
plot(smodel,type="codes")
plot(smodel,type="count")
summary(smodel)
