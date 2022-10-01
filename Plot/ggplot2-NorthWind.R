##########################################
#Editor: Kuo-Liang Ou
#Affililation: National Tsing Hua University ILST
#Reference: ggplot2 cheat sheet
##########################################
source("mysql_conn.R") #connect to mysql

nw <-  fetch(myquery_result, n=-1)  #read all the data from result
#setwd("somewhere of your working directory")
#nw <-  read.csv("https://github.com/KuoLiang/r-klou/blob/f6cc7b13890bbedd42d9e5d4a7e684dafa239495/Plot/NWSales.csv")
nw
##########################################
#transform
##########################################
nw$Year = factor(nw$Year)
nw$EmployeeID = factor(nw$EmployeeID)
nw$ShipCountry = factor(nw$ShipCountry)
library(ggplot2)

##########################################
#hints:
#Aesthetic : x y shape, color, size
#Layer : point ; others like geom_line() geom_bar() geom_violin()
#                 geom_boxplot() geom_histogram() geom_path()
# the followings are the practices of geom functions
##########################################
#One Variable - Continuous
c <-  ggplot(data=nw, aes(Sales))
##########################################
c + geom_area(stat="bin")
c + geom_area(stat="bin", binwidth=100)
c + geom_density()
c + geom_dotplot()
c + geom_dotplot(binwidth = 100)
c + geom_histogram()
c + geom_histogram(binwidth = 100)
##########################################
#One Variable - discrete
d <-  ggplot(data=nw, aes(EmployeeID))
d1 <-  ggplot(data=nw, aes(EmployeeID,fill=Year))
##########################################
d + geom_bar() #default y = count
d1 + geom_bar()
d1 + geom_bar(position="stack")
d1 + geom_bar(position="fill")
d1 + geom_bar(position="dodge")+ coord_flip()

##########################################
#Two Variables - Continuous X and Continuous Y
e <- ggplot(data=nw, aes(x=Freight,y=Sales))
e1 <-  ggplot(data=nw, aes(x=Freight,y=Sales,fill=Year,color=Year))
##########################################
e + geom_point()
e + geom_point() + geom_smooth()
e1+ geom_point() + geom_smooth()
e1+ geom_quantile() 

##########################################
#Two Variables - Discrete X and Continuous Y
f <- ggplot(data=nw, aes(x=EmployeeID,y=Sales))
f1 <-  ggplot(data=nw, aes(x=EmployeeID,y=Sales,fill=Year))
f2 <-  ggplot(data=nw, aes(x=ShipCountry,y=Sales))
##########################################
f + geom_point()
f + geom_bar(stat="summary", fun="mean") #default position=stack
f1 + geom_bar(stat="summary", fun="mean",position = "dodge")
f1 + geom_bar(stat="summary", fun="mean",position = "fill") #normalized
f1 + geom_boxplot()
f1 + geom_violin()
f2 + geom_violin()
f2 + geom_violin() + ylim(0,1000)
f2 + geom_violin() + ylim(0,1000) + coord_cartesian(ylim=c(0,500))

##########################################
#Facet
u <- ggplot(data=nw, aes(x=Sales))
##########################################

u + geom_density(aes(fill=EmployeeID),alpha= 0.2)+
  facet_grid(EmployeeID~.)
u + geom_density(aes(fill=EmployeeID),alpha= 0.2)+
  facet_grid(.~Year)
u + geom_density(aes(fill=EmployeeID),alpha= 0.2)+
  facet_grid(EmployeeID~Year)
##########################################

library(dplyr)
f <-  filter(nw, ShipCountry == "France")
f2 <- filter(f,Sales >= 1000, Sales <=1100)
f2
selected = select(iris, Sepal.Length, Sepal.Width, Petal.Length)
newIris = mutate(iris, greater.mean = Sepal.Width > mean(Sepal.Width))
newIris2 = mutate(iris, area = Sepal.Length * Sepal.Width)
myaesc = arrange(newIris, Petal.Length, Petal.Width)
mydesc = arrange(newIris, desc(Petal.Length), Petal.Width)