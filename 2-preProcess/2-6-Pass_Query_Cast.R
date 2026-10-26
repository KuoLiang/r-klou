# ============================================================
# 2-6 引用外部程式檔，把 SQL 查詢結果轉成交叉表
# ============================================================
# 這個範例教你：
#   1. 用 source() 載入另一個 .R 檔中寫好的函數，讓主程式更簡潔
#   2. 對同一個 SQL 查詢，取得兩種結果：
#      my_query()   → 長格式資料框（firstname、Month、num 三欄）
#      query_cast() → 寬格式交叉表（每位員工一列，每個月份一欄）
#   3. 查詢結束後用 dbClearResult() 清除結果
#
# ⚠️ 執行前提：
#   - 需要 querycast.R 這個檔案，但它目前不在這個資料夾，也不在 r-klou 專案的其他地方。
#     以下對 my_query()、query_cast() 的說明，是依照函數名稱和用法推測的。
#   - 需要先建立資料庫連線 mysqlconnection（見 2-4 範例），可能已寫在 querycast.R 裡。
#   因此這個範例沒有附實際輸出結果。
# ============================================================

setwd("/Users/klou/Documents/GitHub/r-klou/2-preProcess") #change the working dir to yours
#  設定工作目錄。這是老師電腦上的路徑，同學要改成自己電腦上的資料夾路徑
#  Windows 的路徑要寫成 "C:/Users/..."（用正斜線 /）或 "C:\\Users\\..."
source("querycast.R") #引用外部獨立程式碼
#  source()：執行另一個 .R 檔的所有程式碼
#  執行後，那個檔案裡定義的函數（my_query、query_cast）就能在這裡使用
#  好處：常用的函數寫一次就好，多個程式都能共用

# ------------------------------------------------------------
# 第一部分：平均訂購數量
# ------------------------------------------------------------
################################################
# query db
################################################
SQL_String <- "SELECT e.firstname, month(o.OrderDate) as Month, avg(quantity) as num 
from `order_details` as od, orders as o,employees as e 
where od.orderid = o.orderid AND o.employeeid = e.employeeid 
group by e.firstname,Month order by e.firstname,Month"
#  每位員工、每個月份的平均訂購數量（SQL 說明請見 2-4 範例）

quantity = dbSendQuery(mysqlconnection, SQL_String)
#  送出查詢，結果存在 quantity
quan_df=my_query(quantity)
#  推測：my_query() 把查詢結果抓回 R，變成長格式資料框
quan_df
#  預期是長格式：每列是「某員工 + 某月份 + 平均數量」

quantity = dbSendQuery(mysqlconnection, SQL_String)
#  同一個查詢再送一次。查詢結果抓過一次就讀完了，要再用必須重新送出
quan_mat=query_cast(quantity)
#  推測：query_cast() 抓回資料後，再用 dcast(firstname ~ Month) 轉成寬格式
quan_mat
#  預期是寬格式：每位員工一列，月份 1~12 各一欄

dbClearResult(quantity)
#  清除查詢結果，釋放資料庫資源，避免下一次查詢出現警告


# ------------------------------------------------------------
# 第二部分：平均單價（結構和第一部分相同）
# ------------------------------------------------------------
SQL_String <-"SELECT e.firstname, month(o.OrderDate) as Month, avg(unitprice) as num
from `order_details` as od, orders as o,employees as e
where od.orderid = o.orderid AND
o.employeeid = e.employeeid
group by e.firstname,Month
order by e.firstname,Month"

unitprice = dbSendQuery(mysqlconnection, SQL_String)
unpr_df=my_query(unitprice)
unpr_df

unitprice = dbSendQuery(mysqlconnection, SQL_String)
unpr_mat=query_cast(unitprice)
unpr_mat

dbClearResult(unitprice)


# ------------------------------------------------------------
# 第三部分：平均運費（結構和第一部分相同）
# ------------------------------------------------------------
SQL_String <- "SELECT e.firstname, month(o.OrderDate) as Month, avg(freight) as num
from `order_details` as od, orders as o,employees as e
where od.orderid = o.orderid AND
o.employeeid = e.employeeid
group by e.firstname,Month
order by e.firstname,Month"

freight = dbSendQuery(mysqlconnection, SQL_String)
frig_df=my_query(freight)
frig_df

freight = dbSendQuery(mysqlconnection, SQL_String)
frig_mat=query_cast(freight)
frig_mat

dbClearResult(freight)

# ------------------------------------------------------------
# 第四部分：比較兩種結果
# ------------------------------------------------------------
################################################
# show up , 其實都是 data.frame
################################################
# class() 查看物件類別。雖然名稱叫 _df 和 _mat (matrix 矩陣)，
# 但 dcast() 產生的結果仍然是 data.frame，所以兩者的 class 都是 "data.frame"
# 差別只在「形狀」：_df 是長格式，_mat 是寬格式

quan_df
class(quan_df)
#  預期：[1] "data.frame"
quan_mat
class(quan_mat)
#  預期：[1] "data.frame"

unpr_df
class(unpr_df)
unpr_mat
class(unpr_mat)

frig_df
class(frig_df)
frig_mat
class(frig_mat)

# ============================================================
# 重點整理
# ============================================================
# 1. source("檔名.R") 可以載入其他檔案寫好的函數，讓程式模組化
# 2. 查詢結果只能讀一次，要再用就要重新 dbSendQuery()
# 3. 用完記得 dbClearResult()，全部結束後 dbDisconnect()
# 4. 同一份資料可以是長格式 (_df) 或寬格式 (_mat)，兩者都是 data.frame
#
# 練習題
# 1. 自己寫一個 my_query() 函數：輸入查詢結果，回傳 dbFetch(結果, n = -1)
# 2. 自己寫一個 query_cast() 函數：先抓回資料，再用 dcast(firstname ~ Month, value.var = "num") 轉成寬格式
