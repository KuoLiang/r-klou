#a list is a collection of data, they could be in different datatypes
#a list is ordered and changeable, ordered from 1, not zero!

a <- list("THU", c("math", "ee", "cs"), c(1,2,3)) # a list contain a string and a vector
b <- list(name = "THU", dept = c("math", "ee", "cs"), grade = c(1,2,3))

a[1] <- "NTHU" #change the first value of a list
a <- append(a,4:6)
a <- append(a,c(7:9))
typeof(a).     # a list
typeof(a[1])   # always return a list

a[[1]]
typeof(a[[1]]) # return the datatype of list member
typeof(a[[2]]) # return the datatype of list member
typeof(a[[3]]) # return the datatype of list member

a[[0]] #error

a[[2]][2] #get the second member's second member
b$dept    #get value by $name
b$dept[2] #get value by $name and it's second member

# combine lists
b <- list("hello")
c <- c(a,b)
c

