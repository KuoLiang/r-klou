packages = c("dplyr", "tidytext", "jiebaR", "gutenbergr", "stringr", "wordcloud2", "ggplot2", "tidyr", "scales")
existing = as.character(installed.packages()[,1])
for(pkg in packages[!(packages %in% existing)]) install.packages(pkg)

install.packages("tidytext")
library(tidytext)
library(janeaustenr)
library(dplyr)
library(stringr)
bridge_home_book <- read
original_books <- bridge_home_book %>%
    group_by(book) %>%
    mutate(linenumber = row_number(),
           chapter = cumsum(str_detect(text, regex("^chapter [\\divxlc]",
                                                   ignore_case = TRUE)))) %>%
    ungroup()

original_books

#=========
text <- c("床前明月光，",
          "疑是地上霜。",
          "举头望明月，",
          "低头思故乡。")
text
library(tidytext)
tidy_books <- original_books %>%
    unnest_tokens(word, text)
tidy_books