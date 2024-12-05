library(class)
set.seed(2020)
train.index = sample(x=1:nrow(iris), 
                     size=ceiling(0.8*nrow(iris) )) #抽樣8/2
train_set = iris[train.index,]
test_set = iris[-train.index,]
###
iris.knn <- knn(
    train_set[,1:4], #variables of training set 
    test_set[,1:4],  #variables of testing set
    train_set[,5],   #factor of true class of training set
    k = 3, prob = F)
iris.knn
summary(iris.knn)
result = cbind(iris.knn,test_set[5])  #把預測的品種與真實的品種比較
result
table(result)
############
#換個參數 k=100
############
iris.knn <- knn(
    train_set[,1:4], 
    test_set[,1:4], 
    train_set[,5], 
    k = 100, prob = F)
iris.knn
summary(iris.knn)
result = cbind(iris.knn,test_set[5])
result
table(result)

##########
# k 應該多少呢？
##########
install.packages("caret")
#The caret package contains functions to streamline 
#the model training process for complex regression and 
#classification problems

ctrl <- caret::trainControl(method="repeatedcv",repeats = 10) 
#repeated k-fold cross-validation 
knnFit <- caret::train(Species ~ . ,data = iris, method = "knn", 
                       trControl = ctrl) #using the ctrl above

#Output of kNN fit
knnFit
plot(knnFit)

#################
#setwd("/Users/klou/Documents/GitHub/r-klou/5-Classfication")
source("mysql_conn.R") #connect to mysql
dp <-  fetch(myquery_result, n=-1)  #read all the data from result
dp
##########################################