library(infotheo)
myiris<-discretize(iris,"equalwidth",5)
table(myiris)



library(discretization)
chi1<-chiM(iris,alpha=0.05)