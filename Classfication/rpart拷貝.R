library(rpart)
library(C50)
data("iris")
iris
num=ceiling(0.1*nrow(iris))
num

testindex=sample(1:nrow(iris),num)
testdata=iris[testindex,]
traindata=iris[-testindex,]

mytree=rpart(Species ~ Sepal.Length + Sepal.Width + Petal.Length + Petal.Width, method="class", data=iris.traidata)
mytree=rpart(Species ~., data=traidata)
ctree=C5.0(Species ~., data=traindata)



plot(mytree)
text(mytree)

predict(mytree,testdata)

===

formula形式如下：Y~X1+X2+……+Xk （~左邊為響應變量，右邊為各個預測變量，預測變量之間用+符號分隔）

~	分隔符號，左邊為響應變量，右邊為解釋變量，eg：要通過x、z和w預測y，代碼為y~x+z+w
+	分隔預測變量
