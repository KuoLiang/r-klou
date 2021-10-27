install.packages('RMySQL')
library(RMySQL)

connect = dbConnect(RMySQL::MySQL(), dbname = "northwind",username = "student", 
                    password = "TJV2bFTkQuLyPdvR",host = "10.8.0.1")
dbListTables(connect)
NW = dbGetQuery(connect ,"select * from orders")
NW

connect2 = dbConnect(RMySQL::MySQL(), dbname = "covid19",username = "student", 
                     password = "TJV2bFTkQuLyPdvR",host = "10.8.0.1")
dbListTables(connect2)
CT = dbGetQuery(connect2 ,"select * from cases_tw")
CT
class(CT)
class(NW)
