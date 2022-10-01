##########################################
#Editor: Kuo-Liang Ou
#Affililation: National Tsing Hua University ILST
#Reference: https://covid-19.nchc.org.tw/     國網中心
##########################################
install.packages('RMySQL')
library(RMySQL)

##########################################
#try to connect the northwind db
#please change your connection information by yourself
##########################################
connect <-  dbConnect(RMySQL::MySQL(), dbname = "northwind",username = "student", 
          password = "s?P%3p7DeGw5H#HM",host = "10.8.0.1")
dbListTables(connect)
NW <-  dbGetQuery(connect ,"select * from orders")
NW
class(NW)
NW$ShipCity
##########################################
connect19 <-  dbConnect(RMySQL::MySQL(), dbname = "covid19",username = "student", 
            password = "s?P%3p7DeGw5H#HM",host = "10.8.0.1")
dbListTables(connect19)

#set the character_set_client,connection,result of MySQL
C19 <-  dbGetQuery(connect19, "SET NAMES 'utf8'") 
C19 <-  dbGetQuery(connect19 ,"select * from export")
C19
#date data type should be transformed at first
C19 <-  dbGetQuery(connect19 ,"SELECT * FROM `export` WHERE `date` BETWEEN '2022-01-01' and '2022-01-31';")
C19
class(C19)
C19$press
