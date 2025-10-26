##########################################
#Editor: Kuo-Liang Ou
#Affililation: National Tsing Hua University ILST
##########################################
#install required packages
if (!require("esquisse")) install.packages("esquisse")
library("esquisse")
data(iris)
options("esquisse.viewer" = "browser")
esquisser() #or esquisser(iris)
library("ggplot2")
ggplot(diamonds) +
  aes(x = cut, y = carat) +
  geom_violin(adjust = 1L, scale = "area", fill = "#0c4c8a") +
  labs(title = "Mytest") +
  theme_minimal()
