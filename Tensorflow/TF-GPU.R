install.packages('devtools')
library(devtools)

devtools::install_github("rstudio/tensorflow") 
devtools::install_github("rstudio/keras") 

require(tensorflow)
sess = tf$Session()
hello <- tf$constant('Hello, TensorFlow!')
sess$run(hello)

#####################################
install_tensorflow(version = "gpu")

#for MacOS
install_tensorflow(version = "1.1-gpu")

library(keras)
