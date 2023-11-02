#建立變數x ，為vector 物件，內容為五個數值

x <- c(10.4, 5.6, 3.1, 6.4, 21.7)
x = c(10.4, 5.6, 3.1, 6.4, 21.7)
x         #顯示 x
y = 1/x   #一次處理vector中所有物件
y
y <- c(x, 0, x) #建立vector y,內容為 x0x
y
labs <- paste(c("X","Y","Z"), 100:200, sep="_")
labs
x = c("hello","world") #x 為 char vector

####

y <- x[!is.na(x)] #把不是 NA的內容複製為 y
y <- c(x, NA, x)
y
z <- y[!is.na(y)]
w = y[3]
w = y[0]
w = y[1:3]
x[1:10]
w=c("x","y")[rep(c(1,2,2,1,1,2,1,2), times=4)]
w
###


x=c(1:10)
y=x[-(2:5)]
y=x[-c(2,3,6,7)]
###
library(datasets)
str(iris)
subset(iris, Species == "setosa")[1:5,] #[列，欄] 子集合setosa 前五列
subset(iris, Species == "setosa")[1:5,2] #[列，欄]子集合setosa 前五列第二欄
subset(iris, Species == "setosa")[,2] #[列，欄]子集合setosa 所有列第二欄
subset(iris, Species == "setosa")[,] #[列，欄]子集合setosa 所有列所有欄

###

subset(iris, Petal.Length < 2)[,"Species"] #取 Petal.Length 小於 2 為子集合
summary(iris) #iris 的概觀

###

par(mar=c(7,5,1,1)) # more space to labels
boxplot(iris,las=3)
irisVer <- subset(iris, Species == "versicolor")
irisSet <- subset(iris, Species == "setosa")
irisVir <- subset(iris, Species == "virginica")
par(mfrow=c(1,3),mar=c(6,3,2,1))
boxplot(irisVer[,1:4], main="Versicolor",ylim = c(0,8),las=2)
boxplot(irisSet[,1:4], main="Setosa",ylim = c(0,8),las=2)
boxplot(irisVir[,1:4], main="Virginica",ylim = c(0,8),las=2)


###

hist(iris$Petal.Width)

par(mfrow=c(1,3))
#par(mfcol=c(1,1))
hist(irisVer$Petal.Length,breaks=seq(0,8,l=17),xlim=c(0,8),ylim=c(0,40))
hist(irisSet$Petal.Length,breaks=seq(0,8,l=17),xlim=c(0,8),ylim=c(0,40))
hist(irisVir$Petal.Length,breaks=seq(0,8,l=17),xlim=c(0,8),ylim=c(0,40))
#
library(beanplot)
xiris <- iris
xiris$Species <- NULL
beanplot(xiris, 
         main = "Iris flowers",col=c('#ff8080','#0000FF','#0000FF','#FF00FF'), 
         border = "#000000")

##

corr <- cor(iris[,1:4])
round(corr,3)
corr <- cor(iris[,1:4])
corr

pairs(iris[,1:4])
