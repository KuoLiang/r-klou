?matplot
WorldPhones
myWP=WorldPhones
myWPmat=as.matrix(myWP)
matplot(myWPmat,type="b",pch=15:22,col=c(1:6))
legend("topleft",legend=colnames(myWP),pch=15:22,col=c(1:6))
