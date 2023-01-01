library(plumber)
setwd("/Users/klou/Documents/GitHub/r-klou/14-deployment/")
a <- plumb("myopenapi.R")
a$run(port=8000)

