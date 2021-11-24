data(iris)
attach(iris) #search path

## classification mode
# default with factor response: 標準寫法
model <- svm(Species ~ ., data = iris)

# alternatively the traditional interface: f(x)=y ；y為依變數；x為自變數
x <- subset(iris, select = -Species)
y <- Species
model <- svm(x, y)  #同上的另一種寫法

print(model)
summary(model)

# test with train data
pred <- predict(model, x)  #列出預測
# (same as:)
pred <- fitted(model) #同上的功能

# Check accuracy:
table(pred, y)  #列，欄

# compute decision values and probabilities:
pred <- predict(model, x, decision.values = TRUE) #列出機率
attr(pred, "decision.values")[1:4,]  #return a dataframe
attr(pred, "decision.values")  #all attributes

install.packages("mlbench")
require("mlbench")
tune.model = tune(svm,
                  Species~.,
                  data=iris,
                  kernel="radial", # RBF kernel function
                  range=list(cost=10^(-1:2), gamma=c(.5,1,2))# 調參數的最主要一行
)
plot(tune.model)
summary(tune.model)
# visualize (classes by color, SV by crosses):
plot(cmdscale(dist(iris[,-5])),
     col = as.integer(iris[,5]),
     pch = c("o","+")[1:150 %in% model$index + 1])

## try regression mode on two dimensions

# create data
x <- seq(0.1, 5, by = 0.05)
y <- log(x) + rnorm(x, sd = 0.2)

# estimate model and predict input values
m   <- svm(x, y)
new <- predict(m, x)

# visualize
plot(x, y)
points(x, log(x), col = 2)
points(x, new, col = 4)

## density-estimation

# create 2-dim. normal with rho=0:
X <- data.frame(a = rnorm(1000), b = rnorm(1000))
attach(X)

# traditional way:
m <- svm(X, gamma = 0.1)

# formula interface:
m <- svm(~., data = X, gamma = 0.1)
# or:
m <- svm(~ a + b, gamma = 0.1)

# test:
newdata <- data.frame(a = c(0, 4), b = c(0, 4))
predict (m, newdata)

# visualize:
plot(X, col = 1:1000 %in% m$index + 1, xlim = c(-5,5), ylim=c(-5,5))
points(newdata, pch = "+", col = 2, cex = 5)

## weights: (example not particularly sensible)
i2 <- iris
levels(i2$Species)[3] <- "versicolor"
summary(i2$Species)
wts <- 100 / table(i2$Species)
wts
m <- svm(Species ~ ., data = i2, class.weights = wts)

## extract coefficients for linear kernel

# a. regression
x <- 1:100
y <- x + rnorm(100)
m <- svm(y ~ x, scale = FALSE, kernel = "linear")
coef(m)
plot(y ~ x)
abline(m, col = "red")

# b. classification
# transform iris data to binary problem, and scale data
setosa <- as.factor(iris$Species == "setosa")
iris2 = scale(iris[,-5])

# fit binary C-classification model
m <- svm(setosa ~ Petal.Width + Petal.Length,
         data = iris2, kernel = "linear")

# plot data and separating hyperplane
plot(Petal.Length ~ Petal.Width, data = iris2, col = setosa)
(cf <- coef(m))
abline(-cf[1]/cf[3], -cf[2]/cf[3], col = "red")

# plot margin and mark support vectors
abline(-(cf[1] + 1)/cf[3], -cf[2]/cf[3], col = "blue")
abline(-(cf[1] - 1)/cf[3], -cf[2]/cf[3], col = "blue")
points(m$SV, pch = 5, cex = 2)