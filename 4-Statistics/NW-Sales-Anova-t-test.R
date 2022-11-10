library(dplyr)
source("../mysql_conn.R")
nw <-  fetch(myquery_result, n=-1) 
##########################################
#transform
##########################################
nw$Year = factor(nw$Year)
nw$EmployeeID = factor(nw$EmployeeID)
nw$ShipCountry = factor(nw$ShipCountry)

result=aov(Sales~EmployeeID,data=nw)
summary(result)
plot(nw$Sales~nw$EmployeeID)

result=aov(Sales~Year,data=nw)
summary(result)
plot(nw$Sales~nw$Year)

###########################################

x <- nw %>% filter(Year == 1994)  
y <- nw %>% filter(Year == 1995) 
z <- nw %>% filter(Year == 1996)   
t.test(x$Sales,y$Sales,var.equal = T)
t.test(x$Sales,z$Sales,var.equal = T)
t.test(y$Sales,z$Sales,var.equal = T)
