install.packages('devtools')
library(devtools)
devtools::install_github("rstudio/tensorflow") 
devtools::install_github("rstudio/keras") 
# Test Tensorflow: Say hello
library(tensorflow)
sess = tf$Session()
hello <- tf$constant('Hello, TensorFlow!')
sess$run(hello)
#######
# Test Keras: Define a simple DNN network
require(keras)
model <- keras_model_sequential() 
model %>% 
    layer_dense(units = 256, activation = "relu", input_shape = c(784)) %>% 
    layer_dropout(rate = 0.4) %>% 
    layer_dense(units = 128, activation = "relu") %>%
    layer_dropout(rate = 0.3) %>%
    layer_dense(units = 10, activation = "softmax")

summary(model)