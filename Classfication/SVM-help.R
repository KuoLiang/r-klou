if(! require("e1071")) install.packages("e1071")
library(e1071)
data(iris)
#attach(iris) #search path

## classification mode
# default with factor response: 標準寫法
model <- svm(Species ~ ., data = iris)

# alternatively the traditional interface: f(x)=y ；y為依變數；x為自變數
x <- subset(iris, select = -Species)
y <- Species
model <- svm(x, y)  #同上的另一種寫法

print(model)
summary(model)

# test with train data
pred <- predict(model, x)  #列出預測結果
# (same as:)
pred <- fitted(model) #同上的功能

# Check accuracy:
table(pred, y)  #table 列，欄

# compute decision values and probabilities:
pred <- predict(model, x, decision.values = TRUE) #列出機率
attr(pred, "decision.values")[1:4,]  #return a dataframe top 4
attr(pred, "decision.values")  #all attributes

#### 調校參數

if(!require("mlbench")) install.packages("mlbench")
library("mlbench")
#gamma = how far the influence of s single training example reaches

tune.model = tune(svm,
                  Species~.,
                  data=iris,
                  kernel="radial", # RBF kernel function
                  range=list(cost=10^(-1:2), gamma=c(.5,1,2))# 調參數的最主要一行
)
plot(tune.model)
summary(tune.model)

#### try another dataset
library(ggplot2)
data(diamonds)
plot(diamonds$carat,diamonds$price)
set.seed(2021)
sample_index= sample(nrow(diamonds),size=10000)
sample_data = diamonds[sample_index,]
tune.model = tune(svm,
                  carat ~.,
                  data=sample_data,
                  kernel="radial", # RBF kernel function
                  range=list(cost=c(1,10), gamma=c(0.1,1))
)
# 調參數的最主要一行
# cost 處罰系數,愈大時代表愈不能容忍誤判,會使用MARGIN變小,易overfitting
# cost 愈小, margin 愈大
# gamma 影響系數,GAMMA愈大時,近點的影響力大,超平面會考慮近點,易overfitting
# gamma 愈小，平面愈平滑
plot(tune.model)
summary(tune.model)
