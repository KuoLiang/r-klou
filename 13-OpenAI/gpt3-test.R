install.packages("devtools")
library(devtools)
devtools::install_github("ben-aaron188/rgpt3")
library(rgpt3)
setwd("/Users/klou/Documents/GitHub/")
gpt3_authenticate("access_key.txt")
a <- gpt3_test_completion()

sample_string = "London is one of the most liveable cities in the world. The city is always full of energy and people"
b <- gpt3_single_embedding(input = sample_string)
b[[1]]$gpt3

c <- gpt3_single_completion(prompt_input = '說個冷笑話吧')
c[[1]]$gpt3

d <- gpt3_single_completion(prompt_input = "寫一封情書"
       , temperature = 0.8, max_tokens = 100)
d[[1]]$gpt3
