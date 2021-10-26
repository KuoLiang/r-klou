a = c(1,2,3)
b = c(4,5,6)
c = c("a","b","c")

mydf = data.frame(a,b,c)
mydf

mydf$a            #numeric
mydf$c            #character

mydf[2,]          ##data.frame  某一列,跨不同行
mydf[,2]          #numeric      某一行,vector 需相同 type
mydf[,3]          #character    某一行,vector 需相同 type

mydf[1,1]         #numeric      某一個值
mydf[1,3]         #character    某一個值

mydf[2]           #data.frame   回傳單一行之DF,請比較mydf[,2]
mydf[,1:2]        #data.frame

class(mydf[2])     #reveal the data type
dimnames(mydf)
rownames(mydf)
colnames(mydf)
nrow(mydf)
ncol(mydf)
dim(mydf)
summary(mydf)
