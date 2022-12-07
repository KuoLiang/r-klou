if(! require("e1071")) install.packages("e1071")
library(e1071)
data(iris)
#attach(iris) #search path

## classification mode
# default with factor response: 標準寫法
model <- svm(Species ~ ., data = iris)

# alternatively the traditional interface: f(x)=y ；y1 y2為依變數；x為自變數
x <- subset(iris, select = -Species)
y1 <- subset(iris, select = Species) #如此 y1 為 nominal
y2 <- iris$Species #如此 y2 為 values, not data frame

model <- svm(x, y1)  #無法執行，因為不為factor
model <- svm(x, y2)  #ok
sample_index=sample(nrow(x),10) #抽10個

summary(model)

# test with train data
pred1 <- predict(model, x[sample_index,])  #列出預測結果
# (same as:)
pred2 <- fitted(model) #同上的功能,但用所有的樣本

# Check accuracy:
table(pred1, iris[sample_index,5])  #table 列，欄
table(pred2, y2)  #table 列，欄

# compute decision values and probabilities:#列出機率,可見兩兩比較的二分法
pred11 <- predict(model, x[sample_index,], decision.values = TRUE) 
pred21<- predict(model, x, decision.values = TRUE) 

attr(pred11, "decision.values")[1:10,]  #return a data frame 
attr(pred21, "decision.values")  #all attributes

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
