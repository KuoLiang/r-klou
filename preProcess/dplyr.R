library(dplyr)
data(iris)
virginica = filter(iris, Species == "virginica")
selected = select(iris, Sepal.Length, Sepal.Width, Petal.Length)
newIris = mutate(iris, greater.mean = Sepal.Width > mean(Sepal.Width))
newIris2 = mutate(iris, area = Sepal.Length * Sepal.Width)
myaesc = arrange(newIris, Petal.Length, Petal.Width)
mydesc = arrange(newIris, desc(Petal.Length), Petal.Width)

######
sample_n(iris, 3)
# Printing 50 % of the rows
sample_frac(iris, 0.50)

summarise(iris, mymean = mean(Sepal.Length))
                 