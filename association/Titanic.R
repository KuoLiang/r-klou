library(arules)
library(arulesViz)
str(Titanic)
Titanic.df <- as.data.frame(Titanic)
Titanic.df

Titanic.raw=NULL
for(i in 1:4)
{
  Titanic.raw = cbind(Titanic.raw,
                      rep(as.character(Titanic.df[,i]),
                          Titanic.df$Freq))
}
Titanic.raw
Titanic.raw = as.data.frame(Titanic.raw)
names(Titanic.raw) = names(Titanic.df)[1:4]
Titanic.raw.factor <- as.data.frame(unclass(Titanic.raw),                     # Convert all columns to factor
                       stringsAsFactors = TRUE) #convert to factor

rules.all <- apriori(Titanic.raw.factor)
rules.all
inspect(rules.all)

plot(rules.all,interactive=TRUE)
x <- rules.all@quality$support
y <- rules.all@quality$confidence
text(x, y, rownames(rules.all@quality))

rules <- apriori(Titanic.raw.factor, control = list(verbose=F),
                 parameter = list(minlen=2, supp=0.005, conf=0.8), 
                 appearance = list(rhs=c("Survived=No", "Survived=Yes"), 
                                   default="lhs"))
rules.sorted <- sort(rules, by="lift")
inspect(rules.sorted)
