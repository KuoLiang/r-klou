################################################
# db connection
################################################
install.packages("RMySQL")
library("RMySQL")
library("reshape2")
mysqlconnection = dbConnect(MySQL(), user = 'klou', password = '', dbname = 'northwind' ,host = '10.8.0.1')
dbListTables(mysqlconnection)
################################################
# define a function to cast the df to mat
################################################
query_cast = function(query_result){
    query_df=fetch(query_result, n = -1) 
    mycast=dcast(query_df,
                 firstname~Month,
                 fun.aggregate = sum,
                 value.var = "num",
                 fill = NA_real_)
    mymat=as.matrix(mycast[,-1])
    rownames(mymat) = mycast$firstname
    return(mymat)
}
################################################
# query db
################################################
quantity = dbSendQuery(mysqlconnection, 
"SELECT e.firstname, month(o.OrderDate) as Month, avg(quantity) as num
from `order details` as od, orders as o,employees as e
where od.orderid = o.orderid AND
o.employeeid = e.employeeid
group by e.firstname,Month
order by e.firstname,Month") 
quan_mat=query_cast(quantity)
dbClearResult(quantity)

unitprice = dbSendQuery(mysqlconnection, 
"SELECT e.firstname, month(o.OrderDate) as Month, avg(unitprice) as num
from `order details` as od, orders as o,employees as e
where od.orderid = o.orderid AND
o.employeeid = e.employeeid
group by e.firstname,Month
order by e.firstname,Month")
unpr_mat=query_cast(unitprice)
dbClearResult(unitprice)

freight = dbSendQuery(mysqlconnection, 
"SELECT e.firstname, month(o.OrderDate) as Month, avg(freight) as num
from `order details` as od, orders as o,employees as e
where od.orderid = o.orderid AND
o.employeeid = e.employeeid
group by e.firstname,Month
order by e.firstname,Month")
frig_mat=query_cast(freight)
dbClearResult(freight)

################################################
# show up
################################################

quan_mat
unpr_mat
frig_mat

performance = quan_mat * unpr_mat
performance2 = quan_mat * unpr_mat - frig_mat

matplot(t(performance),type="b",pch=15:22,col=c(1:6))
legend("topleft",legend=rownames(performance),pch=15:22,col=c(1:6))
