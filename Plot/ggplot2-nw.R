install.packages("ggplot2")
library(ggplot2)
install.packages("RMySQL")
library("RMySQL")
myquery <-
"SELECT e.EmployeeID, Year(o.OrderDate) as Year,o.ShipCountry, od.Quantity*od.UnitPrice as Sales,od.Discount, o.Freight
FROM employees as e, orders as o, orderdetails as od
WHERE e.EmployeeID=o.EmployeeID AND o.OrderID = od.OrderID"
#myquery <-  "select EmployeeID from employees"

mysqlconnection <-  dbConnect(MySQL(), user = 'student', password = 's?P%3p7DeGw5H#HM', dbname = 'northwind' ,host = '10.8.0.1')
dbListTables(mysqlconnection)

result <-  dbSendQuery(mysqlconnection, myquery)
nw <-  fetch(result, n=-1)
#setwd("Plot")
#nw <-  read.csv("NWSales.csv")
nw
##########################################
#transform
##########################################
nw$Year = factor(nw$Year)
nw$EmployeeID = factor(nw$EmployeeID)
nw$ShipCountry = factor(nw$ShipCountry)

##########################################
#One Variable - Continuous
c <-  ggplot(data=nw, aes(Sales))
##########################################
c + geom_area(stat="bin")
c + geom_area(stat="bin", binwidth=100)
c + geom_density()
c + geom_dotplot()
c + geom_dotplot(binwidth = 100)
c + geom_histogram()
c + geom_histogram(binwidth = 100)
##########################################
#One Variable - discrete
d <-  ggplot(data=nw, aes(EmployeeID))
d1 <-  ggplot(data=nw, aes(EmployeeID,fill=Year))
##########################################
d + geom_bar() #default y = count
d1 + geom_bar()
d1 + geom_bar(position="stack")
d1 + geom_bar(position="fill")
d1 + geom_bar(position="dodge")+ coord_flip()

##########################################
#Two Variables - Continuous X and Continuous Y
e <- ggplot(data=nw, aes(x=Freight,y=Sales))
e1 <-  ggplot(data=nw, aes(x=Freight,y=Sales,fill=Year,color=Year))
##########################################
e + geom_point()
e + geom_point() + geom_smooth()
e1+ geom_point() + geom_smooth()
e1+ geom_quantile() 

##########################################
#Two Variables - Discrete X and Continuous Y
f <- ggplot(data=nw, aes(x=EmployeeID,y=Sales))
f1 <-  ggplot(data=nw, aes(x=EmployeeID,y=Sales,fill=Year))
f2 <-  ggplot(data=nw, aes(x=ShipCountry,y=Sales))
##########################################
f + geom_point()
f + geom_bar(stat="summary", fun="mean") #default position=stack
f1 + geom_bar(stat="summary", fun="mean",position = "dodge")
f1 + geom_bar(stat="summary", fun="mean",position = "fill") #normalized
f1 + geom_boxplot()
f1 + geom_violin()
f2 + geom_violin()
f2 + geom_violin() + ylim(0,1000)
f2 + geom_violin() + ylim(0,1000) + coord_cartesian(ylim=c(0,500))

##########################################
#Facet
u <- ggplot(data=nw, aes(x=Sales))
##########################################

u + geom_density(aes(fill=EmployeeID),alpha= 0.2)+
  facet_grid(EmployeeID~.)
u + geom_density(aes(fill=EmployeeID),alpha= 0.2)+
  facet_grid(.~Year)
u + geom_density(aes(fill=EmployeeID),alpha= 0.2)+
  facet_grid(EmployeeID~Year)
##########################################

library(dplyr)
f <-  filter(nw, ShipCountry == "France")
f2 <- filter(f,Sales >= 1000, Sales <=1100)
f2
selected = select(iris, Sepal.Length, Sepal.Width, Petal.Length)
newIris = mutate(iris, greater.mean = Sepal.Width > mean(Sepal.Width))
newIris2 = mutate(iris, area = Sepal.Length * Sepal.Width)
myaesc = arrange(newIris, Petal.Length, Petal.Width)
mydesc = arrange(newIris, desc(Petal.Length), Petal.Width)