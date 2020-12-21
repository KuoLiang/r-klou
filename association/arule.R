
install.packages("arules")
library(arules)

data("Adult")
Adult
rules = apriori(Adult, parameter = list(supp = 0.5, conf = 0.9))
rules.sorted = sort(rules,by="confidence")
inspect(rules.sorted)