library(datasets)
install.packages("RKEEL")
library(RKEEL)
set.seed(2020)
train.index = sample(x=1:nrow(iris), size=ceiling(0.8*nrow(iris) )) #抽樣8/2
train_set = iris[train.index,]
test_set = iris[-train.index,]
###

#Create algorithm
#https://cran.r-project.org/web/packages/RKEEL/RKEEL.pdf
algorithm <- Ripper_C(train_set, test_set)
#Run algorithm
algorithm$run()
#See results
algorithm$testPredictions
#############
algorithm2 <- Ripper_C(train_set, test_set,0.5,3)
algorithm2$run()
algorithm2$testPredictions
############
install.packages("RWeka")
library(RWeka)
ripper_result <- JRip(Species ~ ., data = train_set)
ripper_result
summary(ripper_result)
ripper_pred <- predict(ripper_result, test_set)
ripper_pred
ripper_pred_prob <- predict(ripper_result, test_set ,type = 'prob')
ripper_pred_prob

###
OneR <- OneR(Species ~ ., data = iris)
OneR
summary(OneR)
OneR_JRip <- JRip(Species ~ ., data = iris)
OneR_JRip
