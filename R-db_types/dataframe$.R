###DF 基本操作
iris
iris[,"Sepal.Length"]
iris$Sepal.Length[]  ##同上
iris$Sepal.Length[2]
iris_leves=levels(iris$Species) #factor
class(iris)
class(iris$Species)
class(iris_leves)
getwd()
setwd()
str(iris) # structure of 
#########取亂數,設定種子數讓每次都亂得一致
a=as.numeric(Sys.time())
b=Sys.time()
set.seed(a)
set.seed(b)
set.seed()
###########取樣
myindex = sample(nrow(iris),10)
myindex
iris[myindex,]
