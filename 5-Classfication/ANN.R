#install.packages("neuralnet")
#install.packages("class")
#install.packages("nnet")
library(neuralnet)
library(class)
library(nnet)
#class.ind = dummy variables by nnet package
#Generates a class indicator function from a given factor.
iris_dummy = cbind(iris, class.ind(iris$Species))  
#增加三欄編碼，因為只能用數值作為class
iris_dummy 
set.seed(2020)
sample_size = 0.8 * nrow(iris_dummy)   #80% 是多少呢？
sample_index = sample(nrow(iris_dummy),sample_size) #取樣索引
iris_train = iris_dummy[sample_index,]
iris_test = iris_dummy[-sample_index,]
#neuralnet(formula, data, hidden = 1, threshold = 0.01) 
ann_formula = setosa + versicolor + virginica ~ Sepal.Length + Sepal.Width + Petal.Length + Petal.Width
#這裹不可用 ann_formula = Species ~ .
#setosa 變成欄位了；versicolor and virginica 也是欄位
#############################################
#ANN
#############################################

model1= neuralnet(formula = ann_formula, data=iris_train) #use the training data
plot(model1)
model1 #show out the nn information
result_pre=predict(model1, iris_test) #predict the test data
result_pre #prediction result


model2= neuralnet(formula = ann_formula, data=iris_train, hidden=2) #node of hidden layer = 2
plot(model2)
model2
result_pre2=predict(model2, iris_test)
result_pre2
###
#
result_pre=round(result_pre)#四捨五入 ,也可用別的閥值
pred.df = as.data.frame(result_pre) 
pred.df$Species =""
pred.df
for(i in 1:nrow(pred.df)){
  if(pred.df[i, 1]==1){ pred.df[i, "Species"] = "Setosa"}
  if(pred.df[i, 2]==1){ pred.df[i, "Species"] = "Versicolor"}
  if(pred.df[i, 3]==1){ pred.df[i, "Species"] = "Virginica"}
}
pred.df # you may find out some empty results
#######################
#tunning the best parameter
#######################
install.packages("caret")
library(caret) 

best_model = caret::train(form=ann_formula, data=iris_train, method="neuralnet",  
                tuneGrid = expand.grid(.layer1=c(1:3), .layer2=c(0:3), .layer3=c(0:3)), 
            #   tuneGrid = expand.grid(.layer1=c(1:4), .layer2=c(0:4), .layer3=c(0)),               
               learningrate = 0.01,  # learning rate
               threshold = 0.1,     # partial derivatives of the error function, a stopping criteria
               stepmax = 5e5         # 最大的ieration數 = 500000(5*10^5)
)
best_model
plot(best_model)
model_neu_final= neuralnet(formula = ann_formula, data=iris_train, hidden=c(2,1,1))
plot(model_neu_final)
model_neu_final$result.matrix
result_final=predict(model_neu_final, iris_test)
result_final
#
result_final=round(result_final)
pred.df = as.data.frame(result_final)
pred.df$Species =""
pred.df
for(i in 1:nrow(pred.df)){
    if(pred.df[i, 1]==1){ pred.df[i, "Species"] = "Setosa"}
    if(pred.df[i, 2]==1){ pred.df[i, "Species"] = "Versicolor"}
    if(pred.df[i, 3]==1){ pred.df[i, "Species"] = "Virginica"}
}
pred.df #much better
#########

