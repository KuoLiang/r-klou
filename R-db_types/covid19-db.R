install.packages('RMySQL')
library(RMySQL)

connect = dbConnect(RMySQL::MySQL(), dbname = "northwind",username = "student", 
                    password = "TJV2bFTkQuLyPdvR",host = "10.8.0.1")
dbListTables(connect)
NW = dbGetQuery(connect ,"select * from orders")
NW
class(NW)
############
connect2 = dbConnect(RMySQL::MySQL(), dbname = "covid19",username = "student", 
                     password = "35162",host = "120.127.169.83")
dbListTables(connect2)

CT = dbGetQuery(connect2, "SET NAMES 'utf8'") 
CT = dbGetQuery(connect2 ,"select * from cases_tw")
CT
CT = dbGetQuery(connect2 ,"select id,國籍別,性別 from cases_tw")
CT
class(CT)
CT$國籍別=as.factor(CT$國籍別)
CT$性別=as.factor(CT$性別)
