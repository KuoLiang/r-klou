install.packages("neuralnet")
library("neuralnet")
sample_size = 0.8 * nrow(iris)
sample_index = sample(nrow(iris),sample_size)
iris_train = iris[sample_index,]
iris_test = iris[-sample_index,]
#neuralnet(formula, data, hidden = 1, threshold = 0.01)
model_neu= neuralnet(Species ~ ., data=iris_train)
plot(model_neu)
model_neu= neuralnet(Species ~ ., data=iris_train, hidden=2)
plot(model_neu)
result_pre=predict(model_neu, iris_test)
result_pre
###
result_pre=round(result_pre)
pred.df = as.data.frame(result_pre)
pred.df$Species =""
pred.df
for(i in 1:nrow(pred.df)){
  if(pred.df[i, 1]==1){ pred.df[i, "Species"] = "Setosa"}
  if(pred.df[i, 2]==1){ pred.df[i, "Species"] = "Versicolor"}
  if(pred.df[i, 3]==1){ pred.df[i, "Species"] = "Virginica"}
}
pred.df
#####


