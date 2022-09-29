myquery <-
"SELECT e.EmployeeID, Year(o.OrderDate) as Year,o.ShipCountry, od.Quantity*od.UnitPrice as Sales,od.Discount, o.Freight
FROM employees as e, orders as o, orderdetails as od
WHERE e.EmployeeID=o.EmployeeID AND o.OrderID = od.OrderID"

#myquery <-  "select EmployeeID from employees"

install.packages("RMySQL")
library("RMySQL")
mysqlconnection <-  dbConnect(MySQL(), user = 'student', password = 's?P%3p7DeGw5H#HM', dbname = 'northwind' ,host = '10.8.0.1')
dbListTables(mysqlconnection)

result <-  dbSendQuery(mysqlconnection, myquery)
nw <-  fetch(result, n=-1)
#nw <-  read.csv("/Users/klou/Downloads/e.csv")
nw

nw$Year = factor(nw$Year)
nw$EmployeeID = factor(nw$EmployeeID)
nw$ShipCountry = factor(nw$ShipCountry)
library(ggplot2)
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
e <- ggplot(data=nw, aes(x=EmployeeID,y=Sales))
##########################################
e + geom_point()
p + geom_area()  #y=count
# geom_bar , summary as default
p <-  ggplot(data=nw, aes(x=EmployeeID,y=Sales,fill=Year))
p + geom_point()
p + geom_bar(stat="summary", fun="mean") #default position=stack
p + geom_bar(stat="summary", fun="mean",position = "dodge")
p + geom_bar(stat="summary", fun="mean",position = "fill") #normalized
# geom_col ,
p + geom_col()

q = ggplot(data=nw, aes(x=EmployeeID))
q + geom_histogram(stat="count")
q + geom_histogram(stat="count", color="Blue", fill="Green")

r = ggplot(data=nw, aes(x=Sales))
r + geom_histogram(binwidth=100, aes(fill=EmployeeID))
r + geom_histogram(binwidth=1000, aes(fill=EmployeeID), color="Black")
r + geom_density(aes(fill=EmployeeID,alpha = 0.2))
r + geom_density(aes(fill=EmployeeID),alpha= 0.2)+
    facet_wrap(~ EmployeeID)

s = ggplot(data=nw)
s + geom_histogram(aes(x=Sales))

t = ggplot(data=nw, aes(x=EmployeeID,y=Sales))
t + geom_boxplot()

u = ggplot(data=nw, aes(x=Sales))
u + geom_density(aes(fill=EmployeeID),alpha= 0.2)+
  facet_grid(EmployeeID~.)
