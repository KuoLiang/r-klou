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

predicted <- predict(model1, newcases, type="class")
predicted
predicted <- predict(model2, newcases, type="prob")
predicted

###

ctrl <- caret::trainControl(method="repeatedcv",repeats = 10) #repeated k-fold cross-validation 
C50Fit <- caret::train(Species ~ . ,data = iris, method = "C5.0", 
                       trControl = ctrl, 
                       preProcess = c("center","scale"),  #replace missing value by mean and sd
                       tuneLength = 20)
C50Fit