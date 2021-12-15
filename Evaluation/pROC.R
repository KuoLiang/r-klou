install.packages("pROC")
library(pROC)
library(C50)
input <- iris[,1:4]
output <- iris[,5]

model1 <- C5.0(input, output, control = C5.0Control(noGlobalPruning = FALSE))
plot(model1, main="C5.0 Decision Tree - Pruned")

set.seed(2021)
iris.sample <- sample(1:150)       #打亂 150
iris.train <- iris[iris.sample[1:20],]  #取前
iris.test <- iris[iris.sample[21:150],] #取後

iris.predictions <- predict(model1, newdata=iris.test, type="prob")
#iris.predictions <- predict(model1, newdata=iris.test, type="class")
iris.predictions
pr=roc.curve(iris.test$Species, iris.predictions,curve = TRUE)
pr2=multiclass.roc(iris.test$Species, iris.predictions,curve = TRUE)
plot.roc(pr2[["rocs"]][[3]],print.auc = T,col="blue",print.auc.y = .5,legacy.axes = TRUE,lty=4,main="Iris-versicolor & Iris-virginica")


###########################
library(e1071)
result_radial_1<-svm(Species~.,iris,
                     kernel="radial",gamma=10^-1)

result_radial_2<-svm(Species~.,iris,
                     kernel="radial",gamma=10^-2)

result_radial_3<-svm(Species~.,iris,
                     kernel="radial",gamma=10^-3)

#將 Specise 轉為 123代號
pre_1<-as.numeric(predict(result_radial_1,iris))
pre_2<-as.numeric(predict(result_radial_2,iris))
pre_3<-as.numeric(predict(result_radial_3,iris))


a1<-multiclass.roc(iris$Species,pre_1)
a2<-multiclass.roc(iris$Species,pre_2)
a3<-multiclass.roc(iris$Species,pre_3)

plot.roc(a1[["rocs"]][[3]],print.auc = T,col="blue",
         print.auc.y = .5,legacy.axes = TRUE,lty=4,
         main="Iris-versicolor & Iris-virginica")
plot.roc(a2[["rocs"]][[3]],print.auc = T,col="red",
         print.auc.y = .4,add=T,legacy.axes = TRUE,lty=3)
plot.roc(a3[["rocs"]][[3]],print.auc = T,col="green",
         print.auc.y = .3,add=T,legacy.axes = TRUE,lty=2)
legend(.2,.3,legend = c("γ=10^-1","γ=10^-2","γ=10^-3"),col = c("blue","red","green"),lty=c(4,3,2))
