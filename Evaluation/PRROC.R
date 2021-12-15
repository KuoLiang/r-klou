install.packages("PRROC")
library(PRROC)
# random generate C1
C1 = rnorm(300); #mean = 0 ; sd =1
C1
summary(C1)
#random generate C2
C2 = rnorm(300,-2); #mean = -2 ; sd =1
C2
summary(C2)
#random generate C3
C3 = rnorm(300,2); #mean = 2 ; sd =1
C3
summary(C3)
### 觀察C1C2C3的分布
boxplot(C1,C2,C3)
###
roc = roc.curve(C1, C2, curve = TRUE) #curve must be T
roc
plot(roc)


###針對C1C2
### PR Curve - Precision-Recall
pr = pr.curve(C1, C2, curve = TRUE) #C1 positive C2 negative
pr
plot(pr)
### ROC
roc = roc.curve(C1, C2, curve = TRUE)
roc
plot(roc)
### PR Curve - Precision-Recall
pr = pr.curve(C2, C1, curve = TRUE) #C2 positive C1 negative
pr
plot(pr)
### ROC
roc = roc.curve(C2, C1, curve = TRUE)
roc
plot(roc)
#############################################################
#以上圖形中之顏色為分割點
#############################################################
###針對C1C3
### PR Curve - Precision-Recall
pr = pr.curve(C3, C1, curve = TRUE) #C3 positive C1 negative
pr
plot(pr)
### ROC
roc = roc.curve(C3, C1, curve = TRUE)
roc
plot(roc)
###針對C2C3
### PR Curve - Precision-Recall
pr = pr.curve(C3, C2, curve = TRUE)
pr
plot(pr)
### ROC
roc = roc.curve(C3, C2, curve = TRUE)
roc
plot(roc)
