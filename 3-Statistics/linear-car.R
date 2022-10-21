mycars = mtcars
result = lm(hp ~ cyl, data=mycars)
summary(result)
result2 = lm(hp ~ cyl + disp, data=mycars)
summary(result2)

result3 = lm(hp ~ disp+carb, data=mycars)
summary(result3)

result_all = lm(hp ~ ., data=mycars)  #所有
summary(result_all)   #


