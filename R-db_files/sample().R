#target = iris
mysize=100
target = diamonds
nrow(target)
sample(nrow(target),mysize)
#iris[sample(nrow(target),mysize),]
target_samp=target[sample(nrow(target),mysize),]
target_samp
###
library(ggplot2)
qplot(diamonds$carat, diamonds$price)
qplot(target_samp$carat,target_samp$price)
#qplot(x,y,data,color)
qplot(carat,price,data=target_samp,color=cut)
