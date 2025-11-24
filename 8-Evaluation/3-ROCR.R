##########################################
#Editor: Kuo-Liang Ou
#National Tsing Hua University ILST
##########################################
#ROC = the probability curve of the values 
#AUC = separability of the different groups of values/labels.
#不同演算法比較

if (!require("ROCR")) install.packages("ROCR")
library(ROCR)
data(ROCR.simple)
ROCR.simple      #200 samples of 1 and 0
ROCR.simple$predictions
ROCR.simple$labels
pred <- prediction( ROCR.simple$predictions, ROCR.simple$labels) 
perf <- performance(pred,"tpr","fpr") 
perf
plot(perf)
#ROC curves: measure="tpr", x.measure="fpr".
#Precision/recall graphs: measure="prec", x.measure="rec". 
#Sensitivity/specificity plots: measure="sens", x.measure="spec".

perf2 <- performance(pred, measure = "auc")   #area under curve
perf2@y.values
###                                      
# acc: accuracy
# rec: recall
# prec: precision
perf3 <- performance(pred, measure = "rec")   #area under curve
perf3@y.values

