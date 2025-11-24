##########################################
#Editor: Kuo-Liang Ou
#National Tsing Hua University ILST
##########################################
#ROC = the probability curve of the values 
#AUC = separability of the different groups of values/labels.
if (!require("PRROC")) install.packages("PRROC")
library(PRROC)
if (!require("verification")) install.packages("verification")
library(verification)
set.seed(2025)
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

### C1 C2 ROC and threshold C1=postive score C2=negative score
#Sensitividy = TPR
roc_12 = roc.curve(C1, C2, curve = TRUE) #curve must be T
roc_12
plot(roc_12)

### C1 C3 ROC and threshold
roc_13 = roc.curve(C1, C3, curve = TRUE) #curve must be T
roc_13
plot(roc_13)

### C2 C3 ROC and threshold
roc_23 = roc.curve(C2, C3, curve = TRUE) #curve must be T
roc_23
plot(roc_23)
#################################
### PR Curve - Precision-Recall
#################################
pr = pr.curve(C1, C2,curve = TRUE) #C1 positive C2 negative
pr
plot(pr)

### PR Curve - Precision-Recall
pr = pr.curve(C1, C3,curve = TRUE) #C1 positive C3 negative
pr
plot(pr)

### PR Curve - Precision-Recall
pr = pr.curve(C2, C3,curve = TRUE) #C2 positive C3 negative
pr
plot(pr)
#############################################################
#以上圖形中之顏色為分割點 threshold
#############################################################

