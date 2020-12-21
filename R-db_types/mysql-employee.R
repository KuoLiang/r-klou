install.packages("RMySQL")
library("RMySQL")
mysqlconnection = dbConnect(MySQL(), user = 'klou', password = '', dbname = 'northwind' ,host = '10.8.0.1')
dbListTables(mysqlconnection)

result = dbSendQuery(mysqlconnection, "select * from employees") 
mydataframe = fetch(result, n = 5) 
mydataframe
print(mydataframe)

result = dbSendQuery(mysqlconnection, "select UnitPrice,Quantity +
                     from `order details`") 
mydataframe = fetch(result,n=-1) 
mydataframe
summary(mydataframe)


result1 = dbSendQuery(mysqlconnection,
    "SELECT sum(od.unitprice*od.quantity) as performance
    FROM `order details` as od, orders as o , products as p
    WHERE od.orderid = o.OrderID
    and p.productid = od.productid
    and month(o.OrderDate) between 1 and 3
    group by p.categoryid") 
mydataframe1 = fetch(result1,n=-1) 
result2 = dbSendQuery(mysqlconnection,
    "SELECT sum(od.unitprice*od.quantity) as performance
    FROM `order details` as od, orders as o , products as p
    WHERE od.orderid = o.OrderID
    and p.productid = od.productid
    and month(o.OrderDate) between 4 and 6
    group by p.categoryid") 
mydataframe2 = fetch(result2,n=-1) 
mydataframe =cbind(mydataframe1,mydataframe2)
mymartix=as.matrix(mydataframe)
mymartix[2,1]
