setwd("/Users/klou/Documents/GitHub/r-klou/2-preProcess") #change the working dir to yours
source("querycast.R") #引用外部獨立程式碼
################################################
# query db
################################################
SQL_String <- "SELECT e.firstname, month(o.OrderDate) as Month, avg(quantity) as num 
from `order_details` as od, orders as o,employees as e 
where od.orderid = o.orderid AND o.employeeid = e.employeeid 
group by e.firstname,Month order by e.firstname,Month"
      
quantity = dbSendQuery(mysqlconnection, SQL_String) 
quan_mat=query_cast(quantity)
dbClearResult(quantity)


SQL_String <-"SELECT e.firstname, month(o.OrderDate) as Month, avg(unitprice) as num
from `order_details` as od, orders as o,employees as e
where od.orderid = o.orderid AND
o.employeeid = e.employeeid
group by e.firstname,Month
order by e.firstname,Month"

unitprice = dbSendQuery(mysqlconnection, SQL_String)
unpr_mat=query_cast(unitprice)
dbClearResult(unitprice)


SQL_String <- "SELECT e.firstname, month(o.OrderDate) as Month, avg(freight) as num
from `order_details` as od, orders as o,employees as e
where od.orderid = o.orderid AND
o.employeeid = e.employeeid
group by e.firstname,Month
order by e.firstname,Month"
freight = dbSendQuery(mysqlconnection, SQL_String)

frig_mat=query_cast(freight)
dbClearResult(freight)

################################################
# show up
################################################

quan_mat
class(quan_mat)
unpr_mat
class(unpr_mat)
frig_mat
class(frig_mat)


