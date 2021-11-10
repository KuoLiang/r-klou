if (!require("ggplot2")) install.packages("ggplot2")
library(ggplot2)
d=diamonds
x=diamonds$carat
y=diamonds$price
z=diamonds$color
z1=diamonds[diamonds$color=="D",]
z2=subset(diamonds, color=="D" | color=="E")
z2=subset(diamonds, color=="D" | color=="E" & depth > 60)

plot(x)   #x 為重量，num
plot(y)   #y 為價錢，int
plot(z)   #z 為色澤，factor
plot(x,y) #xy vector
plot(x,y,col=z) #xy vector
plot(y,x) #yx vector
plot(z,y) #z factor;  y vetor boxplot
plot(y,z) #y vector;  z factor plot  
plot(z1,y)
#心得：X軸為類別型，Y軸為數值，會有 box統計
#心得：X軸為數值，就是各點分配圖
plot(diamonds) #請小心使用 same as the "pairs(d)"
plot(~x)
plot(~z)  
plot(y~z) #same as plot(z,y)
plot(y~x+z)
pairs(d)
########################################
w=diamonds$table  #w=table
coplot(y~x|z) #given z ,conditional plot
coplot(y~x|z+w)  #given z

########################################

data(AirPassengers)
class(AirPassengers)
AirPassengers
plot(AirPassengers)


