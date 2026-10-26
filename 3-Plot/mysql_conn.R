##########################################
#To avoid re-install packages
##########################################
# ============================================================
# mysql_conn.R：連線 NorthWind 資料庫並送出查詢（給 3-2、3-4 用 source() 引用）
# ============================================================
# 這個檔案不是單獨執行的範例，而是被其他程式用 source("mysql_conn.R") 引用。
# 執行完後會留下兩個物件給主程式使用：
#   mysqlconnection ：資料庫連線
#   myquery_result  ：查詢結果（還在伺服器上，主程式用 fetch() 抓回來）
#
# 注意：需要能連到課程的 MySQL 伺服器才能執行，所以沒有附執行結果。
# ============================================================

# ------------------------------------------------------------
# 第一部分：只安裝「還沒安裝」的套件
# ------------------------------------------------------------
# Package names
package_list <- c("ggplot2", "dplyr", "RMySQL")

# Install packages not yet installed
installed_packages <- package_list %in% rownames(installed.packages())
#  installed.packages() 列出電腦上已安裝的所有套件，rownames() 取出套件名稱
#  %in%：檢查左邊每個元素「是否出現在」右邊 → 得到 3 個 TRUE / FALSE
#  例如 c(TRUE, TRUE, FALSE) 代表 ggplot2、dplyr 已安裝，RMySQL 還沒安裝
if (any(installed_packages == FALSE)) {
  install.packages(package_list[!installed_packages])
}
#  any()：只要有任何一個是 FALSE（沒安裝），就執行大括號裡的程式
#  package_list[!installed_packages]：! 反向，只挑出「沒安裝」的套件來安裝
#  這是避免重複安裝的好寫法，比每次都 install.packages() 有效率

library("RMySQL")
#  載入連線 MySQL 用的套件

# ------------------------------------------------------------
# 第二部分：SQL 查詢字串
# ------------------------------------------------------------
myquery_string <-
  "SELECT e.EmployeeID, Year(o.OrderDate) as Year,o.ShipCountry, od.Quantity*od.UnitPrice as Sales,od.Discount, o.Freight
FROM employees as e, orders as o, order_details as od
WHERE e.EmployeeID=o.EmployeeID AND o.OrderID = od.OrderID"
#  這段 SQL 合併三個資料表（員工、訂單、訂單明細），取出：
#    員工編號、訂單年份、出貨國家、銷售額（數量 × 單價）、折扣、運費
#  查詢結果就是 NWSales.csv 的內容（2155 列 × 6 欄）
#myquery <-  "select EmployeeID from employees"

# ------------------------------------------------------------
# 第三部分：連線並送出查詢
# ------------------------------------------------------------
mysqlconnection <-  dbConnect(MySQL(), user = 'student', password = '673cqdJ2s@t9Y@uc', dbname = 'northwind' ,host = '10.8.0.1')
#  dbConnect()：建立資料庫連線
#    user / password = 帳號密碼、dbname = 資料庫名稱、host = 伺服器位址
#  ⚠️ 安全提醒：密碼直接寫在程式碼裡，上傳到 GitHub 等公開地方就會被所有人看到。
#     比較安全的做法是把密碼存在環境變數，再用 Sys.getenv("DB_PASSWORD") 讀取。
dbListTables(mysqlconnection)
#  列出資料庫中所有資料表的名稱，可以用來確認連線成功

myquery_result <-  dbSendQuery(mysqlconnection, myquery_string)
#  送出 SQL 查詢。結果還在伺服器上，
#  要用 fetch(myquery_result, n = -1)（或 dbFetch）抓回 R，主程式 3-2、3-4 就是這樣做的
