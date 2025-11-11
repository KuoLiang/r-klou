##########################################
#Editor: Kuo-Liang Ou
#National Tsing Hua University ILST
##########################################

library(datasets) #load built-in dataset
str(iris)       #show structure, notice: the lable attribute must be the factor data type

subset(iris, Species == "setosa" | Species =="versicolor") # OR
subset(iris, Species == "setosa" , Species =="versicolor") # AND
subset(iris, Species == "setosa" & Species =="versicolor") # AND
subset(iris, Species != "setosa" )[1:5,]

summary(iris)

####

par(mar=c(7,5,1,1)) # more space to labels 下左上右 inches
boxplot(iris,las=2)
irisVer <- subset(iris, Species == "versicolor")
irisSet <- subset(iris, Species == "setosa")
irisVir <- subset(iris, Species == "virginica")

par(mfrow=c(1,3),mar=c(6,3,2,1))  #一列三欄
boxplot(irisVer[,1:4], main="Versicolor",ylim = c(0,8),las=2)
boxplot(irisSet[,1:4], main="Setosa",ylim = c(0,8),las=2)
boxplot(irisVir[,1:4], main="Virginica",ylim = c(0,8),las=2)


##

hist(iris$Petal.Length)
par(mfrow=c(1,3))
hist(irisVer$Petal.Length,breaks=seq(0,8,l=17),xlim=c(0,8),ylim=c(0,40))
hist(irisSet$Petal.Length,breaks=seq(0,8,l=17),xlim=c(0,8),ylim=c(0,40))
hist(irisVir$Petal.Length,breaks=seq(0,8,l=17),xlim=c(0,8),ylim=c(0,40))

##
if (!require("beanplot")) install.packages("beanplot")
library(beanplot)
xiris <- iris
xiris$Species <- NULL
beanplot(xiris, main = "Iris flowers",
         col=c('#ff8080','#0000FF','#0000FF','#FF00FF'), border = "#000000")

###
if (!require("C50")) install.packages("C50")
library(C50)
input <- iris[,1:4]
output <- iris[,5]
model1 <- C5.0(input, output, control = C5.0Control(noGlobalPruning = TRUE,minCases=1))
plot(model1,main="C5.0 Decision Tree - Unpruned, min=1") #try to change minCases to 3

model2 <- C5.0(input, output, control = C5.0Control(noGlobalPruning = FALSE))
plot(model2, main="C5.0 Decision Tree - Pruned")
newcases <- iris[c(1:3,51:53,101:103),]
#newcases2 = data.frame(Sepal.Length=c(1,2,3),Sepal.Width=c(2,3,4),
#                       Petal.Length=c(3,4,5),Petal.Width=c(4,5,6),
#                       Spaecies=c(NA,NA,NA)) #maka a new cases data frame
#above are non-sense iris cases, but you can try it

newcases
predicted <- predict(model1, newcases, type="class")
predicted

#show the paried list by dataframe
result_frame= data.frame(newcases$Species,predicted)
result_frame
result_frame= data.frame(ori=newcases$Species,pre=predicted)
result_frame

# table(x,y) count the match number between two factors objects
# show the confusion matrix
result_table= table(newcases$Species,predicted)
result_table


