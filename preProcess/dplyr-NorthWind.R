##########################################
#Editor: Kuo-Liang Ou
#National Tsing Hua University ILST
##########################################
#setwd("somewhere your csv file located")
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
#pipeline  %>% 
#hotkey :Ctrl + Shift + M (Windows) or Cmd + Shift + M (Mac)
#########################
p <- nw %>% filter(Year == 1994) 
p <- nw %>% filter(Year != 1994) #NOT
p <- nw %>% filter(Year == 1994 | Year == 1995) # OR
p <- nw %>% filter(Year == 1994 & Year == 1995) # AND
p <- nw %>% filter(Year == 1994 & EmployeeID == 1)
p <- nw %>% filter(Sales >= mean(Sales))

#########################
#pipeline ctrl shift M
#group by ; need to associate with summarize(), filter() ,count() or mutate()
#########################
a <- group_by(nw,EmployeeID) #nothing happened

b <- filter(a,Sales >= mean(Sales))
b <- filter(group_by(nw,EmployeeID),Sales >= mean(Sales)) #the same

#########################
#filter() 
#########################
q <- nw %>% group_by(EmployeeID) 
q1 <- q %>% filter(Sales >= mean(Sales))

r <- nw %>% group_by(EmployeeID,ShipCountry) #group by two factors
r1 <- r %>% filter(Sales >= mean(Sales))  

#########################
#summarise() to aggregate with sum,mean,max,min
#########################

s1 <- q %>% summarise(sum(Sales))
s2 <- r %>% summarise(sum(Sales))
s20 <- r %>% summarise(Sales)   #quite different result
s21 <- r %>% summarise(max(Sales)) # see the EmployeeID =1 and Argentina
s22 <- r %>% summarise(min(Sales)) 
s23 <- r %>% summarise(mean(Sales)) 
s25 <- r %>% summarise(n()) #count 
s15 <- q %>% summarise(n()) #count 

#########################
#count() to aggregate
#########################
s11 <- q %>% count(EmployeeID)
s12 <- r %>% count(EmployeeID)

#########################
#mutate()
#########################
t1 <- mutate(q,Earn= Sales * (1-Discount)) #q has been grouped
t2 <- select(t1,-Sales) #all variables without Sales
t3 <- select(t1,Sales)  #only EmployeeID and Sales

t11 <- mutate(nw,Earn= Sales * (1-Discount)) #nw hasn't been grouped
t21 <- select(t11,-Sales) #all variables without Sales
t31 <- select(t11,Sales)  #only Sales

#########################
#combine variables
#########################

u <- bind_cols(t21,t31) # if you are sure the orders of two df
#
t2id <- rep(1:nrow(t2)) 
t22 <- cbind(id=t2id,t2)
t3id <- rep(1:nrow(t3)) 
t32 <- cbind(id=t3id,t3)

u1 <- left_join(t22,t32,by="id")
u2 <- right_join(t22,t32,by="id")
v <- bind_rows(t21,t31) # 2155 * 2 = 4310
