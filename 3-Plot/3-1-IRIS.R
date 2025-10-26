################################
#REVIEW
################################

#前情提要：關於 vector 基礎操作
#建立變數x ，為vector 物件，內容為五個數值
#可使用hotkey 輸入 <-  
#Windows 使用 Alt -  
#Mac 使用 Option - 

x <- c(10.4, 5.6, 3.1, 6.4, 21.7)
x = c(10.4, 5.6, 3.1, 6.4, 21.7)
x         #顯示 x
y = 1/x   #一次處理vector中所有物件
y
y <- c(x, 0, x) #建立vector y,內容為 x0x （x為向量）
y
z <- paste("X",1)
z <- paste("Y",c(1:100), sep="") #可用於創造有特殊字首之學號
z <- paste(c("X","Y","Z"), 100:200, sep="_") #兩個向量元素配對時使用 _ 相連
z
#以上常用來創造新的 id 時使用

################################
#向量基本操作
################################
w = y[3]
w = y[0]      #不可以喲！序號由 1 開始，沒有第零號的元素
w = y[1:3]
x[1:10]
w=c("x","y")[rep(c(1,2,2,1,1,2,1,2), times=4)]
w

x=c(1:10)
y=x[-(2:5)]
y=x[-c(2,3,6,7)]


################################
#練習資料集切割技巧
################################
#使用 subset()

library(datasets)
str(iris)
subset(iris, Species == "setosa")[1:5,] #[列，欄] 子集合setosa 前五列
subset(iris, Species == "setosa")[1:5,2] #[列，欄]子集合setosa 前五列第二欄
subset(iris, Species == "setosa")[,2] #[列，欄]子集合setosa 所有列第二欄
subset(iris, Species == "setosa")[,] #[列，欄]子集合setosa 所有列所有欄

###

subset(iris, Petal.Length < 2)[,"Species"] #取 Petal.Length 小於 2 為子集合
summary(iris) #iris 的概觀

################################
# R 內建繪圖工具
################################
#more parameters, please see https://web.ntpu.edu.tw/~cflin/Teach/R/R06EN06Graphics.pdf

par(mar=c(7,5,1,1)) # par = graphical parameters, this makes more space to plots
boxplot(iris)
irisVer <- subset(iris, Species == "versicolor")
irisSet <- subset(iris, Species == "setosa")
irisVir <- subset(iris, Species == "virginica")

################################
#boxplot
################################

par(mfrow=c(1,3),mar=c(6,3,2,1))    #mfrow 指定一列三行
#par(mfrow=c(2,2),mar=c(6,3,2,1))    #mfrow 指定二列二行
#par(las = 0) # labels are horizontal to it's axis
#par(las = 1) # labels are horizontal to the plot 
#par(las = 2) # labels are vertical to it's axis
#par(las = 3) # lables are vertical to the plot
#以下各品種製一張圖，由左至右，由上而下排列
boxplot(irisVer[,1:4], main="Versicolor",ylim = c(0,8),las=0)
boxplot(irisSet[,1:4], main="Setosa",ylim = c(0,8),las=1)
boxplot(irisVir[,1:4], main="Virginica",ylim = c(0,8),las=2)

################################
#hist ( histogram )
################################

hist(iris$Petal.Width)

par(mfrow=c(1,3))
#par(mfcol=c(1,1))
hist(irisVer$Petal.Length,breaks=seq(0,8,l=17),xlim=c(0,8),ylim=c(0,40))
hist(irisSet$Petal.Length,breaks=seq(0,8,l=17),xlim=c(0,8),ylim=c(0,40))
hist(irisVir$Petal.Length,breaks=seq(0,8,l=17),xlim=c(0,8),ylim=c(0,40))

################################
#beamplot
################################

if (!require("beanplot")) install.packages("beanplot")
library(beanplot)
xiris <- iris
xiris$Species <- NULL
beanplot(xiris, 
         main = "Iris flowers",col=c('#ff8080','#0000FF','#0000FF','#FF00FF'), 
         border = "#000000")

##col = the vector of colors stand for the area of the beans,
                      # the lines inside the bean, 
                      # the lines outside the bean,
                      # and the average line per bean.

################################
#觀察各維度之間的關聯系數
################################


corr <- cor(iris[,1:4])
corr
corr <- cor(iris[,1:4])
round(corr,3)     #四捨五入小數第三位


#捉對比較以散布圖顯示，限numeric
pairs(iris[,1:4])
pairs(iris[,1:4], col = iris[,5])
