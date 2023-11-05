###ANOVA knowledge
data1=read.csv(file="~klou/know.csv",header=T)
data1
summary(data1)
result1=aov(data1$score~factor(data1$id)+factor(data1$group))
summary(result1)
result11=aov(data1$score~data1$group)
summary(result11)
boxplot(data1$score~data1$group)

###ANOVA location
data2=read.csv(file="~klou/location.csv",header=T)
#data2
summary(data2)
result2=aov(data2$score~factor(data2$group))
summary(result2)
