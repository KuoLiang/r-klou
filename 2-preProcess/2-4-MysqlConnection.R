# ============================================================
# 2-4 用 R 連線 MySQL 資料庫並執行 SQL 查詢
# ============================================================
# 這個範例教你：
#   1. 一次安裝、載入多個套件（自訂函數 + lapply）
#   2. 用 RMySQL 連線到 MySQL 資料庫
#   3. 把 SQL 查詢結果抓回 R，變成資料框
#
# 注意：這個範例需要能連到課程的 MySQL 伺服器才能執行。
#       沒有連線時，從 dbConnect() 開始會出錯，所以以下沒有附實際輸出結果，
#       只說明「預期會得到什麼」。
# ============================================================

# ------------------------------------------------------------
# 第一部分：一次安裝多個套件
# ------------------------------------------------------------
# Define a vector of package names to be installed
packages_to_install <- c("RMySQL", "reshape2")
#  把要用的套件名稱放進一個文字向量
#  RMySQL：連線 MySQL 用；reshape2：轉換資料形狀用（下一個範例會用到）

# Create a function to check for and install packages
# 【補充】自訂函數的寫法：
#   函數名稱 <- function(參數) { 要做的事 }
#   之後就可以像內建函數一樣呼叫：install_if_missing("dplyr")
install_if_missing <- function(pkg)
{
    if (!require(pkg, quietly = TRUE))
      {
        install.packages(pkg)
      }
}
#  ⚠️ 這個函數有一個不容易發現的問題：
#     require(pkg) 會把 pkg 當成「套件的名字」，去找一個叫做 "pkg" 的套件，
#     而不是去讀變數 pkg 裡存的 "RMySQL"。
#     結果 require 永遠回傳 FALSE，每次執行都會重新安裝套件（浪費時間，但不會壞掉）。
#     修正方法：加上 character.only = TRUE，告訴 require「pkg 是變數，請讀它的內容」：
#       if (!require(pkg, character.only = TRUE, quietly = TRUE))

install_if_missing(packages_to_install)
#  把整個向量 c("RMySQL","reshape2") 一次丟進函數
#  （require 一次只能檢查一個套件，所以建議用下面的 lapply 寫法）

# Or use lapply (Apply a list to a function) to apply the function to each package in the vector
lapply(packages_to_install, install_if_missing) #lapply( list, function) 一次安裝多個 packages
#  lapply(清單, 函數)：把清單裡的「每一個元素」分別交給函數處理
#  等於依序執行 install_if_missing("RMySQL") 和 install_if_missing("reshape2")
#  結果會以 list 的形式印出（每個元素是函數的回傳值，這裡是 NULL）

# Load the installed packages 一次載入多個 packages
lapply(packages_to_install, library, character.only = TRUE)
#  對每個套件名稱執行 library(套件名稱, character.only = TRUE)
#  這裡有加 character.only = TRUE，所以能正確讀取變數裡的套件名稱

# ------------------------------------------------------------
# 第二部分：連線到 MySQL
# ------------------------------------------------------------
################
#make a connection to Mysql
#please change user to "root"
#password change to ''
#host to "localhost" or "127.0.0.1"
################
# 【補充】如果在自己電腦上安裝 MySQL 練習，依照上面的說明把帳號、密碼、主機改掉
#   user     = 帳號
#   password = 密碼
#   dbname   = 要使用的資料庫名稱
#   host     = 資料庫伺服器的位址（localhost 代表自己的電腦）

mysqlconnection = dbConnect(MySQL(), user = 'student', password = '673cqdJ2s@t9Y@uc',
                            dbname = 'northwind' ,host = '10.8.0.1')
#  dbConnect() 建立連線，存成 mysqlconnection，之後所有查詢都透過它
#  ⚠️ 安全提醒：密碼直接寫在程式碼裡，上傳到 GitHub 等公開地方就會被所有人看到。
#     比較安全的做法是把密碼存在環境變數，再用 Sys.getenv("DB_PASSWORD") 讀取。
dbListTables(mysqlconnection)
#  列出資料庫中所有的資料表名稱，例如 "customers" "employees" "orders" ...
#  可以用來確認連線成功

# ------------------------------------------------------------
# 第三部分：執行 SQL 查詢，把結果抓回 R
# ------------------------------------------------------------
################
SQL_String <-
"SELECT e.firstname, month(o.OrderDate) as Month, avg(quantity) as num
from `order_details` as od, orders as o,employees as e
where od.orderid = o.orderid AND
o.employeeid = e.employeeid
group by e.firstname,Month
order by e.firstname,Month"
#  把 SQL 指令存成一個文字字串；字串可以跨多行
#  這段 SQL 的意思：每位員工 (firstname)、每個月份 (Month) 的「平均訂購數量」
#  od、o、e 是資料表的別名；資料表名稱有底線時用反引號 ` ` 包起來

query_result = dbSendQuery(mysqlconnection, SQL_String)
#  dbSendQuery()：把 SQL 送到資料庫執行，此時資料還在伺服器上
query_df=fetch(query_result, n = -1)
#  fetch()：把查詢結果抓回 R，變成資料框；n = -1 代表「全部抓回來」
#  （新版建議改用 dbFetch()，用法相同）
query_df
#  預期結果：三欄 firstname、Month、num 的資料框，每位員工每個月一列
################

SQL_String <-
"SELECT e.firstname, month(o.OrderDate) as Month, avg(unitprice) as num
from `order_details` as od, orders as o,employees as e
where od.orderid = o.orderid AND
o.employeeid = e.employeeid
group by e.firstname,Month
order by e.firstname,Month"
#  和上面相同的結構，改成計算「平均單價」avg(unitprice)

query_result = dbSendQuery(mysqlconnection, SQL_String)
#  ⚠️ 前一個 query_result 沒有用 dbClearResult() 清除就送出新查詢，
#     RMySQL 可能會出現警告或錯誤。建議每次 fetch 完加上：dbClearResult(query_result)
query_df=fetch(query_result, n = -1)
query_df
###

SQL_String <-
"SELECT e.firstname, month(o.OrderDate) as Month, avg(freight) as num
from `order_details` as od, orders as o,employees as e
where od.orderid = o.orderid AND
o.employeeid = e.employeeid
group by e.firstname,Month
order by e.firstname,Month"
#  計算「平均運費」avg(freight)

query_result = dbSendQuery(mysqlconnection, SQL_String)
query_df=fetch(query_result, n = -1)
query_df

################
# 【補充】用完資料庫後記得關閉連線，釋放伺服器資源：
#   dbDisconnect(mysqlconnection)

# ============================================================
# 重點整理
# ============================================================
# | 函數                 | 作用                          |
# |----------------------|-------------------------------|
# | function(x) { }      | 自訂函數                      |
# | lapply(清單, 函數)   | 對清單每個元素執行同一個函數  |
# | dbConnect()          | 建立資料庫連線                |
# | dbListTables()       | 列出所有資料表                |
# | dbSendQuery()        | 送出 SQL 查詢                 |
# | fetch() / dbFetch()  | 把結果抓回 R 變成資料框       |
# | dbClearResult()      | 清除查詢結果                  |
# | dbDisconnect()       | 關閉連線                      |
#
# 練習題
# 1. 修改 SQL，改成計算每位員工「每一年」的平均數量
# 2. 用 nrow(query_df) 查看查詢結果有幾列
# 3. 把 install_if_missing 函數修正成只在套件沒安裝時才安裝
