##########################################
#Editor: Kuo-Liang Ou
#Affililation: National Tsing Hua University ILST
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
  "SELECT * from dp002_exam"

mysqlconnection <-  dbConnect(MySQL(), user = 'student', password = 's?P%3p7DeGw5H#HM', dbname = 'edu113' ,host = '10.8.0.1')
dbListTables(mysqlconnection)

myquery_result <-  dbSendQuery(mysqlconnection, myquery_string)
