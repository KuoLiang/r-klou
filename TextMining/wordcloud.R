install.packages("wordcloud2")
library(wordcloud2)
wordcloud2(data = demoFreq)

mycolor = c(seq(0:800))
mydemoFreqC = demoFreqC

mydemoFreqC = cbind(demoFreqC, colorlist = mycolor)

wordcloud2(demoFreq, size = 2, fontFamily = "微軟雅黑", color = "random-light", backgroundColor = "grey")

wordcloud2(demoFreq, size = 2, color = "random-light", backgroundColor = "grey")
wordcloud2(demoFreqC, size = 2, 
           color = mydemoFreqC$colorlist, 
           backgroundColor = "black",)

demoFreq
demoFreqC
mydemoFreqC
