library("ggplot2")
mycars = mtcars

result = lm(hp ~ cyl, data=mycars)
summary(result)
result2 = lm(hp ~ cyl + disp, data=mycars)
summary(result2)

result3 = lm(hp ~ disp+carb, data=mycars)
summary(result3)

result_all = lm(hp ~ ., data=mycars)  #所有
summary(result_all)   #


#######

cars
ggplot(cars, aes(x = speed, y = dist)) + geom_point(shape = 10, size = 5) + 
    geom_smooth(method = lm) + labs(x = "速度", y = "煞車距離") 
result4 <- lm(dist ~ speed, data = cars) 
summary(result4)
newcar <- data.frame(speed = 10) 
result5 <- predict(result4, newdata = newcar) 
result5 

