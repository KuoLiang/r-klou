##########################################
#Editor: Kuo-Liang Ou
#Affililation: National Tsing Hua University ILST
##########################################

data("iris")

my_iris=lm(Sepal.Length ~ Sepal.Width+Petal.Length+Petal.Width, data=iris)

summary(my_iris)

test_index = sample(nrow(iris),15)

test_index

test_set = iris[test_index,]

test_set

my_predict = predict(my_iris,test_set)

my_predict

###

set.seed(100) # setting seed to reproduce results of random sampling

trainingRowIndex <- sample(1:nrow(iris), 0.8*nrow(iris)) # row indices for training data

trainingData <- iris[trainingRowIndex, ] # model training data

testData <- iris[-trainingRowIndex, ] # test data



lmMod <- lm(Sepal.Length ~ Sepal.Width+Petal.Length+Petal.Width, data=trainingData) # build the model

Pred <- predict(lmMod, testData) # predict 

Pred