if (!require(devtools))  install.packages("devtools")
devtools::install_github('lchiffon/wordcloud2')
#install.packages("wordcloud2")
library(wordcloud2)

wordcloud2(data = demoFreq)

mydemoFreq = demoFreq
mydemoFreqC = demoFreqC

wordcloud2(mydemoFreq, size = 2, 
           color = "random-light", 
           backgroundColor = "grey")
wordcloud2(mydemoFreqC, size = 2, fontFamily = "微軟雅黑",
           color = "random-light", backgroundColor = "black")

mycolor = c(rgb(0,0,(884:0)/885))
#mycolor = c(gray(seq(0,1,length.out = 885)))

colorlist = mycolor 
mydemoFreqC = cbind(demoFreqC, colorlist)
wordcloud2(mydemoFreqC, size = 2, 
           color = mydemoFreqC$colorlist, 
           backgroundColor = "white",)

demoFreq
demoFreqC
mydemoFreqC


csphd <- function(colors)
  barplot(csd, col = colors, ylim = c(0,30),
          names.arg = 72:85, xlab = "Year", ylab = "Students",
          legend.text = c("Winter", "Spring", "Summer", "Fall"),
          main = "Computer Science PhD Graduates", las = 1)
