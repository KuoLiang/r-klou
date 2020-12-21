install.packages('RMySQL')
library(RMySQL)

connect = dbConnect(RMySQL::MySQL(), dbname = "northwind",username = "student", 
                    password = "1kRw5HRkM1O64HYj",host = "10.8.0.1")
dbListTables(connect)
NW = dbGetQuery(connect ,"select * from orders")
NW

connect2 = dbConnect(RMySQL::MySQL(), dbname = "covid19",username = "student", 
                    password = "1kRw5HRkM1O64HYj",host = "10.8.0.1")
dbListTables(connect2)
CT = dbGetQuery(connect2 ,"select count(*) from cases_tw")
CT
CT2 = dbGetQuery(connect2 ,"select * from cases_tw")
CT2
CT3 = dbGetQuery(connect2 ,"
SELECT c.confirm_date,count(c.confirm_date) as cases ,p.*
FROM `cases_tw` as c, port as p
WHERE c.confirm_date=p.date
GROUP BY c.confirm_date desc")
CT3

lmMod <- lm(cases ~ TY1+TY2+KS+TP , data=CT3)
lmMod
summary(lmMod)