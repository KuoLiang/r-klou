##########################################
#Editor: Kuo-Liang Ou
#National Tsing Hua University ILST
#Statistics
##########################################
#dataset
##########################################
#from database
source("mysql_conn.R") #connect to mysql
nw <-  fetch(myquery_result, n=-1)  #read all the data from result
#from local file
#setwd("somewhere of your working directory")
nw <-  read.csv("NWSales.csv")
#from remote file
#nw <-  read.csv("https://github.com/KuoLiang/r-klou/blob/f6cc7b13890bbedd42d9e5d4a7e684dafa239495/Plot/NWSales.csv")
nw #showout the dataframe

##########################################
#transform
##########################################
nw$Year = factor(nw$Year)
nw$EmployeeID = factor(nw$EmployeeID)
nw$ShipCountry = factor(nw$ShipCountry)

##########################################

lm_model=lm(Sales ~ Freight, data=nw)
summary(lm_model)

a <- ggplot(data=nw,aes(x=Freight,y=Sales))
a + geom_point() + geom_smooth()

test_index = sample(nrow(nw),400)

test_index

test_set = nw[test_index,]

test_set

my_predict = predict(lm_model,test_set)

my_predict

compare <- cbind(my_predict,my_sales=test_set$Sales)
compare <- data.frame(compare)
compare <- compare %>% mutate(error = my_predict - my_sales)
summary(compare) 

b <- ggplot(data=test_set,aes(x=Freight,y=Sales))
b + geom_point() + geom_smooth()

###

set.seed(100) # setting seed to reproduce results of random sampling

trainingRowIndex <- sample(1:nrow(iris), 0.8*nrow(iris)) # row indices for training data

trainingData <- iris[trainingRowIndex, ] # model training data

testData <- iris[-trainingRowIndex, ] # test data



lmMod <- lm(Sepal.Length ~ Sepal.Width+Petal.Length+Petal.Width, data=trainingData) # build the model

Pred <- predict(lmMod, testData) # predict 

Pred

