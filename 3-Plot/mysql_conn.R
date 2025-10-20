##########################################
#To avoid re-install packages
##########################################
# Package names
package_list <- c("ggplot2", "dplyr", "RMySQL")

# Install packages not yet installed
installed_packages <- package_list %in% rownames(installed.packages())
if (any(installed_packages == FALSE)) {
  install.packages(package_list[!installed_packages])
}

library("RMySQL")
myquery_string <-
  "SELECT e.EmployeeID, Year(o.OrderDate) as Year,o.ShipCountry, od.Quantity*od.UnitPrice as Sales,od.Discount, o.Freight
FROM employees as e, orders as o, order_details as od
WHERE e.EmployeeID=o.EmployeeID AND o.OrderID = od.OrderID"
#myquery <-  "select EmployeeID from employees"

mysqlconnection <-  dbConnect(MySQL(), user = 'student', password = '673cqdJ2s@t9Y@uc', dbname = 'northwind' ,host = '10.8.0.1')
dbListTables(mysqlconnection)

myquery_result <-  dbSendQuery(mysqlconnection, myquery_string)
