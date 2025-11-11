if (!require("ggplot2")) install.packages("ggplot2")
library(ggplot2)
if (!require("caret")) install.packages("caret")
library(caret)
if (!require("e1071")) install.packages("e1071")
library(e1071 )
########################
set.seed(2025)

train.index = sample(x=1:nrow(iris), size=ceiling(0.8*nrow(iris) )) #抽樣8/2
train_set = iris[train.index,]  #retrieve the training set
test_set = iris[-train.index,]  #retrieve the test set

NBModel=naiveBayes(Species ~., data=train_set)  #build the model
NBModel                                         #show the model

result=predict(NBModel,test_set)                #prediction
result
summary(result)
table(test_set$Species,result)

# give a detail of confusion matrix and evaluation
conf <- caret::confusionMatrix(data=result, reference = test_set$Species)
conf

#95% CI 百分之九十五信賴區間
#No Information Rate 隨機猜正確率
#P-Value [Acc > NIR] 檢驗Acc 是否顯著與隨機猜有所不同
#Kappa between -1 to 1 資料集是否平衡
#Mcnemar's Test P-Value 相依樣本卡方檢定，兩組間成對個案的類別相互改變
#其它請見help
?caret::confusionMatrix

########################
### try the diamonds
########################
train.index = sample(x=1:nrow(diamonds), size=ceiling(0.8*nrow(diamonds) )) #抽樣8/2
train_set = diamonds[train.index,]
test_set = diamonds[-train.index,]
NBModel=naiveBayes(color ~., data=train_set)
NBModel

result=predict(NBModel,test_set)
result
summary(result)
table(test_set$color,result)
# give a detail of confusion matrix and evaluation
conf <- confusionMatrix(data=result, reference = test_set$color)
conf

########################
#SVM
########################
#library(e1071)
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

