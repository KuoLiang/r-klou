install.packages("lattice")
data("singer",package="lattice")
singer
library(beanplot)

par(lend =1, mai=c(0.8,0.8,0.5,0.5))
beanplot(height ~ voice.part, data = singer, ll=0.04, side="both",
         col=list("black","grey"))
legend("bottomleft", fill=c("black","grey"),legend =c("1","2"))

beanplot(height ~ voice.part, data = singer, ll=0.04, side="both",
         col=list("black","grey"))
legend("bottomleft", fill=c("black","grey"),legend =c("1","2"))

A.1=c(1,2,1,2,3,4,3,2,1)
a.2=c(1,2,1,2,1,2,1,2,1)
c=as.factor(a.2)
df=data.frame(A.1,c)
df
beanplot(A.1 ~ c, data = df,side = "both",col=list("black","grey"))

summary(df)
data(iris)
iris
xiris <- iris
xiris$Species <- NULL
beanplot(xiris)
beanplot(xiris,side = "both",col=list("black","grey"),ll=0.02)
