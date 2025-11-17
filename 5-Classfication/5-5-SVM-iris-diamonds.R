if(! require("e1071")) install.packages("e1071")
library(e1071)
########################
#SVM
########################
## classification mode
# default with factor response: 正規寫法
model <- svm(Species ~ ., data = iris,
             kernel = "polynomial") 
#kernel = linear,polynomial,radial,sigmoid

summary(model)
plot(model,iris,Petal.Length~Petal.Width)
plot(model,iris,Petal.Length~Sepal.Width)
plot(model,iris,Petal.Length~Sepal.Length)
plot(model,iris,Sepal.Width~Sepal.Length)

plot(model, iris, Petal.Width ~ Petal.Length)
#解析度 grid =50 , 其它維度切片slice (list object)  0 by default

plot(model, iris, Petal.Width ~ Petal.Length, grid=100,
     slice = list(Sepal.Width = 3,Sepal.Length = 4))
plot(model, iris, Petal.Width ~ Petal.Length, grid=50,
     slice = list(Sepal.Width = 3.1,Sepal.Length = 4.1))

plot(model, iris, Sepal.Width ~ Petal.Width,
     slice = list(Sepal.Length = 3, Petal.Length = 4))


########################
#predict with svm model
########################
x <- subset(iris, select = -Species)
y <- iris$Species
model <- svm(Species ~ ., data = iris) #kernel default = radial
pred_result <- predict(model, x)
table(pred_result,y)
#plot(x, data, formula, fill = TRUE, grid = 50, slice = list(),
#     symbolPalette = palette(), svSymbol = "x", dataSymbol = "o", ...)
#see ?plot.svm()



# alternatively the traditional interface: f(x)=y ；y為依變數；x為自變數
x <- subset(iris, select = -Species)
y <- subset(iris, select = Species) #如此 y 為 data frame
#y <- iris$Species #如此 y2 為 vector, not data frame

model <- svm(x, y)           #無法執行，因為不為factor vector
model <- svm(x, y$Species)   #ok
#############################################


# test with training data
sample_index=sample(nrow(x),10) #抽10個
pred1 <- predict(model, x[sample_index,])  #列出預測結果 using test set
pred1
# (same as:)
pred2 <- fitted(model) #同上的功能,但用原有的樣本 using training set
pred2

# Check accuracy:
table(pred1, iris[sample_index,5])  #table 列，欄
table(pred2, y$Species)  #table 列，欄

# compute decision values and probabilities:#列出機率,可見兩兩比較的二分法
pred11 <- predict(model, x[sample_index,], decision.values = TRUE) 
pred21<- predict(model, x, decision.values = TRUE) 

attr(pred11, "decision.values")[1:10,]  #return a data frame 
attr(pred21, "decision.values")  #all attributes

#### 調校參數

if(!require("mlbench")) install.packages("mlbench")
library("mlbench")
#gamma = how far the influence of s single training example reaches
#cost = 懲罰值
tune.model = tune(svm,
                  Species~.,
                  data=iris,
                  kernel="radial", 
                  range=list(cost=10^(-1:2), gamma=c(.5,1,2))# 調參數的最主要一行
)
plot(tune.model) #右方 error 愈小愈好（深色）
summary(tune.model) #cost = 1; gamma = 0.5 are the best parameters
model2 <- svm(Species ~ ., data = iris,
              kernel="polynomial",cost = 1, gamma = 0.5 )
pred23 <- predict(model2, x, decision.values = TRUE) #列出機率
table(pred23, y$Species) #tuned prediction
table(pred21, y$Species) #previous prediction


###########################
#diaminds
###########################
library(ggplot2)
data(diamonds)
plot(diamonds$carat,diamonds$price)
set.seed(2025)
sample_index= sample(nrow(diamonds),size=10000)
sample_data = diamonds[sample_index,]
tune.model = tune(svm,
                  color ~.,
                  data=sample_data,
                  kernel="radial", 
                  range=list(cost=c(1,10), gamma=c(0.1,1))
) 
################################
#be careful of time consuming (it may cost 5 mins or more)
################################
# 調參數的最主要一行
# cost 處罰系數,愈大時代表愈不能容忍誤判,會使用MARGIN變小,易overfitting
# cost 愈小, margin 愈大
# gamma 影響系數,GAMMA愈大時,近點的影響力大,超平面會考慮近點,易overfitting
# gamma 愈小，平面愈平滑
plot(tune.model)
summary(tune.model)
model_diamond <- svm(color ~ ., data = sample_data,
                     kernel="radial",cost = 10, gamma = 0.1 )
pred_diamond <- predict(model_diamond, sample_data, decision.values = TRUE) #列出機率
table(pred_diamond,sample_data$color) 

# give a detail of confusion matrix and evaluation
conf <- caret::confusionMatrix(data=pred_diamond, reference = sample_data$color)
conf


model_diamond <- svm(price ~ ., data = sample_data,
                     kernel="radial")
pred_diamond <- predict(model_diamond, sample_data, decision.values = TRUE) #列出機率
table(pred_diamond,sample_data$price) #!!!!! 把價錢當factor ???
#以SVM猜數值為錯誤示範
