##########################################
#Kuo-Liang Ou / NTHU ILST
#介紹管線 pipe 的使用法
##########################################
library(tidyverse)
#先複習計算150株 Sepal.Length 平均數
mean(iris$Sepal.Length)

#計算單一品種 setosa Sepal.Length 平均數土法練鋼
a <- filter(iris, Species == "setosa")
b <- a$Sepal.Length
c <- mean(b)
c

#或是合成一式

mean(filter(iris, Species == "setosa")$Sepal.Length)

# pipe  : %>%  前一個運算結果作為下一個函式第一個參數
#         %$%  前一個運算結果作為下一個函式 data 參數
#         %T>% 前一個運算結果作為下二個函式第一個參數
#         %<>% 前一個運算結果作為下一個函式第一個參數且回傳更新左方的物件

# %>%  前一個運算結果作為下一個函式第一個參數
#計算 setosa Sepal.Length 平均數
iris %>%            #command shift M
  subset(Species == "setosa",select = Sepal.Length) %>% 
  as.vector() %>% 
  unlist() %>% 
  mean()

#計算 setosa Sepal.Length 平均數另一種方法

iris %>%            #command shift M
  filter(Species == "setosa") %>%
  pull(Sepal.Length) %>%        #similar to $; used in pipe
  #pull(1) %>%                  #the same as above
  mean()

##

iris %>% 
  lm( Sepal.Length ~ Sepal.Width , .) # when pipe to other place, use .

####################
# %$%  前一個運算結果作為下一個函式 data 參數
####################
library(magrittr) # %>% 內建於 tidyverse; %$% is included in magrittr 
iris %$% 
  lm( Sepal.Length ~ Sepal.Width) %>% # assign iris to data
  plot()

#an example of svm
x <- subset(iris, select = -Species)
sample_index=sample(nrow(x),10) #抽10個

iris %$%
  svm(Species ~ Sepal.Width) %>% 
  predict(x[sample_index,]) %>%  #列出抽樣預測結果
  polt()

iris %$%
  svm(Species ~ .,data=.) %>% 
  predict(x[sample_index,]) %>%   #列出抽樣預測結果
  plot()


####################
# %T>%  前一個運算結果作為下二個函式第一個參數
####################

iris %$%
  svm(Species ~ .,data=.) %T>%      # Tee
    predict(x[sample_index,]) %>%   #列出抽樣預測結果
    fitted() %>% #列出所有預測結果
    plot()

####################
# %<>% 前一個運算結果作為下一個函式第一個參數且回傳更新左方的物件
####################
myiris <- iris
### 土法練鋼把前四欄加10

myiris[1:4] <- myiris[1:4]+10
myiris

#pipe 的做法

myiris[1:4] %<>% 
  add(10)                         #四個欄位 +10 放回 myiris

