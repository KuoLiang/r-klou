library(tidyverse)
#計算150株 Sepal.Length 平均數
mean(iris$Sepal.Length)

#計算 setosa Sepal.Length 平均數土法練鋼
a <- filter(iris, Species == "setosa")
b <- a$Sepal.Length
c <- mean(b)
c

#或是合成一式

mean(filter(iris, Species == "setosa")$Sepal.Length)

# pipes : %>%  前一個運算結果作為下一個函式第一個參數
#         %$%  前一個運算結果作為下一個函式 data 參數
#         %T>% 前一個運算結果作為下 N 個函式第一個參數
#         %<>% 前一個運算結果作為下一個函式第一個參數且回傳更新左方的物件

#計算 setosa Sepal.Length 平均數
iris %>%            #command shift M
  subset(Species == "setosa",select = Sepal.Length) %>% 
  as.vector() %>% 
  unlist() %>% 
  mean()

#計算 setosa Sepal.Length 平均數另一種方法

iris %>%            #command shift M
  filter(Species == "setosa") %>%
  pull(Sepal.Length) %>% 
  str()
  mean()

iris %>% 
  lm( Sepal.Length ~ Sepal.Width , .) # when pipe to other place, use .

