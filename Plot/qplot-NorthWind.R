##########################################
#Editor: Kuo-Liang Ou
#Affililation: National Tsing Hua University ILST
#Reference: ggplot2 cheat sheet
##########################################
source("mysql_conn.R") #connect to mysql

nw <-  fetch(myquery_result, n=-1)  #read all the data from result
#setwd("somewhere of your working directory")
#nw <-  read.csv("https://github.com/KuoLiang/r-klou/blob/f6cc7b13890bbedd42d9e5d4a7e684dafa239495/Plot/NWSales.csv")
nw
##########################################
#transform
##########################################
nw$Year = factor(nw$Year)
nw$EmployeeID = factor(nw$EmployeeID)
nw$ShipCountry = factor(nw$ShipCountry)

##########################################
library(ggplot2)
#
qplot(data=nw,x=EmployeeID) # 指定X軸 類別型資料
qplot(data=nw,x=Sales) # 指定X軸 連續型資料
qplot(data=nw,x=EmployeeID,y=Sales) # 指定X Y 軸
#
qplot(data=nw,x=EmployeeID,y=Sales,
      color=Year,size=3) #依年份分色,指定點的大小
qplot(data=nw,x=EmployeeID,y=Sales,
      color=Year, facets = "Year") #依年份分色分平面

qplot(data=nw,x=EmployeeID,y=Sales,
      color=Year,shape=I(5),alpha=I(0.5), #點型及透明度
      main="The NorthWind",xlab="員工",ylab="業績")


######
qplot(data=iris,x=Petal.Width,y=Petal.Length,
      size=3)
qplot(data=iris,x=Species,y=Petal.Length,
      size=I(10))
qplot(data=iris,x=Species,y=Petal.Length,
      size=I(10),color=I("red"))
qplot(data=iris,x=Species,y=Petal.Length,
      )   

#########
nw_France=nw[nw$ShipCountry=="France",]
nw_France
