#install.packages("ggplot2")
library(ggplot2)
qplot(data=iris,x=Species) # 指定X軸
qplot(data=iris,x=Petal.Width)
qplot(data=iris,x=Petal.Width,y=Petal.Length) # 指定X Y 軸

qplot(data=iris,x=Petal.Width,y=Petal.Length,
      color=Species) #依品種分色
qplot(data=iris,x=Petal.Width,y=Petal.Length,
      color=Species,shape=I(5)) #依品種分圖示
qplot(data=iris,x=Petal.Width,y=Petal.Length,
      color=Species,shape=I(19),alpha=I(0.5)) #透明
qplot(data=iris,x=Petal.Width,y=Petal.Length,
      color=Species,shape=I(19),alpha=I(0.5),
      main="IRIS") #title
######
qplot(data=iris,x=Petal.Width,y=Petal.Length,
      size=3)
qplot(data=iris,x=Species,y=Petal.Length,
      size=I(10))
qplot(data=iris,x=Species,y=Petal.Length,
      size=I(10),color=I("red"))
qplot(data=iris,x=Species,y=Petal.Length,
      geom="boxplot")   
#########
iris[iris$Species=="setosa",]
df=data.frame(c1=c(1,2,3),c2=c("a","b","c"))
df
