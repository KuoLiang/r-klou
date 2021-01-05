library(datasets)
#install.packages("RKEEL")
library(class)
set.seed(2020)
train.index = sample(x=1:nrow(iris), size=ceiling(0.8*nrow(iris) )) #抽樣8/2
train_set = iris[train.index,]
test_set = iris[-train.index,]
###
iris.knn <- knn(
    train_set[,1:4], 
    test_set[,1:4], 
    train_set[,5], 
    k = 3, l = 0, prob = F)
iris.knn
summary(iris.knn)
result = cbind(iris.knn,test_set[5])
result
table(result)
###
iris.knn <- knn(
    train_set[,1:4], 
    test_set[,1:4], 
    train_set[,5], 
    k = 100, l = 0, prob = F)
iris.knn
summary(iris.knn)
result = cbind(iris.knn,test_set[5])
result
table(result)

##########
install.packages("caret")
ctrl <- caret::trainControl(method="repeatedcv",repeats = 10) #repeated k-fold cross-validation 
knnFit <- caret::train(Species ~ . ,data = iris, method = "knn", 
                       trControl = ctrl, 
                       preProcess = c("center","scale"),  #replace missing value by mean and sd
                       tuneLength = 20)

#Output of kNN fit
knnFit
plot(knnFit)
