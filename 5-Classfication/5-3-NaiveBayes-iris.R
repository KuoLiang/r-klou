#install.packages('e1071')
#install.packages('caret')
library(caret)
library(e1071 )
set.seed(2020)

train.index = sample(x=1:nrow(iris), size=ceiling(0.8*nrow(iris) )) #抽樣8/2
train_set = iris[train.index,]  #retrieve the training set
test_set = iris[-train.index,]  #retrieve the test set

NBModel=naiveBayes(Species ~., data=train_set)  #build the model
NBModel                                         #show the model

result=predict(NBModel,test_set)                #prediction
result
summary(result)
table(test_set$Species,result)
conf <- confusionMatrix(data=result, reference = test_set$Species)
conf
### try the diamonds

library(ggplot2)
train.index = sample(x=1:nrow(diamonds), size=ceiling(0.8*nrow(diamonds) )) #抽樣8/2
train_set = diamonds[train.index,]
test_set = diamonds[-train.index,]
NBModel=naiveBayes(color ~., data=train_set)
NBModel

result=predict(NBModel,test_set)
result
summary(result)


#SVM

library(e1071)
data(iris)
x <- subset(iris, select = -Species)
y <- iris$Species
model <- svm(Species ~ ., data = iris)
pred_result <- predict(model, x)
table(pred_result,y)
#plot(x, data, formula, fill = TRUE, grid = 50, slice = list(),
#     symbolPalette = palette(), svSymbol = "x", dataSymbol = "o", ...)

plot(model, iris, Petal.Width ~ Petal.Length,grid=100,
     slice = list(Sepal.Width = 3,Sepal.Length = 4))
iris
plot(model, iris, Sepal.Width ~ Petal.Width,
     slice = list(Sepal.Length = 3, Petal.Length = 4))

