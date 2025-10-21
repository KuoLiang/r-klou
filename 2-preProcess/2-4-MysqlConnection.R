# Define a vector of package names to be installed
packages_to_install <- c("RMySQL", "reshape2")
# Create a function to check for and install packages
install_if_missing <- function(pkg) 
{
    if (!require(pkg, quietly = TRUE)) 
      {
        install.packages(pkg)
      }
}
install_if_missing(packages_to_install)
# Or use lapply (Apply a list to a function) to apply the function to each package in the vector
lapply(packages_to_install, install_if_missing) #lapply( list, function) 一次安裝多個 packages

# Load the installed packages 一次載入多個 packages
lapply(packages_to_install, library, character.only = TRUE)
################
#make a connection to Mysql
#please change user to "root"
#password change to ''
#host to "localhost" or "127.0.0.1"
################

mysqlconnection = dbConnect(MySQL(), user = 'student', password = '673cqdJ2s@t9Y@uc', 
                            dbname = 'northwind' ,host = '10.8.0.1')
dbListTables(mysqlconnection)

################
SQL_String <- 
"SELECT e.firstname, month(o.OrderDate) as Month, avg(quantity) as num
from `order_details` as od, orders as o,employees as e
where od.orderid = o.orderid AND
o.employeeid = e.employeeid
group by e.firstname,Month
order by e.firstname,Month"

query_result = dbSendQuery(mysqlconnection, SQL_String) 
query_df=fetch(query_result, n = -1) 
query_df
################

SQL_String <- 
"SELECT e.firstname, month(o.OrderDate) as Month, avg(unitprice) as num
from `order_details` as od, orders as o,employees as e
where od.orderid = o.orderid AND
o.employeeid = e.employeeid
group by e.firstname,Month
order by e.firstname,Month"

query_result = dbSendQuery(mysqlconnection, SQL_String) 
query_df=fetch(query_result, n = -1) 
query_df
###

SQL_String <-
"SELECT e.firstname, month(o.OrderDate) as Month, avg(freight) as num
from `order_details` as od, orders as o,employees as e
where od.orderid = o.orderid AND
o.employeeid = e.employeeid
group by e.firstname,Month
order by e.firstname,Month"

query_result = dbSendQuery(mysqlconnection, SQL_String) 
query_df=fetch(query_result, n = -1) 
query_df

################
