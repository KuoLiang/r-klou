install.packages("ggplot2")
install.packages("rpart")
install.packages("rpart.plot")
library(ggplot2)
library(rpart)
library(rpart.plot)

data(diamonds)
set.seed(2022) #固定的亂數
sample_index <- sample(1:nrow(diamonds), size = 100)
sample_diamonds <- diamonds[sample_index,]
input <- sample_diamonds[,c(1,2,4,5,6,7,8,9,10)]

model <- rpart(color ~., data = sample_diamonds, method = 'class')
rpart.plot(model, extra = 100)

summary(model)

sample_index2 <- sample(1:nrow(diamonds), size = 10)
sample_index2
newcases <- diamonds[sample_index2,-3]
newcases
predicted <- predict(model, newcases, type="prob")
predicted <- predict(model, newcases, type="class")

predicted
