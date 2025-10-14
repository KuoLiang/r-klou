#tidyvese package includes:
#ggplot2, 資料視覺化 
#dplyr 數據處理 
#tidyr 資料清理 
#readr 資料讀取 
#purrr 函式化程式設計 
#tibble 資料型別定義 
if (!require("dplyr")) install.packages("dplyr")
library(dplyr)

data(iris)
typeof(iris)
class(iris)
virginica = filter(iris, Species == "virginica")
selected = select(iris, Sepal.Length, Sepal.Width, Petal.Length)
newIris = mutate(iris, greater.mean = Sepal.Width > mean(Sepal.Width))
newIris2 = mutate(iris, area = Sepal.Length * Sepal.Width)
myaesc = arrange(newIris, Petal.Length, Petal.Width)        #asc
mydesc = arrange(newIris, desc(Petal.Length), Petal.Width) #desc

######
sample_n(iris, 3)
# Printing 50 % of the rows
sample_frac(iris, 0.50)

summarise(iris, mymean = mean(Sepal.Length))
                 