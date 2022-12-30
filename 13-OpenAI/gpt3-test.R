install.packages("devtools")
library(devtools)
devtools::install_github("ben-aaron188/rgpt3")
library(rgpt3)
setwd("/Volumes/8T/GitHub/r-klou/13-OpenAI/")
gpt3_authenticate("access_key.txt")
gpt3_test_completion()

###
my_prompts = data.frame('prompts' = 
                          c('Complete this sentence: universities are'
                            , 'Write a poem about music:'
                            , 'Which colour is better and why? Red or blue?')
                        ,'prompt_id' = c(LETTERS[1:3]))

example_2 = gpt3_completions(prompt_var = my_prompts$prompts
                             , id_var = my_prompts$prompt_id
                             , param_model = 'text-curie-001'
                             , param_max_tokens = 100
                             , param_n = 5
                             , param_temperature = 0.4)
