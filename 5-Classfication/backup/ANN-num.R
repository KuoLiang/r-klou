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
#
ann_formula = Sepal.Length ~ Sepal.Width + Petal.Length + Petal.Width
# first try
model_neu= neuralnet(formula = ann_formula, data=iris_train, 
                     linear.output = T)
model_neu= neuralnet(formula = ann_formula, data=iris_train, 
                     linear.output = T,act.fct = "tanh")
plot(model_neu)
result_pre1=predict(model_neu, iris_test)
result_pre1
### compare
result_actual=iris_test$Sepal.Length
result_diff1 = result_actual-result_pre1
compare1 = cbind(result_pre1,result_actual,result_diff1)
compare1 = as.data.frame(compare1)
ggplot(compare1,aes(x=result_actual,y=result_pre1))+ geom_point()+ stat_smooth()

### second try
model_neu2= neuralnet(formula = ann_formula, data=iris_train,
                      hidden=c(2,3),linear.output = T)
plot(model_neu2)
result_pre2=predict(model_neu2, iris_test)
result_pre2
### compare
result_actual=iris_test$Sepal.Length
result_diff2 = result_actual-result_pre2
compare2 = cbind(act=result_pre2,result_actual,diff=result_diff2)
compare2 = as.data.frame(compare2)
ggplot(compare2,aes(x=result_actual,y=result_pre2))+ geom_point()+ stat_smooth()

### Mean Squared Error
mse1 = sum((result_diff1)^2)/nrow(iris_test)
mse1
mse2 = sum((result_diff2)^2)/nrow(iris_test)
mse2


###
#######################
#tunning the best parameter
####################### it may takes a long time
best_model = caret::train(form=ann_formula, data=iris_train, method="neuralnet",  
                          #tuneGrid = expand.grid(.layer1=c(1:4), .layer2=c(0:4), .layer3=c(0:4)), 
                          tuneGrid = expand.grid(.layer1=c(1:3), .layer2=c(1:2), .layer3=c(0)),               
                          learningrate = 0.01,  # learning rate
                          threshold = 0.01,     # partial derivatives of the error function, a stopping criteria
                          stepmax = 5e5         # 最大的ieration數 = 500000(5*10^5)
)
best_model
plot(best_model)
###
model_neu3= neuralnet(formula = ann_formula, data=iris_train,
                      hidden=c(1,1),linear.output = T)
plot(model_neu3)
result_pre3=predict(model_neu3, iris_test)
result_pre3
### compare
result_actual=iris_test$Sepal.Length
result_diff3 = result_actual-result_pre3
compare3 = cbind(result_pre3,result_actual,result_diff3)
compare3 = as.data.frame(compare3)
ggplot(compare3,aes(x=result_actual,y=result_pre3))+ geom_point()+ stat_smooth()
mse3 = sum((result_diff3)^2)/nrow(iris_test)
mse3

###

