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
C3 = rnorm(300,2,2); #mean = 2 ; sd =2
C3
summary(C3)

### 觀察C1C2C3的分布
boxplot(C1,C2,C3)

### C1 C2 ROC and threshold
roc = roc.curve(C1, C2, curve = TRUE) #curve must be T
roc
plot(roc)

### PR Curve - Precision-Recall
pr = pr.curve(C1, C2,curve = TRUE) #C1 positive C2 negative
pr
plot(pr)

#############################################################
#以上圖形中之顏色為分割點 threshold
#############################################################

