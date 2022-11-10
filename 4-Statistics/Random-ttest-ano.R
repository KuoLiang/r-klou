##########################################
#Editor: Kuo-Liang Ou
#Affililation: National Tsing Hua University ILST
#虛無假設H0（Null Hypothesis）對立假設H1（Alternative Hypothesis）
##########################################

x <-  rnorm(30,5,1) #30個隨機數，平均數5，標準差1
y <-  rnorm(30,4,1) #30個隨機數，平均數4，標準差1
y1 <-  rnorm(30,4,2) #30個隨機數，平均數4，標準差2
shapiro.test(x)   #檢視是否常態分配
shapiro.test(y)   #檢視是否常態分配
shapiro.test(y1)   #檢視是否常態分配
#單一樣本
t.test(x, mu = 5) #檢定 x 是否與 5   顯著差異, 結果不顯著，不拒絕 H0
t.test(x, mu = 4) #檢定 x 是否與 4   顯著差異, 結果顯著  ，拒絕 H0
t.test(y, mu = 5) #檢定 y 是否與 5   顯著差異, 結果顯著  ，拒絕 H0
t.test(y, mu = 4) #檢定 y 是否與 4   顯著差異, 結果不顯著，不拒絕 H0
t.test(y1, mu = 5) #檢定 y1 是否與 5 顯著差異, 結果顯著  ，拒絕 H0
t.test(y1, mu = 4) #檢定 y1 是否與 4 顯著差異, 結果不顯著，不拒絕 H0

## F 檢定
var.test(x, y)  #x,y  母體變異數相同
var.test(x, y1) #x,y1 母體變異數不相同
#獨立樣本 t 檢定
t.test(x,y,var.equal = T)  #x,y 母體變異數相同
t.test(x,y1,var.equal = F) #x,y1 母體變異數不相同

### Visualization

z <- append(x,y)
z <- append(z,y1)
class <- factor(rep(1:3,each=30))
z.dataframe <- data.frame(z,class)
a <- ggplot(data=z.dataframe,aes(x=class,y=z))
a + geom_boxplot()
a + geom_violin()

#============
#Anova
#============
library(report)
library(multcomp)

z <-  rnorm(90,5,1)  #90個隨機數，平均數5，標準差1
class <-  factor(rep(1:3,each=30)) #類別123 重複30次 total 90
z1 <-  data.frame(z,class)
result <- aov(z~class,data=z1)
summary(result)
report(result)
plot(z1$z~z1$class)

#post_hoc
#Tukey HSD test

post_test <- glht(result,linfct = mcp(class = "Tukey")) #指定 class 為比較對象
summary(post_test)
plot(post_test)


###############

z2 <-  c(z,rnorm(30,3,2)) #再加30個隨機數，平均數3，標準差2
class <-  factor(rep(1:4,each=30)) #類別1234 total 120
zc2 <-  data.frame(z2,class)
result2 <- aov(z2~class,data=zc2)
summary(result2)
report(result2)
plot(zc2$z2~zc2$class)

#post_hoc
#Tukey HSD test

post_test <- glht(result2,linfct = mcp(class = "Tukey")) #指定 class 為比較對象
summary(post_test)
plot(post_test)
