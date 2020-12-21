install.packages("ggplot2")
install.packages("C50")
library(C50)
library(ggplot2)
data(diamonds)
sample_index <- sample(1:nrow(diamonds), size = 100)
sample_diamonds <- diamonds[sample_index,]
input <- sample_diamonds[,c(1,2,4,5,6,7,8,9,10)]
model1 <- C5.0(input, sample_diamonds$color, control = C5.0Control(noGlobalPruning = FALSE))
model2 <- C5.0(color ~. , sample_diamonds, control = C5.0Control(noGlobalPruning = FALSE))

summary(model1)
summary(model2)

#plot(model1, main="C5.0 Decision Tree, min=1")

sample_index2 <- sample(1:nrow(diamonds), size = 10)
sample_index2
newcases <- diamonds[sample_index2,-3]
newcases
predicted <- predict(model2, newcases, type="prob")
predicted <- predict(model2, newcases, type="class")

predicted
