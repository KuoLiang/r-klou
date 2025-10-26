#subset function
#subset(dataframe, select...)
library(datasets)
str(iris)
a <- iris
b <- subset(iris, Species == "versicolor")
c <- subset(iris, 
            Species == "versicolor" |          #OR operator
            Species == "setosa"  )[,c(1,3,5)]  #tell me what's that?

#tidyvese package includes:
#ggplot2, 資料視覺化 it's very helpful in data visualization
#dplyr 數據處理 , like SQL 
  # filter()	篩選
  # select()	選擇變數
  # mutate()	新增衍生變數
  # arrange()	排序
  # summarise()	聚合變數
  # group_by()	分組，常搭配 summarise() 
#tidyr 資料清理 
#readr 資料讀取 
#purrr 函式化程式設計 
#tibble 資料型別定義 
#for more info https://tidyverse.org/packages/
####
#install.packages("tidyverse") #安裝大全套
#或指定個別套件安裝即可
if (!require("dplyr")) install.packages("dplyr")
library(dplyr)
####
data(iris)
  typeof(iris)
  class(iris)

#?filter()            #see the help
#?dplyr::filter()     #specific package name  
virginica = filter(iris, Species == "virginica")  

#?select()            #like the SELECT clause of SQL
selected = select(iris, Sepal.Length, Sepal.Width, Petal.Length)

#?mutate()            #like the WHERE clause of SQL, however, it will create a new attribute
newIris1 = mutate(iris, greater.mean = Sepal.Width > mean(Sepal.Width))
    #Sepal.Width > mean(Sepal.Width) return T or F to the new attribute: greater.mean
newIris2 = mutate(iris, area = Sepal.Length * Sepal.Width)
    # Sepal.Length * Sepal.Width return the values to the new attribute: area


#?arrange()           #like the ORDER BY clause of SQL
myaesc = arrange(newIris1, Petal.Length, Petal.Width)        #asc
mydesc = arrange(newIris2, desc(Petal.Length), Petal.Width) #desc



######
#Other usefule operations
######
# Printing the top 3 rows
sample_n(iris, 3)
# Printing 50 % of the rows
sample_frac(iris, 0.50)

summary(iris)     #NOTE: it's not the dplyr function
summarise(iris)   #provided to dplyr
summarise(iris, mymean = mean(Sepal.Length))
 
#?group_by()          #like the GROUP BY clause of SQL
group_by(newIris1, greater.mean)
group_by(newIris1, Species)

# %>% : the pipe line 
#Windows/Linux: Ctrl + Shift + M
#Mac: Cmd + Shift + M

iris %>% 
  group_by(Species) %>% 
  summarise(mymean = mean(Sepal.Length)) 

iris %>% 
  group_by(Species) %>% 
  summarise(mycount = n()) 

newIris1 %>% 
  group_by(greater.mean) %>% 
  summarise(mycount = n())

#產生流水號
iris2 <- iris %>%
  mutate(id = row_number())
irisr <- mutate(iris,id=row_number())     #the same as above
iris2 # make a col of id