library(plumber)
setwd("/Users/klou/Documents/GitHub/r-klou/14-deployment/")
a <- plumb("myopenai.R")
a$run(port=8000)

