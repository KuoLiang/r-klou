library(ggplot2)
iris
####################
#Aesthetic
####################

ggplot(iris, aes(x=Sepal.Width, y=Sepal.Length)) +
  geom_point()
#Data : iris
#Aesthetic : x y shape, color, size
#Layer : point ; others like geom_line() geom_bar() geom_violin()
#                 geom_boxplot() geom_histogram() geom_path()

ggplot(iris, aes(x=Sepal.Width, y=Sepal.Length,
                 shape = Species, color=Species)) +
  geom_point()
#########
ggplot(iris, aes(x=Sepal.Width, y=Sepal.Length,
                  color=Species)) +
  geom_violin()
#########
ggplot(iris, aes(x=Species, y=Sepal.Length,
                  color=Species)) +
  geom_violin()
#########
ggplot(iris, aes(x=Sepal.Width, y=Sepal.Length,
                 shape = Species, color=Species)) +
  geom_point(alpha = 0.5)+geom_smooth()+
  xlab("寛")+ylab("長")+
  theme(text = element_text(family = "Heiti TC Light")) # mac 中文
#########
ggplot(iris, aes(x=Sepal.Width, y=Sepal.Length,
                 shape = Species, color=Species)) +
  geom_point()+geom_smooth(method = "lm")   #linear model
#########
ggplot(iris, aes(x=Sepal.Width, y=Sepal.Length,
                 shape = Species, color=Species)) +   #雖然指定不同品種有不同的顏色
  geom_point(color="red")   #但現在只有紅色點了

####################

ggplot(iris, aes(x=Sepal.Width, y=Sepal.Length)) +
  geom_line()

ggplot(iris, aes(x=Sepal.Width,color=Species)) +
  geom_bar(stat = "count")

ggplot(iris, aes(x=Sepal.Width, y=Sepal.Length)) +
  geom_boxplot()

ggplot(iris, aes(Sepal.Width)) +
  geom_histogram(bins = 20)   #分成20個刻度

####################
#Faceting
####################

ggplot(iris, aes(x=Sepal.Width, y=Sepal.Length,
                 shape = Species, color=Species)) + 
  geom_point()+
  facet_wrap(~Species)  #不同品種不同頁面

ggplot(iris, aes(x=Sepal.Width, y=Sepal.Length,
                 shape = Species, color=Species)) +
  geom_point()+geom_smooth()

