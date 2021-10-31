#for Chinese Version
if (!require(devtools))  install.packages("devtools")
devtools::install_github('lchiffon/wordcloud2')

#for English Verstion Only
#install.packages("wordcloud2")

library(wordcloud2)
###########################################3
wordcloud2(data = demoFreq)

mydemoFreq = demoFreq
mydemoFreqC = demoFreqC

wordcloud2(mydemoFreq, size = 2, 
           color = "random-light", 
           backgroundColor = "grey")

wordcloud2(mydemoFreqC, size = 2, fontFamily = "標楷體",
           color = "random-light", backgroundColor = "black"
           )

mycolor = rep_len( c("red","green","blue"), nrow(demoFreq))

colorlist = mycolor 

mydemoFreqC = cbind(demoFreqC, colorlist)

wordcloud2(demoFreqC, size = 1, 
           #color = c("#FF0000" ,"#00FF00" ,"#0000FF") ,
           #color = mydemoFreqC$colorlist,
           shape = 'diamond', #circle’ (default), ‘cardioid’ (apple or heart shape curve, the most known polar equation), ‘diamond’ (alias of square), ‘triangle-forward’, ‘triangle’, ‘pentagon’, and ‘star’. 
           #figPath = "~/Desktop/t.png", #English only
           backgroundColor = "white")

letterCloud(demoFreq, #English only
            color = 'random-light',
            word = "R",
            backgroundColor = "white")

demoFreq
demoFreqC
mydemoFreqC

