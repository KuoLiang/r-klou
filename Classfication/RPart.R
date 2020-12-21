library(datasets)
library(rpart)
library(partykit)  
library(rpart.plot)
set.seed(2020)
train.index = sample(x=1:nrow(iris), size=ceiling(0.8*nrow(iris) )) #抽樣8/2
train_set = iris[train.index,]
test_set = iris[-train.index,]
###
model1=rpart(train_set$Species~train_set$Petal.Length)
model1
model1.tree=as.party(model1)
plot(model1,main="Rpart",margin = 0.1)
text(model1, cex=2)
#
model2=rpart(train_set$Species~train_set$Petal.Length+train_set$Petal.Width)
model2
prp(model2, main="Rpart",box.palette="auto") 
#
model3=rpart(Species~.,data=iris,method="class",minsplit=1,maxdepth=2)
model3
model3.tree=as.party(model3)
plot(model3.tree,main="Rpart")
# to predict
result = predict(model3, newdata=test_set, type="class")
result

