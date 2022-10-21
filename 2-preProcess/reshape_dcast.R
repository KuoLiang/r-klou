
install.packages("RMySQL")
library("RMySQL")
library("reshape2")
mysqlconnection = dbConnect(MySQL(), user = 'student', password = '35162', 
                            dbname = 'northwind' ,host = '10.8.0.1')
dbListTables(mysqlconnection)
################
quantity = dbSendQuery(mysqlconnection, 
"SELECT e.firstname, month(o.OrderDate) as Month, avg(quantity) as num
from `order details` as od, orders as o,employees as e
where od.orderid = o.orderid AND
o.employeeid = e.employeeid
group by e.firstname,Month
order by e.firstname,Month") 

unitprice = dbSendQuery(mysqlconnection, 
"SELECT e.firstname, month(o.OrderDate) as Month, avg(unitprice) as num
from `order details` as od, orders as o,employees as e
where od.orderid = o.orderid AND
o.employeeid = e.employeeid
group by e.firstname,Month
order by e.firstname,Month")

freight = dbSendQuery(mysqlconnection, 
"SELECT e.firstname, month(o.OrderDate) as Month, avg(freight) as num
from `order details` as od, orders as o,employees as e
where od.orderid = o.orderid AND
o.employeeid = e.employeeid
group by e.firstname,Month
order by e.firstname,Month")


##############
query_cast = function(query_result){
  query_df=fetch(query_result, n = -1) 
  mycast=dcast(query_df,
               firstname~Month,
               fun.aggregate = sum,
               value.var = "num",
               fill = NA_real_)
}
pf_quan_df=query_cast(quantity)
pf_unpr_df=query_cast(unitprice)
pf_frig_df=query_cast(freight)

pf_quan_mat <- as.matrix(pf_quan_df[,-1])
rownames(pf_quan_mat) <- pf_quan_df$firstname
pf_quan_mat
