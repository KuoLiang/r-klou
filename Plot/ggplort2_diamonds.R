install.packages("ggplot2")
library(ggplot2)
d=diamonds
x=diamonds$carat
y=diamonds$price
z=diamonds$color
z1=diamonds[diamonds$color=="D",]
z2=subset(diamonds, color=="D" | color=="E")
z2=subset(diamonds, color=="D" | color=="E" & depth > 60)

plot(x)   #x ?????um
plot(y)   #y ???嚗nt
plot(z)   #z ??瞉歹?actor
plot(x,y) #xy vector
plot(y,x) #yx vector
plot(z,y) #z factor;  y vetor boxplot
plot(y,z) #y vector;  z factor plot  
plot(z1,y)
#敹??頠貊憿???頠貊??潘???? box蝯梯??
#敹??頠貊??潘?停????????
plot(diamonds) #隢??蝙? same as the "pairs(d)"
plot(~x)
plot(~z)  
plot(y~z) #same as plot(z,y)
plot(y~x+z)
pairs(d)
########################################
w=diamonds$table  #w=table
coplot(y~x|z) #given z
coplot(y~x|z+w)  #given z

########################################
#require(stats); require(graphics) # for time
mydata=ldeaths
mydata$fdeaths
plot(ldeaths)
plot(mdeaths, fdeaths)
data(AirPassengers)
class(AirPassengers)
AirPassengers
plot(AirPassengers)


