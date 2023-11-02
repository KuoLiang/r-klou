install.packages("e1071")
library(e1071 )
set.seed(2020)
train.index = sample(x=1:nrow(iris), size=ceiling(0.8*nrow(iris) )) #抽樣8/2
train_set = iris[train.index,]
test_set = iris[-train.index,]
###
svm.model = svm(Species~ ., data = train_set, gamma = 1) 
svm.model = svm(Species~ ., data = train_set)
svm.model
svm.pred = predict(svm.model, test_set[,-5])
svm.pred
# vs rpart
model3=rpart(Species~.,data=iris,method="class",minsplit=1,maxdepth=2)
model3
result = predict(model3, newdata=test_set, type="class")
result
##
compare = cbind(svm.pred,result)
compare
table(svm_predict=svm.pred, predict=result)
