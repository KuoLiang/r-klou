install.packages("ROCR")
library(ROCR)
data(ROCR.simple)
ROCR.simple
ROCR.simple$predictions
ROCR.simple$labels
pred <- prediction( ROCR.simple$predictions, ROCR.simple$labels) 
perf <- performance(pred,"tpr","fpr")
perf
plot(perf)
perf2 <- performance(pred, measure = "auc")
perf2@y.values
###

data(ROCR.hiv)
attach(ROCR.hiv)
pred.svm <- prediction(hiv.svm$predictions, hiv.svm$labels)
perf.svm <- performance(pred.svm, 'tpr', 'fpr')
pred.nn <- prediction(hiv.nn$predictions, hiv.svm$labels)
perf.nn <- performance(pred.nn, 'tpr', 'fpr')
plot(perf.svm, lty=3, col="red",main="SVMs and NNs for prediction of HIV-1 coreceptor usage")
plot(perf.nn, lty=3, col="blue",add=TRUE)
plot(perf.svm, avg="vertical", lwd=3, col="red", spread.estimate="stderror",plotCI.lwd=2,add=TRUE)
plot(perf.nn, avg="vertical", lwd=3, col="blue",
     spread.estimate="stderror",plotCI.lwd=2,add=TRUE)
legend(0.6,0.6,c('SVM','NN'),col=c('red','blue'),lwd=3)
