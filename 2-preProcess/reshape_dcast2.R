setwd("/Users/klou/Documents/GitHub/r-klou/2-preProcess") #change the working dir to yours
source("querycast.R")
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
order by e.firstname,Month")

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
unpr_mat
frig_mat

pf_quan_mat <- as.matrix(quan_mat[,-1])
rownames(pf_quan_mat) <- pf_quan_df$firstname
pf_quan_mat

pf_unpr_mat <- as.matrix(unpr_mat[,-1])
rownames(pf_unpr_mat) <- pf_unpr_df$firstname
pf_unpr_mat

performance = pf_quan_mat * pf_unpr_mat
matplot(t(performance),type="b",pch=15:22,col=c(1:6))
legend("topleft",legend=rownames(performance),pch=15:22,col=c(1:6))


####
pf_frig_mat <- as.matrix(frig_mat[,-1])
rownames(pf_frig_mat) <- pf_frig_df$firstname
pf_unpr_mat

performance2 = pf_quan_mat * pf_unpr_mat - pf_frig_mat

matplot(t(performance2),type="b",pch=15:22,col=c(1:6))
legend("topleft",legend=rownames(performance2),pch=15:22,col=c(1:6))
