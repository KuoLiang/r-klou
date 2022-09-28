myquery =
"SELECT e.EmployeeID, Year(o.OrderDate) as Year,o.ShipCountry, od.Quantity*od.UnitPrice as Sales,od.Discount, o.Freight
FROM employees as e, orders as o, orderdetails as od
WHERE e.EmployeeID=o.EmployeeID AND o.OrderID = od.OrderID"

#myquery = "select EmployeeID from employees"
nw = read.csv("/Users/klou/Downloads/e.csv")

install.packages("RMySQL")
library("RMySQL")
mysqlconnection = dbConnect(MySQL(), user = 'student', password = 's?P%3p7DeGw5H#HM', dbname = 'northwind' ,host = '10.8.0.1')
dbListTables(mysqlconnection)

result = dbSendQuery(mysqlconnection, myquery)
nw = fetch(result, n=-1)
nw

nw$Year = factor(nw$Year)
nw$EmployeeID = factor(nw$EmployeeID)
library(ggplot2)
p = ggplot(data=nw, aes(x=EmployeeID,y=Year,size=Sales))
p + geom_point()

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
