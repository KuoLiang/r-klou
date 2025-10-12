# Define a vector of package names to be installed
packages_to_install <- c("RMySQL", "reshape2")
# Create a function to check for and install packages
install_if_missing <- function(pkg) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg)
  }
}
# Use lapply to apply the function to each package in the vector
lapply(packages_to_install, install_if_missing)

# Load the installed packages
lapply(packages_to_install, library, character.only = TRUE)
################
query_cast = function(query_result){
  query_df=fetch(query_result, n = -1) 
  mycast=dcast(query_df,
               firstname~Month,
               fun.aggregate = sum,
               value.var = "num",
               fill = NA_real_)
}
mysqlconnection = dbConnect(MySQL(), user = 'student', password = 'q[eTIK7PJO[r5pzG', 
                            dbname = 'northwind' ,host = '10.8.0.1')
dbListTables(mysqlconnection)
################
SQL_String <- "SELECT e.firstname, month(o.OrderDate) as Month, avg(quantity) as num
from `order_details` as od, orders as o,employees as e
where od.orderid = o.orderid AND
o.employeeid = e.employeeid
group by e.firstname,Month
order by e.firstname,Month"
quantity = dbSendQuery(mysqlconnection, SQL_String) 
quantity 
pf_quan_df=query_cast(quantity)
pf_quan_df
################

SQL_String <- "SELECT e.firstname, month(o.OrderDate) as Month, avg(unitprice) as num
from `order_details` as od, orders as o,employees as e
where od.orderid = o.orderid AND
o.employeeid = e.employeeid
group by e.firstname,Month
order by e.firstname,Month"

unitprice = dbSendQuery(mysqlconnection, SQL_String)
pf_unpr_df=query_cast(unitprice)
pf_unpr_df
###

SQL_String <-"SELECT e.firstname, month(o.OrderDate) as Month, avg(freight) as num
from `order_details` as od, orders as o,employees as e
where od.orderid = o.orderid AND
o.employeeid = e.employeeid
group by e.firstname,Month
order by e.firstname,Month"

freight = dbSendQuery(mysqlconnection, SQL_String)
pf_frig_df=query_cast(freight)
pf_frig_df

################
pf_quan_mat <- as.matrix(pf_quan_df[,-1]) # no employees' name
rownames(pf_quan_mat) <- pf_quan_df$firstname # employees' name here
pf_quan_mat
