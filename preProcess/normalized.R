install.packages('MASS')
library(MASS)
iris_data = iris[1:4]
iris_maxs = apply(iris_data,2,max) #2 表示各欄最大值
iris_maxs
iris_mins = apply(iris_data,1,min) #1 表示各列最小值
iris_mins
iris_mins = apply(iris_data,2,min) #2 表示各欄最小值
iris_mins
iris_means = apply(iris_data,2,mean) #2 表示各欄均值
iris_means
###
iris_scaled = scale(iris_data,center=iris_mins,
                    scale=iris_maxs-iris_mins)
iris_scaled #a normalized matirx 0 to 1 因為以 min為參考點
#
iris_scaled = scale(iris_data,center=iris_maxs,
                    scale=iris_maxs-iris_mins)
iris_scaled #a normalized matirx 0 to -1因為以 max為參考點
#
iris_scaled = scale(iris_data,center=iris_mean,
                    scale=iris_maxs-iris_mins)
iris_scaled #a normalized matirx -0.5 to 0.5因為以 mean為參考點
iris_scaled = as.data.frame(iris_scaled)
######