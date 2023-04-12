
#install.packages("rgl")
options(rgl.useNULL = TRUE)
library(rgl)
open3d()
# This is to output a rgl plot in a rmarkdown document.
# setupKnitr()

# Data: the iris data is provided by R
#data <- iris
#data <- data
# Add a new column with color
mycolors <- c('royalblue1', 'darkcyan', 'oldlace','purple','red','yellow')
#data$color <- mycolors[ as.numeric(data$Species) ]
data$color <- mycolors[ as.numeric(data$cluster) ]

# Plot
#plot3d( 
#  x=data$`Sepal.Length`, y=data$`Sepal.Width`, z=data$`Petal.Length`, 
#  col = data$color, 
#  type = 's', 
#  radius = .1,
#  xlab="Sepal Length", ylab="Sepal Width", zlab="Petal Length")

plot3d( 
  x=data$`grade_point`, y=data$`paytime`, z=data$`fail_rate`, 
  col = data$color, 
  type = 's', 
  radius = .01,
  xlab="平均成積", ylab="付出時間", zlab="不及格率")
rglwidget()
htmlwidgets::saveWidget(rglwidget(width = 800, height = 800), 
                        file = "gpf.html",
                        libdir = "libs",
                        selfcontained = FALSE
)

plot3d( 
  x=data$`grade_point`, y=data$`a_ratio`, z=data$`fail_rate`, 
  col = data$color, 
  type = 's', 
  radius = .01,
  xlab="平均成積", ylab="認真度", zlab="不及格率")
rglwidget()
htmlwidgets::saveWidget(rglwidget(width = 800, height = 800), 
                        file = "gaf.html",
                        libdir = "libs",
                        selfcontained = FALSE
)

plot3d( 
  x=data$`grade_point`, y=data$`paytime`, z=data$`a_ratio`, 
  col = data$color, 
  type = 's', 
  radius = .01,
  xlab="平均成積", ylab="付出時間", zlab="認真度")
rglwidget()
htmlwidgets::saveWidget(rglwidget(width = 1024, height = 968), 
                        file = "gpa.html",
                        libdir = "libs",
                        selfcontained = FALSE
)

plot3d_( 
  x=data$`fail_rate`, y=data$`paytime`, z=data$`a_ratio`, 
  col = data$color, 
  type = 's', 
  radius = .01,
  xlab="不及格率", ylab="付出時間", zlab="認真度")
rglwidget()
htmlwidgets::saveWidget(rglwidget(width = 1024, height = 968), 
                        file = "fpa.html",
                        libdir = "libs",
                        selfcontained = FALSE
)

# To display in an R Markdown document:
rglwidget()

# To save to a file:
htmlwidgets::saveWidget(rglwidget(width = 1024, height = 968), 
                        file = "3dscatter.html",
                        libdir = "libs",
                        selfcontained = FALSE
)
