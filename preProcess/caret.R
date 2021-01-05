library(caret)
iris
set.seed(2020)
dummy
dummy <- dummyVars(formula = ~ ., data = iris)
pred <- predict(dummy, newdata = iris)
pred

###############
#作為抽樣用途
#it preserves the proportion of the categories in Y variable
###############
### 傳統隨機抽,可能各品種代表性不一致
set.seed(2020)
train.index = sample(x=1:nrow(iris), size=ceiling(0.8*nrow(iris) )) #抽樣8/2
train_set = iris[train.index,]
test_set = iris[-train.index,]
nrow(train_set)
table(train_set$Species)
###############
### caret::createDataPartition 依三種品種各抽 80%
# Y 為 iris$Species
###############
set.seed(2020)
index2 <- createDataPartition(iris$Species, p = 0.8, list = F)
index2
train_set <- iris[index2,]
test_set <- iris[-index2,]
nrow(train_set)
table(train_set$Species)

###############
model_c50 = train(Species ~ ., data=train_set, method='C5.0')
model_c50
plot(model_c50)
predicted_c50 <- predict(model_c50, test_set, type="raw")
predicted_c50
###############
model_knn = train(Species ~ ., data=train_set, method='knn')
model_knn
plot(model_knn)
predicted_knn <- predict(model_knn, test_set, type="raw")
predicted_knn
###############
comp=cbind(predicted_c50,predicted_knn)
comp
