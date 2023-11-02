#make three vectors a,b,c
a = c(2,3,4)
b = c(5,6,7)
c = c("A","B","C")

# a dataframe is constructed by vector(s)
mydf = data.frame(a,b,c)
mydf #showout

#retrieve one of vectors of a dataframe
mydf$a            #numeric
mydf$c            #character

mydf[2,]          ##data.frame and list 某一列,跨不同行
mydf[,2]          #numericand double    某一行,vector 需相同 type
mydf[,3]          #character and character   某一行,vector 需相同 type

mydf[1,1]         #numeric and double     某一個值
mydf[1,3]         #character and character   某一個值

mydf[2]           #data.frame   回傳單一行之DF,請比較mydf[,2]
mydf[,1:2]        #data.frame and list ,請小心與 python 的語法不同處

typeof(mydf) # the type in memory
class(mydf)  # the type in present

e = mydf$c        #set e to any one above for the next two commands
mode(e)           #mostly as the same as type of, used in S language
class(e)          #reveal the present of e
typeof(e)         #reveal the data type of e

#mode() gives the "type" of object from the point of view of 
#          S language
#class() is used to define/identify what "type" an object is from 
#        the point of view of object-oriented programming in R.
#typeof() gives the "type" of object from R's point of view

head(mydf)     
tail(mydf)

dimnames(mydf)
rownames(mydf)
colnames(mydf)
nrow(mydf)
ncol(mydf)
dim(mydf)
summary(mydf)


