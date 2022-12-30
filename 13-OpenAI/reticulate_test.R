#https://gist.github.com/jlomako

library(reticulate)
# create python env
conda_create(envname = "gpt3", packages = "openai", python_version = "3.10")
use_condaenv("gpt3")

# import openai
openai <- import("openai")

# read api key from file
openai$api_key <- scan("access_key.txt", what="character", sep=NULL)

myprompt="寫一封情書"
# set parameters
response <- openai$Completion$create(
  model = "text-davinci-003", # 
  prompt = myprompt,
  temperature = 0.9, # randomness, the higher the weirder
  max_tokens = 100L, # needs integer
  top_p=1,
  frequency_penalty=0,
  presence_penalty=0
)

# get response
cat(response$choices[[1]]$text)
