library(devtools)
#devtools::install_github("ben-aaron188/rgpt3")
library(rgpt3)

# get response
#cat(response$choices[[1]]$text)
#* Echo back the input
#* @param msg The message to echo
#* @get /echo
function(msg="") {
  setwd("/Users/klou/Documents/GitHub/")
  gpt3_authenticate("access_key.txt")
  c <- gpt3_single_completion(prompt_input = msg)
  c[[1]]$gpt3
  list(msg = paste0("我說：", c[[1]]$gpt3, "'"))
}

#* Plot a histogram
#* @serializer png
#* @get /plot
function() {
  rand <- rnorm(100)
  hist(rand)
}

#* Return the sum of two numbers
#* @param a The first number to add
#* @param b The second number to add
#* @post /sum
function(a, b) {
  as.numeric(a) + as.numeric(b)
}