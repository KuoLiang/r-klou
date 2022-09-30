setwd("/Users/klou/Documents/GitHub/r-klou/preProcess")
nw <-  read.csv("NWSales.csv")
library(dplyr)
##########################################
#transform
##########################################
nw$Year = factor(nw$Year)
nw$EmployeeID = factor(nw$EmployeeID)
nw$ShipCountry = factor(nw$ShipCountry)
##########################################

summarise(nw,mean(Sales))
summarise(nw,max(Sales))
summarise(nw,min(Sales))
#########################
#filter
#########################
p <- nw %>% filter(Year == 1994)
p <- nw %>% filter(Year != 1994)
p <- nw %>% filter(Year == 1994 | Year == 1995)
p <- nw %>% filter(Year == 1994 & Year == 1995)
p <- nw %>% filter(Year == 1994 & EmployeeID == 1)
p <- nw %>% filter(Sales >= mean(Sales))

#########################
#pipeline ctrl shift M
#group by
#########################
q <- nw %>% group_by(EmployeeID) %>%
  filter(Sales >= mean(Sales))

q1 <- nw %>% group_by(EmployeeID,ShipCountry) %>%
  filter(Sales >= mean(Sales))
#########################
#summarise() to aggregate
#########################

r <- nw %>% group_by(EmployeeID) %>%
  filter(Sales >= mean(Sales)) %>%
  summarise(sum(Sales))
r1 <- nw %>% group_by(EmployeeID) %>%
  filter(Sales >= mean(Sales)) %>%
  count(EmployeeID)
