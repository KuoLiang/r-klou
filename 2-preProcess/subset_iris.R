library(datasets)
str(iris)
a <- iris
b <- subset(iris, Species == "versicolor")
c <- subset(iris, 
            Species == "versicolor" |
            Species == "setosa"  )[,c(1,3,5)]
