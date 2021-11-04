# Read in csv files
mydf = read.table("https://s3.amazonaws.com/assets.datacamp.com/blog_assets/test.csv", 
                 header = FALSE,
                 sep = ",")
mydf
mydf = read.csv("https://s3.amazonaws.com/assets.datacamp.com/blog_assets/test.csv",
               header = FALSE)
mydf
mydf = read.csv2("https://s3.amazonaws.com/assets.datacamp.com/blog_assets/test.csv", 
                header= FALSE)
mydf

# Read a delimited file
mydf = read.delim("https://s3.amazonaws.com/assets.datacamp.com/blog_assets/test_delim.txt", sep="$") 
mydf = read.delim2("https://s3.amazonaws.com/assets.datacamp.com/blog_assets/test_delim.txt", sep="$")

###############3


library(jsonlite)
jsdf = fromJSON("~/Desktop/a.json", flatten=TRUE)
jsdf
jsdf2 = fromJSON("~/Desktop/b.json", flatten=TRUE)
jsdf2
jsdf3 = fromJSON("~/Desktop/c.json", flatten=TRUE)
a=jsdf3             #回傳結果為dataframe
b=jsdf3[7]          #回傳結果為dataframe
c=jsdf3[[7]]        #取第七欄位，回傳結果為list
c
head(c)
c[[1]]                    #取第七欄第一個值,回傳結果為dataframe
c[[1]]$elementValue.value #取第七欄第一個值,再利用dataframe取第二欄，回傳結果為vector
c[[1]][1,2]               #取第七欄第一個值,再利用dataframe取第一列第二欄，回傳結果為value
c[[1]]$elementValue.value[1] #取第七欄第一個值,再利用dataframe取第一列第二欄，回傳結果為value

d=jsdf3[[7]][[1]]       #取第七欄第一個值,回傳結果為dataframe
e=jsdf3[[7]][[1]][1,2]  #取第七欄第一個值,再利用dataframe取第一列第二欄，回傳結果為value
e
temp=jsdf3[[7]][[1]][4,2]  #取一個溫度
for(i in 1:10) {
  temp[i]=jsdf3[[7]][[i]][4,2]  #取十個溫度
}
temp
for(i in 1:length(jsdf3$lat)) {
  temp[i]=jsdf3[[7]][[i]][4,2]  #取所有溫度
}
temp

for(i in 1:length(jsdf3$lat)) {
  temp[i]=jsdf3[[7]][[i]][4,2]  #取所有溫度
}

humd=jsdf3[[7]][[1]][5,2]  #取一個濕度
for(i in 1:length(jsdf3$lat)) {
  humd[i]=jsdf3[[7]][[i]][5,2]  #取所有濕度
}
result = cbind(temp,humd) #合併
####一個迴圈處理兩個 vector
result2=data.frame(temp,humd)
for(i in 1:length(jsdf3$lat)) {      #429個節點
  result2[i,1]=jsdf3[[7]][[i]][4,2]  #取所有溫度
  result2[i,2]=jsdf3[[7]][[i]][5,2]  #取所有濕度
}

#################雙迴圈一次讀六個
result3=matrix(NA, nrow = length(jsdf3$lat), ncol = 6)
result3=as.data.frame(result3)
for(i in 1:length(jsdf3$lat)) {
  for(j in 1:6){
  result3[i,j]=jsdf3[[7]][[i]][j,2]  #
  }
}

#####
library(Matrix)
library(plyr)
f=ldply(c)
f
