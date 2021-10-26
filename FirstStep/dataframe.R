a = c(1,2,3)
b = c(4,5,6)
c = c("a","b","c")

df = data.frame(a,b,c)
df
df$a            #numeric
df$c            #character
df[1,]          #numeric
df[,1]          #numeric
df[1,1]         #numeric
df[1]           #data.frame
df[1,]          #data.frame
df[,1:3]        #data.frame

class(df$a)     #numeric
class(df$c)     #character
class(df[,1])   #numeric
class(df[1,1])  #numeric
class(df[1])    #data.frame
class(df[1,])   #data.frame
class(df[,1:3]) #data.frame
