install.packages("PRROC")
library(PRROC)
C1 = rnorm(300); #mean = 0 ; sd =1
C1
C2 = rnorm(300,-2); #mean = -5 ; sd =1
C2
###
roc = roc.curve(C1, C2, curve = TRUE)
roc
plot(roc)
###

pr = pr.curve(C1, C2, curve = TRUE)
pr
plot(pr)
####