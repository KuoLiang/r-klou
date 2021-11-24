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
tune.model = tune(svm,
                  color ~.,
                  data=diamonds,
                  kernel="radial", # RBF kernel function
                  range=list(cost=10^(-1:2), gamma=c(.5,1,2))# 調參數的最主要一行
)
plot(tune.model)
summary(tune.model)
