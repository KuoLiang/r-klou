library(devtools)
devtools::install_github("ben-aaron188/rgpt3")
library(rgpt3)
setwd("/Users/klou/Documents/GitHub/")
gpt3_authenticate("access_key.txt")
c <- gpt3_single_completion(prompt_input = '說個冷笑話吧')
c[[1]]$gpt3


# get response
#cat(response$choices[[1]]$text)
#* Echo back the input
#* @param msg The message to echo
#* @get /echo
function(msg="") {
  list(msg = paste0("The message is: '", c[[1]]$gpt3, "'"))
}