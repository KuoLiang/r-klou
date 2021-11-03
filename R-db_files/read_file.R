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
