library(e1071 )
set.seed(2020)
train.index = sample(x=1:nrow(iris), size=ceiling(0.8*nrow(iris) )) #抽樣8/2
train_set = iris[train.index,]
test_set = iris[-train.index,]
NBModel=naiveBayes(Species ~., data=train_set)
NBModel

result=predict(NBModel,test_set)
result

###

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

