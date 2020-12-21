install.packages("esquisse")
library("esquisse")
data(iris)
esquisser()
library("ggplot2")
ggplot(diamonds) +
  aes(x = cut, y = carat) +
  geom_violin(adjust = 1L, scale = "area", fill = "#0c4c8a") +
  labs(title = "Mytest") +
  theme_minimal()
