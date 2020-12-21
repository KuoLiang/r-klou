library(datasets)
library(C50)
input <- iris[,1:4]
output <- iris[,5]
model1 <- C5.0(input, output, control = C5.0Control(noGlobalPruning = TRUE,minCases=1))
plot(model1, main="C5.0 Decision Tree - Unpruned, min=1")

model2 <- C5.0(input, output, control = C5.0Control(noGlobalPruning = FALSE))
plot(model2, main="C5.0 Decision Tree - Pruned")

newcases <- iris[c(1:3,51:53,101:103),]
newcases
iris

newcases2 = data.frame(Sepal.Length=c(1,2,3),Sepal.Width=c(2,3,4),
                       Petal.Length=c(3,4,5),Petal.Width=c(4,5,6),
                       Spaecies=c(NA,NA,NA))
newcases2
predicted <- predict(model1, newcases2, type="class")
predicted

predicted <- predict(model1, newcases, type="prob")
predicted
predicted <- predict(model2, newcases, type="prob")
predicted