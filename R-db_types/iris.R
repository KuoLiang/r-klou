## ----iris_readdata-------------------------------------------------------
library(datasets)
str(iris)


## ----iris_showdata-------------------------------------------------------
# Get first 5 rows of each subset
subset(iris, Species == "setosa")[1:5,]
subset(iris, Species == "versicolor")[1:5,]
subset(iris, Species == "virginica")[1:5,]


## ----iris_showdata2------------------------------------------------------
# Get column "Species" for all lines where Petal.Length < 2
subset(iris, Petal.Length < 2)[,"Species"]


## ----iris_showdata2a-----------------------------------------------------



## ----iris_stats1---------------------------------------------------------
summary(iris)


## ----iris_boxplot, fig.width=7, fig.height=7-----------------------------
par(mar=c(7,5,1,1)) # more space to labels (margin)
boxplot(iris,las=0) # las 0,1,2,3 水平或直顯

## ----iris_boxplotc1, fig.width=7, fig.height=7---------------------------
irisVer <- subset(iris, Species == "versicolor")
irisSet <- subset(iris, Species == "setosa")
irisVir <- subset(iris, Species == "virginica")
par(mfrow=c(1,3),mar=c(6,3,2,1))   #frow 行列並排
boxplot(irisVer[,1:4], main="Versicolor",ylim = c(0,6),las=2)
boxplot(irisSet[,1:4], main="Setosa",ylim = c(0,8),las=2)
boxplot(irisVir[,1:4], main="Virginica",ylim = c(0,8),las=2)


## ----iris_histo1, fig.width=7, fig.height=7------------------------------
hist(iris$Petal.Length)


## ----iris_histo2, fig.width=10, fig.height=7-----------------------------
par(mfrow=c(1,3))
hist(irisVer$Petal.Length,breaks=seq(0,8,l=17),xlim=c(0,8),ylim=c(0,40))
hist(irisSet$Petal.Length,breaks=seq(0,8,l=17),xlim=c(0,8),ylim=c(0,40))
hist(irisVir$Petal.Length,breaks=seq(0,8,l=17),xlim=c(0,8),ylim=c(0,40))


## ----iris_beanpl1, fig.width=7, fig.height=7, message=FALSE, warning=FALSE----
library(beanplot)
xiris <- iris
xiris$Species <- NULL
beanplot(xiris, main = "Iris flowers",col=c('#ff8080','#0000FF','#0000FF','#FF00FF'), border = "#000000")


## ----iris_corr1----------------------------------------------------------
corr <- cor(iris[,1:4])
round(corr,3)


## ----iris_scatterpl1, fig.width=8, fig.height=8--------------------------
pairs(iris[,1:4])


## ----iris_scatterpl2, fig.width=8, fig.height=8--------------------------
pairs(iris[,1:4],col=iris[,5],oma=c(4,4,6,12))
par(xpd=TRUE)
legend(0.85,0.6, as.vector(unique(iris$Species)),fill=c(1,2,3))


## ----iris_scatterpl3, fig.width=8, fig.height=8, message=FALSE-----------
library(MASS)
parcoord(iris[,1:4], col=iris[,5],var.label=TRUE,oma=c(4,4,6,12))
par(xpd=TRUE)
legend(0.85,0.6, as.vector(unique(iris$Species)),fill=c(1,2,3))


## ----ml_dectrees_class1, fig.width=10, fig.height=8----------------------
library(C50)
input <- iris[,1:4]
output <- iris[,5]
model1 <- C5.0(input, output, control = C5.0Control(noGlobalPruning = TRUE,minCases=1))
plot(model1, main="C5.0 Decision Tree - Unpruned, min=1")


## ----ml_dectrees_class2, fig.width=10, fig.height=8----------------------
model2 <- C5.0(input, output, control = C5.0Control(noGlobalPruning = FALSE))
plot(model2, main="C5.0 Decision Tree - Pruned")


## ----ml_dectrees_class1a-------------------------------------------------
summary(model2)


## ----ml_dectrees_class1b-------------------------------------------------
C5imp(model2,metric='usage')


## ----ml_dectrees_predict-------------------------------------------------
newcases <- iris[c(1:3,51:53,101:103),]
newcases
predicted <- predict(model2, newcases, type="class")
predicted


## ----ml_dectrees_predict2------------------------------------------------
predicted <- predict(model2, iris, type="class")
predicted
iris$predictedC501 <- predicted


## ----ml_dectrees_predict3------------------------------------------------
iris[iris$Species != iris$predictedC501,]
