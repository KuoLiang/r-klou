a = c(1,2,3,4,5)
b = c("1","2","3","4","5")
c = c(5,4,3,2,1)
e = c(5,4,3,2)
length(a)
length(b)
length(c)
length(e)
mode(a)
mode(b)
mode(c)
mode(e)
a/3
b/3   #error
c/3
e/3
d = a+c
d
d = a/c
d = a/e #warning
#####
c[1]
c[c(1,3)]
a<3
a<c
any(a<c)
any(a<=c)
all(a>c)
all(a>=c)
