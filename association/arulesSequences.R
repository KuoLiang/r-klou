# https://en.wikibooks.org/wiki/Data_Mining_Algorithms_In_R/Sequence_Mining/SPADE
#install.packages("arulesSequences")
library(arulesSequences)
library(arules)
data(zaki)
#zaki data https://github.com/cran/arulesSequences/blob/master/inst/misc/zaki.txt
zaki
summary(zaki)
zaki_df = as(zaki, "data.frame")
zaki_df
#############以下轉換為 transactional data
x = read_baskets(con = system.file("misc", "zaki.txt", package = "arulesSequences"), 
                  info = c("sequenceID","eventID","SIZE"))
x
# 以下使用 cspade
s1 = cspade(x, parameter = list(support = 0.4), control = list(verbose = TRUE))
s1
summary(s1)
### 以下較容易閱讀
as(s1, "data.frame")
r1 = as(ruleInduction(s1, confidence = 0.4, control = list(verbose = TRUE)), "data.frame")
r1

