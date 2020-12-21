install.packages('RMySQL')
library(RMySQL)

#======== Northwind
#connect = dbConnect(RMySQL::MySQL(), dbname = "northwind",username = "student",
#                    password = "1kRw5HRkM1O64HYj",host = "10.8.0.1")
#XMAPP
connect = dbConnect(RMySQL::MySQL(), dbname = "northwind",username = "root",
                    password = "",host = "localhost") #127.0.0.1
dbListTables(connect)
NW = dbGetQuery(connect ,"select * from orders")
NW

#======== covid19 TW count by date
connect2 = dbConnect(RMySQL::MySQL(), dbname = "covid19",username = "student",
                     password = "1kRw5HRkM1O64HYj",host = "10.8.0.1")
dbListTables(connect2)
CT = dbGetQuery(connect2 ,"select count(*) from cases_tw")
CT

#======== covid19 TW VS immigration (port)
CT2 = dbGetQuery(connect2 ,"select * from cases_tw")
CT2
CT3 = dbGetQuery(connect2 ,"
SELECT c.confirm_date,count(c.confirm_date) as cases ,p.*
FROM `cases_tw` as c, port as p
WHERE c.confirm_date=p.date
GROUP BY c.confirm_date desc")
CT3

lmMod = lm(cases ~ TY1+TY2+KS+TP , data=CT3)
lmMod
summary(lmMod)

#======== covid19 TW VS 539

CT539 = dbGetQuery(connect2 ,"
SELECT c.confirm_date,count(c.confirm_date) as cases ,lot539.*
FROM `cases_tw` as c, lot539
WHERE c.confirm_date=lot539.p_date
GROUP BY c.confirm_date desc")
CT539

lmMod539 <- lm(cases ~ sale+num+price+n1+n2+n3+n4+n5 , data=CT539)
lmMod539 <- lm(cases ~ sale , data=CT539)
lmMod539
summary(lmMod539)