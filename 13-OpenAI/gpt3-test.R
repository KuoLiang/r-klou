install.packages("devtools")
library(devtools)
devtools::install_github("ben-aaron188/rgpt3")
library(rgpt3)
setwd("/Volumes/8T/GitHub/r-klou/13-OpenAI/")
gpt3_authenticate("access_key.txt")
gpt3_test_completion()

sample_string = "London is one of the most liveable cities in the world. The city is always full of energy and people" 
gpt3_single_embedding(input = sample_string)

gpt3_single_embedding(input = sample_string
                      , model = 'text-similarity-curie-001')

gpt3_single_completion(prompt_input = 'How old are you?')

gpt3_single_completion(prompt_input = "Write a research idea about using text data to understand human behaviou"
       , temperature = 0.8
       , n = 10
       , max_tokens = 150)
