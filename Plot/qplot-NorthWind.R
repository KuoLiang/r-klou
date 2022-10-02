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

library(ggplot2)
##########################################
#x 為連續資料 ; y 為連續資料
##########################################
qplot(data=nw,x=Freight,y=Sales)
qplot(data=nw,x=Freight,y=Sales,
      geom = "smooth")
qplot(data=nw,x=Freight,y=Sales,
      geom = "smooth")
qplot(data=nw,x=Freight,y=Sales,
      geom = "smooth", color=Year, facets = EmployeeID~Freight)

##########################################
#x 為類別資料 ; y 為連續資料
##########################################
qplot(data=nw,x=EmployeeID) # 指定X軸 類別型資料
qplot(data=nw,x=Sales) # 指定X軸 連續型資料
qplot(data=nw,x=EmployeeID,y=Sales) # 指定X Y 軸
#
qplot(data=nw,x=EmployeeID,y=Sales,
      color=Year,size=3) #依年份分色,指定點的大小
qplot(data=nw,x=EmployeeID,y=Sales,
      color=Year, facets = "Year") #依年份分色分平面
#
qplot(data=nw,x=EmployeeID,y=Sales,
      color=Year,shape=I(5),alpha=I(0.5), #點型及透明度
      main="The NorthWind",xlab="員工",ylab="業績") +
      theme(text = element_text(family = "Heiti TC Light")) 
# 主標題 main; xlab ylab 為軸標題；使用 Mac 繁體中文黑體
######
#其它圖型
######
qplot(data=nw,x=EmployeeID,y=Sales,
      geom="boxplot") # 箱形圖
qplot(data=nw,x=EmployeeID,y=Sales,
      geom="violin") #  提琴圖
qplot(data=nw,x=EmployeeID,y=Sales,
      geom="violin",ylim = c(1,5000)) # y 軸地板及天花板

##########################################
#篩資料
##########################################
nw_France=nw[nw$ShipCountry=="France",]
nw_France
nw_Expensive=nw[nw$Sales>1000 & nw$Sales<2000,]
nw_Expensive
