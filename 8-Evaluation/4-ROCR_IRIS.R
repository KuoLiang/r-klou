##########################################
#Editor: Kuo-Liang Ou
#National Tsing Hua University ILST
##########################################
install.packages("ROCR")
library(ROCR)
data(ROCR.simple)
library(e1071)

group=c(rep(0,times=100),rep(1,times=100))
#pred <- prediction( ROCR.simple$labels, ROCR.simple$labels) 
pred <- prediction( rnorm(200,mean=1,sd=1), ROCR.simple$labels) 
pred <- prediction( rnorm(200,mean=2,sd=2), ROCR.simple$labels) 

pred <- prediction( rnorm(200,mean=1,sd=1), group) 
pred <- prediction( rnorm(200,mean=2,sd=2), group) 

# prediction 第一個參數位資料集，第二個參數為組別，目前支援二分法
# 多組以上需兩兩比較

perf <- performance(pred,"tpr","fpr") 
perf
plot(perf)
perf <- performance(pred, measure = "auc")   #area under curve
perf@y.values

#########
#for IRIS
#########
iris$setosa <- as.numeric(iris$Species == "setosa")
mod1 <- svm(iris$setosa~Sepal.Length+Sepal.Width, data=iris, kernel="radial")

pred1 <- prediction(predict(mod1), iris$setosa)
perf1 <- performance(pred1,"tpr","fpr")
plot(perf1)
perf1 <- performance(pred1, measure = "auc")   #area under curve
perf1@y.values
#############
iris$vcolor <- as.numeric(iris$Species == "versicolor")
mod2 <- svm(iris$vcolor~Sepal.Length+Sepal.Width, data=iris, kernel="radial")

pred2 <- prediction(predict(mod2), iris$vcolor)
perf2 <- performance(pred2,"tpr","fpr")
plot(perf2)
perf2 <- performance(pred2, measure = "auc")   #area under curve
perf2@y.values
#############
iris$vnica <- as.numeric(iris$Species == "virginica")
mod3 <- svm(iris$vnica~Sepal.Length+Sepal.Width, data=iris, kernel="radial")

pred3 <- prediction(predict(mod3), iris$vnica)
perf3 <- performance(pred3,"tpr","fpr")
plot(perf3)
perf3 <- performance(pred3, measure = "auc")   #area under curve
perf3@y.values
