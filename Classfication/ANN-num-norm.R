install.packages('MASS')
library(MASS)
#install.packages("neuralnet")
library(neuralnet)
library(caret) 
library(nnet)
iris_data = iris[1:4]
set.seed(2020)
sample_size = 0.8 * nrow(iris_data)
sample_index = sample(nrow(iris_data),sample_size)
iris_train = iris_data[sample_index,]
iris_test = iris_data[-sample_index,]
#####正規化
iris_maxs = apply(iris_train,2,max) #2 表示各欄最大值
iris_maxs
iris_mins = apply(iris_train,2,min) #2 表示各欄最小值
iris_mins
###
iris_scaled = scale(iris_train,center=iris_maxs,
                    scale=iris_maxs-iris_mins)
iris_scaled #a normalized matirx 0 to 1 因為以 min為參考點
#
ann_formula = Sepal.Length ~ Sepal.Width + Petal.Length + Petal.Width
# first try
model_neu= neuralnet(formula = ann_formula, data=iris_scaled, 
                     linear.output = T)
plot(model_neu)
result_pre=predict(model_neu, iris_test)
result_pre
### recover the true values
result_ori1 = result_pre * 
    (max(iris_train$Sepal.Length)-min(iris_train$Sepal.Length)) +
    min(iris_train$Sepal.Length)
result_ori1
result_actual=iris_test$Sepal.Length
compare = cbind(result_ori1,result_actual)
compare



### second try
model_neu2= neuralnet(formula = ann_formula, data=iris_scaled,
                      hidden=c(2,3),linear.output = T)
plot(model_neu2)
result_pre2=predict(model_neu2, iris_test)
result_pre2
### recover the true values
result_ori2 = result_pre2 * 
    (max(iris_train$Sepal.Length)-min(iris_train$Sepal.Length)) +
    min(iris_train$Sepal.Length)
result_ori2
result_actual=iris_test$Sepal.Length
compare = cbind(result_ori,result_actual)
compare
