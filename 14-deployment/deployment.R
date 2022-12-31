library(plumber)
setwd("/Users/klou/Documents/GitHub/r-klou/14-deployment/")
a <- plumb("myfunction.R")
a$run(port=8000)

pr("myfunction.R") %>%
  pr_run(port=8000)

pr("myopenai.R") %>%
  pr_run(port=8000)
