##########################################
#Reference: ggplot2 cheat sheet
##########################################
# ============================================================
# 3-4 用 qplot() 快速畫圖（NorthWind 銷售資料）
# ============================================================
# qplot = quick plot，是 ggplot2 的「簡易版」畫圖函數：
#   一行就能畫出圖，寫法和 R 內建的 plot() 很像。
#   qplot(data = 資料, x = 欄位, y = 欄位, geom = "圖形種類", color = ..., facets = ...)
#   只給 x：類別資料 → 長條圖；連續資料 → 直方圖
#   給 x 和 y：預設畫散布圖
#
# 注意：qplot() 從 ggplot2 3.4.0 開始被標示為「不建議使用」(deprecated)，
#    執行時會出現警告，但目前還能使用。正式作業建議改用 ggplot() 寫法（見 3-2 範例）。
#
# 說明：這個範例原本從資料庫讀取資料。以下的描述是改用 NWSales.csv
#       （和資料庫查詢結果相同的資料）實際執行後確認的。
# ============================================================

# ------------------------------------------------------------
# 第一部分：讀取資料
# ------------------------------------------------------------
source("mysql_conn.R") #connect to mysql
#  執行 mysql_conn.R：連線資料庫並送出查詢（需要能連到課程伺服器）
nw <-  fetch(myquery_result, n=-1)  #read all the data from result
#  把查詢結果全部抓回來，存成資料框 nw
#  沒有資料庫連線時，這裡會出錯，後面所有程式也都會因為「找不到物件 'nw'」而失敗。
#     可以改用本機的 CSV 檔：nw <- read.csv("NWSales.csv")
#setwd("somewhere of your working directory")
nw <-  read.csv("https://raw.githubusercontent.com/KuoLiang/r-klou/main/3-Plot/NWSales.csv")

nw
##########################################
#transform
##########################################
nw$Year = factor(nw$Year)
nw$EmployeeID = factor(nw$EmployeeID)
nw$ShipCountry = factor(nw$ShipCountry)
#  把年份、員工、國家轉成類別 (factor)，畫圖時才會當成分組

library(ggplot2)

# ------------------------------------------------------------
# 第二部分：x 是類別 → 長條圖（自動計數）
# ------------------------------------------------------------
##########################################
#x 為類別資料 ； y 為 count
##########################################
qplot(data=nw,x=EmployeeID)
#  只給 x 而且是類別 → 長條圖，高度是每位員工的資料筆數
#  第一次執行會出現警告：`qplot()` was deprecated in ggplot2 3.4.0.（見檔案開頭說明）
qplot(data=nw,x=EmployeeID,
      fill=Year)
#  fill = Year：依年份填色，三個年份堆疊在同一根長條上
qplot(data=nw,x=EmployeeID,
      fill=Year, facets = Year~.)
#  facets = Year ~ .：依年份拆成上下 3 張圖
#  公式「列 ~ 欄」：~ 左邊決定上下排，右邊決定左右排，. 代表不拆
qplot(data=nw,x=EmployeeID,
      fill=Year, facets = Year~EmployeeID)
#  上下依年份、左右依員工，拆成 3 × 9 = 27 張小圖

# ------------------------------------------------------------
# 第三部分：x、y 都是連續 → 散布圖、趨勢線
# ------------------------------------------------------------
##########################################
#x 為連續資料 ; y 為連續資料
##########################################
qplot(data=nw,x=Freight,y=Sales)
#  散布圖：x 運費、y 銷售額
qplot(data=nw,x=Freight,y=Sales,
      geom = "smooth")
#  geom = "smooth"：只畫平滑趨勢線（和灰色信賴區間），不畫點
#  想同時畫點和線：geom = c("point", "smooth")

qplot(data=nw,x=Freight,y=Sales,
      geom = "smooth", color=Year, facets = Year~.)
#  每年一張圖，各自畫趨勢線
qplot(data=nw,x=Freight,y=Sales,
      geom = "smooth", color=Year, facets = Year~EmployeeID)
#  拆成 27 張小圖。有些小圖的資料很少，R 會出現 pseudoinverse used、
#  neighborhood radius 等警告，意思是「資料太少，趨勢線可能不準」，圖仍然會畫出來

# ------------------------------------------------------------
# 第四部分：x 是類別、y 是連續 → 比較各組
# ------------------------------------------------------------
##########################################
#x 為類別資料 ; y 為連續資料
##########################################
qplot(data=nw,x=EmployeeID) # 指定X軸 類別型資料
#  只有 x 而且是類別 → 長條圖（計數）
qplot(data=nw,x=Sales) # 指定X軸 連續型資料
#  只有 x 而且是連續 → 直方圖
#  會出現訊息 `stat_bin()` using `bins = 30`：預設切成 30 個區間
qplot(data=nw,x=EmployeeID,y=Sales) # 指定X Y 軸
#  x 類別 + y 連續 → 每位員工一直排的點
#
qplot(data=nw,x=EmployeeID,y=Sales,
      color=Year,size=I(3)) #依年份分色,指定點的大小
#     要「固定」點的大小，要用 I() 包起來：size = I(3)
#     I() 的意思是「照字面使用這個值」(as Is)，不要當成資料對應
qplot(data=nw,x=EmployeeID,y=Sales,
      color=Year, facets = "Year") #依年份分色分平面
#  facets 也可以只寫欄位名稱字串，效果是依年份拆成多張圖並排
#
qplot(data=nw,x=EmployeeID,y=Sales,
      color=Year,shape=I(5),alpha=I(0.5), #點型及透明度
      main="The NorthWind",xlab="員工",ylab="業績") +
      theme(text = element_text(family = "Heiti TC Light"))
# 主標題 main; xlab ylab 為軸標題；使用 Mac 繁體中文黑體
#  shape = I(5)：點的形狀固定為 5 號（空心菱形）。R 的點形狀編號 0~25，可以搜尋「R pch」查看
#  alpha = I(0.5)：半透明，點重疊時顏色會變深，比較看得出哪裡資料多
#  main = 標題、xlab = x 軸標題、ylab = y 軸標題
#  theme(text = element_text(family = "字型名稱"))：指定字型，中文才不會變成方框
#    Mac 可以用 "Heiti TC Light"（黑體-繁）或 "PingFang TC"（蘋方-繁）
#    Windows 可以用 "Microsoft JhengHei"（微軟正黑體）
######
#其它圖型
######
qplot(data=nw,x=EmployeeID,y=Sales,
      geom="boxplot") # 箱形圖
#  每位員工的銷售額分布：中位數、四分位數、離群值
qplot(data=nw,x=EmployeeID,y=Sales,
      geom="violin") #  提琴圖
#  形狀越寬，代表那個金額附近的訂單越多
qplot(data=nw,x=EmployeeID,y=Sales,
      geom="violin",ylim = c(1,5000)) # y 軸地板及天花板
#  ylim = c(1, 5000)：只畫 y 在 1~5000 之間的資料
#  會出現警告 Removed 20 rows：超過 5000 的 20 筆資料被刪掉後才畫圖

# ------------------------------------------------------------
# 第五部分：用中括號篩選資料（R 內建寫法）
# ------------------------------------------------------------
##########################################
#篩資料
##########################################
nw_France=nw[nw$ShipCountry=="France",]
#  資料框[列的條件, 欄]：逗號前放條件，逗號後空白代表所有欄
#  nw$ShipCountry == "France" 會產生 2155 個 TRUE/FALSE，只留下 TRUE 的列 → 184 列
nw_France
nw_Expensive=nw[nw$Sales>1000 & nw$Sales<2000,]
#  & 是「且」：銷售額大於 1000 且小於 2000 → 245 列
nw_Expensive

# ============================================================
# 重點整理
# ============================================================
# | qplot 寫法                          | 結果           |
# |-------------------------------------|----------------|
# | qplot(x = 類別)                     | 長條圖（計數） |
# | qplot(x = 連續)                     | 直方圖         |
# | qplot(x = ..., y = ...)             | 散布圖         |
# | geom = "smooth" / "boxplot" / "violin" | 趨勢線 / 箱形圖 / 小提琴圖 |
# | facets = 列 ~ 欄                    | 拆成多張小圖   |
# | size = I(3)、alpha = I(0.5)         | 固定值要用 I() |
#
# qplot 對照 ggplot 寫法：
#   qplot(data = nw, x = EmployeeID, y = Sales, geom = "boxplot")
#   ggplot(nw, aes(x = EmployeeID, y = Sales)) + geom_boxplot()
#

