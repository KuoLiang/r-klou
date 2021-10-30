# Installing the package
install.packages("ggplot2")
install.packages("dplyr")
# Loading packages
library(ggplot2)
library(dplyr)
mtcars            #show out the data
mycars=mtcars
?mtcars           #the description

# Aesthetic Layer

ggplot(data = mtcars, aes(x = hp, y = mpg, col = disp))
ggplot(data = mtcars, aes(x = cyl, y = wt, col = am))

# Geometric layer
ggplot(data = mtcars,
       aes(x = hp, y = mpg, col = disp)) + 
    geom_point()
ggplot(data = mtcars,
       aes(x = cyl, y = wt, col = am)) +
      geom_point()

# Adding size
ggplot(data = mtcars,
       aes(x = hp, y = mpg, size = disp)) + geom_point()

# Adding color and shape
ggplot(data = mtcars,
       aes(x = hp, y = mpg, col = factor(cyl),
           shape = factor(am))) + geom_point()

# Histogram plot
ggplot(data = mtcars, aes(x = hp)) +
  geom_histogram(binwidth = 5)

# Facet Layer
p <- ggplot(data = mtcars,
            aes(x = hp, y = mpg,
                shape = factor(cyl))) + geom_point()

# Separate rows according to transmission type
p + facet_grid(am ~ .)

# Separate columns according to cylinders
p + facet_grid(. ~ cyl)

# Statistics layer
ggplot(data = mtcars, aes(x = hp, y = mpg)) +
  geom_point() +
  stat_smooth(method = lm, col = "red")

# Coordinates layer: Control plot dimensions
ggplot(data = mtcars, aes(x = wt, y = mpg)) +
  geom_point() +
  stat_smooth(method = lm, col = "red") +
  scale_y_continuous("mpg", limits = c(2, 35),
                     expand = c(0, 0)) +
  scale_x_continuous("wt", limits = c(0, 25),
                     expand = c(0, 0)) + coord_equal()

# Add coord_cartesian() to proper zoom in
ggplot(data = mtcars, aes(x = wt, y = hp, col = am)) +
  geom_point() + geom_smooth() +
  coord_cartesian(xlim = c(3, 6))

# Theme layer
ggplot(data = mtcars, aes(x = hp, y = mpg)) +
  geom_point() + facet_grid(. ~ cyl) +
  theme(plot.background = element_rect(
    fill = "black", colour = "gray"))

ggplot(data = mtcars, aes(x = hp, y = mpg)) +
  geom_point() + facet_grid(am ~ cyl) +
  theme_gray()

