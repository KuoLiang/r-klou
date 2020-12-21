library(ggplot2)
#mydata = read.csv(file.choose())
data(diamonds)
mydiamonds = data.frame(diamonds)
summary(mydiamonds)
ggplot(data=diamonds,
       aes(x=carat,y=price,color=clarity))+
  geom_point(alpha=0.1)+
  geom_smooth()
