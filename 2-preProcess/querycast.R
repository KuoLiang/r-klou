#install required packages
if (!require("RMySQL")) install.packages("RMySQL")
library(RMySQL)
if (!require("reshape2")) install.packages("reshape2")
library(reshape2)

################
#make a connection to Mysql
#please change user to "root"
#password left to space
#host to "localhost"
################
#the query dcast function 把查詢結果單一欄位資料轉成多欄位資料
#melt 則是把查詢結果多欄位資料轉成單一欄位
#formula 
#valur.var 要轉換值的欄名
################
query_cast = function(query_result){
  query_df=fetch(query_result, n = -1)
  mycast=dcast(query_df,
               firstname~Month,
               fun.aggregate = sum,
               value.var = "num",
               fill = NA_real_)
}
################
mysqlconnection = dbConnect(MySQL(), user = 'student', password = '673cqdJ2s@t9Y@uc', 
                            dbname = 'northwind' ,host = '10.8.0.1')
dbListTables(mysqlconnection)

#the query dcast function 把查詢結果單一欄位資料轉成多欄位資料
#melt 則是把查詢結果多欄位資料轉成單一欄位
#formula 
#valur.var 要轉換值的欄名
################
my_query = function(query_result){
  query_df=fetch(query_result, n = -1)  #n presents the num of data will be fetched
  #n = -1 means retrieve all data
  #you can try to run : fetch(quantity) after finishing the SQL command
}
