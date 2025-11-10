if (!require("ggplot2")) install.packages("ggplot2")
library(ggplot2)

data(diamonds)
set.seed(2025) #固定的亂數
sample_index <- sample(1:nrow(diamonds), size = 1000)
sample_diamonds <- diamonds[sample_index,]

############################################
#first method : rpart with regular expression (based on Gini index)
############################################

if (!require("rpart")) install.packages("rpart")
library(rpart)
if (!require("rpart.plot")) install.packages("rpart.plot")
library(rpart.plot)

model1 <- rpart(color ~., data = sample_diamonds, method = 'class')
rpart.plot(model1, extra = 106) #Display extra information at the nodes
summary(model1)  
prp(model1) #plot r part model

model11 <- rpart(color ~ carat + cut, data = sample_diamonds, method = 'class')
rpart.plot(model11, extra = 100) # try 106, 104, 100
summary(model11)  
prp(model11)

############################################
#second method : C50 with regular expression, based on entropy
############################################

if (!require("C50")) install.packages("C50")
library(C50)

model2 <- C5.0(color ~ ., data = sample_diamonds, method = 'class')
model2 <- C5.0(color ~ carat + cut, data = sample_diamonds, method = 'class')


#second method : C50 with x y specific

input <- sample_diamonds[,c(2,4)] #cut and clarity
output <- sample_diamonds$color # color for predict
output <- as.factor(output)
model2 <- C5.0(x=input, y=output, method = 'class')

#plot
#plot(model2) # ???? something wrong

summary(model2)

mod1 <- C5.0(Species ~ ., data = iris)
plot(mod1)
##### prediction

sample_index2 <- sample(1:nrow(diamonds), size = 10)
sample_index2
newcases <- diamonds[sample_index2,-3]
newcases
predicted <- predict(model1, newcases, type="prob")
predicted <- predict(model1, newcases, type="class")

predicted

########
#caret = Classification And REgression Training

if (!require("caret")) install.packages("caret")
library(caret)

ctrl <- caret::trainControl(method="repeatedcv",
                            repeats = 10) #repeated k-fold cross-validation 
C50Fit <- caret::train(Species ~ . ,data = iris, method = "C5.0", 
                       trControl = ctrl)
C50Fit
ggplot(C50Fit)
#winnowing : select which features include in the analysis
##########
RpartFit <- caret::train(color ~ . ,data = sample_diamonds, 
                         method = "rpart", 
                        trControl = ctrl)
RpartFit
ggplot(RpartFit)

#########
CForestFit <- caret::train(Species ~ . ,data = iris, 
                           method = "cforest", 
                          trControl = ctrl)
CForestFit
ggplot(CForestFit)

sample_index3 <- sample(1:nrow(iris), size = 10)
sample_index3
newcases <- iris[sample_index3,-5]
newcases
predicted <- predict(CForestFit, newcases, type="prob")
predicted
predicted <- predict(CForestFit, newcases, type="raw")
predicted
