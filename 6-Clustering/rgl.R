
#install.packages("rgl")
options(rgl.useNULL = TRUE)
library(rgl)
open3d()
# This is to output a rgl plot in a rmarkdown document.
# setupKnitr()

# Data: the iris data is provided by R
data <- iris

# Add a new column with color
mycolors <- c('royalblue1', 'darkcyan', 'oldlace')
data$color <- mycolors[ as.numeric(data$Species) ]

# Plot
plot3d( 
  x=data$`Sepal.Length`, y=data$`Sepal.Width`, z=data$`Petal.Length`, 
  col = data$color, 
  type = 's', 
  radius = .1,
  xlab="Sepal Length", ylab="Sepal Width", zlab="Petal Length")

# To display in an R Markdown document:
# rglwidget()

# To save to a file:
htmlwidgets::saveWidget(rglwidget(width = 520, height = 520), 
                        file = "3dscatter.html",
                        libdir = "libs",
                        selfcontained = FALSE
)
