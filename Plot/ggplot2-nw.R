'''
SELECT e.EmployeeID, Year(o.OrderDate),o.ShipCountry, od.Quantity*od.UnitPrice as , od.Discount, o.Freight
FROM employees as e, orders as o, `order details` as od
WHERE e.EmployeeID=o.EmployeeID
AND o.OrderID = od.OrderID
'''

nw = read.csv("/Users/klou/Downloads/e.csv")
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
