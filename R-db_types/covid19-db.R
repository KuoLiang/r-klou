install.packages('RMySQL')
library(RMySQL)

connect = dbConnect(RMySQL::MySQL(), dbname = "northwind",username = "student", 
                    password = "35162",host = "klou.ilst.nthu.edu.tw")
dbListTables(connect)
NW = dbGetQuery(connect ,"select * from orders")
NW
class(NW)
############
connect2 = dbConnect(RMySQL::MySQL(), dbname = "covid19-2021",username = "student", 
                     password = "35162",host = "klou.ilst.nthu.edu.tw")
dbListTables(connect2)

CT = dbGetQuery(connect2, "SET NAMES 'utf8'") 
CT = dbGetQuery(connect2 ,"select * from daily")
CT
CT = dbGetQuery(connect2 ,"SELECT * FROM `daily` WHERE `日期` BETWEEN '2021-10-1' and '2021-10-31';")
CT
CT = dbGetQuery(connect2 ,"SELECT `新增確診數`,count(*) FROM `daily` group by `新增確診數`;")
CT
class(CT)
CT$新增確診數
