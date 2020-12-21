x = rnorm(30,5,1) #30個隨機數，平均數5，標準差1
y = rnorm(30,4,2) #30個隨機數，平均數4，標準差2
t.test(x,y,var.equal = T)
#============
z= rnorm(90,5,1)  #90個隨機數，平均數5，標準差1
class = factor(rep(1:3,each=30)) #類別123
zc= data.frame(z,class)
result=aov(z~class,data=zc)
summary(result)
plot(zc$z~zc$class)

z2 = c(z,rnorm(30,4,2)) #再加30個隨機數，平均數4，標準差2
class = factor(rep(1:4,each=30)) #類別123
zc2= data.frame(z2,class)
result2=aov(z2~class,data=zc2)
summary(result2)
plot(zc2$z2~zc2$class)