#a list is a collection of data, they could be in different datatypes
#a list is ordered and changeable, ordered from 1, not zero!

a <- list("THU", c("math", "ee", "cs"), c(1,2,3)) # a list contain a string and a vector
b <- list(name = "THU", dept = c("math", "ee", "cs"), grade = c(1,2,3))
a[1] #the list start from 1, not zero
a[2]
a[0]
a

a[1] <- "NTHU" #change the first value of a list
a <- append(a,4:6)
a <- append(a,c(7:9))
typeof(a)      # returns "list"
typeof(a[1])   # returns "list"
typeof(a[2])   # returns "list"
typeof(b)      # returns "list"
typeof(b[1])   # always returns "list"

#[[]] 運算子取得一個元素並保持原有的型態，可用數字或元素名稱
a
a[[1]]
typeof(a[[1]])
b
b[["name"]]      #記得加雙引號
b["name"]
b$name
b[1]
typeof(b[["name"]]) #character
typeof(b["name"])   #list
typeof(b$name)  #character
typeof(b[1])    #list

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

