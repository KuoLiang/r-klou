packages = c("dplyr", "tidytext", "jiebaR", "gutenbergr", "stringr", "wordcloud2", "ggplot2", "tidyr", "scales")
existing = as.character(installed.packages()[,1])
for(pkg in packages[!(packages %in% existing)]) install.packages(pkg)

library(tidytext)
library(janeaustenr)
library(dplyr)
library(stringr)

original_books <- austen_books() %>%
    group_by(book) %>%
    mutate(linenumber = row_number(),
           chapter = cumsum(str_detect(text, regex("^chapter [\\divxlc]",
                                                   ignore_case = TRUE)))) %>%
    ungroup()

original_books

#=========
text <- c("床前明月光，",
          "疑是地上霜。",
          "舉頭望明月，",
          "低頭思故鄉。")
text
text <- c("I","You","She")
library(tidytext)
tidy_books <- original_books %>%
    unnest_tokens(word, text) #Split a column into tokens
tidy_books
