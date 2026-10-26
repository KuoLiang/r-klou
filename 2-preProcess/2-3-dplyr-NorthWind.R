##########################################
#外部資料匯入及處理
#if you prefer SQL, these examples could be passed
##########################################
# ============================================================
# 2-3 用 dplyr 處理外部 CSV 檔（NorthWind 銷售資料）
# ============================================================
# 這個範例教你：
#   1. 用 read.csv() 讀取 CSV 檔
#   2. 用 factor() 把欄位轉成類別
#   3. 用 filter / group_by / summarise / count / mutate / select 分析資料
#   4. 合併資料框：bind_cols、bind_rows、left_join、right_join
#   5. 處理缺失值 NA
#
# 資料 NWSales.csv 共 2155 列、6 欄：
#   EmployeeID 員工編號、Year 年份、ShipCountry 出貨國家、
#   Sales 銷售額、Discount 折扣、Freight 運費
#
# 說明：#> 是 R 4.6.1 實際執行的結果。
#       標示 ⚠️ 的地方是原程式會出錯或結果和預期不同的地方，附有修正建議。
# ============================================================

# ------------------------------------------------------------
# 第一部分：讀取 CSV 檔
# ------------------------------------------------------------
#讀取外部檔案
#setwd("somewhere your csv file located")
#set the working directory
#  setwd() 設定「工作目錄」，R 會從這個資料夾找檔案
#  在 RStudio 也可以用選單 Session → Set Working Directory → To Source File Location
nw <-  read.csv("NWSales.csv")
#  讀取 CSV 檔，存成資料框 nw（2155 列 × 6 欄）
#  如果出現「無法開啟檔案」，通常是工作目錄不對
typeof(nw)
#> [1] "list"
class(nw). #dply only works on data.frame
#  ⚠️ 這行最後多了一個句點「.」，執行會出現語法錯誤 (unexpected symbol)
#     正確寫法：class(nw)
#> [1] "data.frame"      ← 去掉句點後的結果
#or you can import the NWSales.csv as the nw obejct
#  也可以用 RStudio 右上角 Environment → Import Dataset 匯入

if (!require("dplyr")) install.packages("dplyr")
library(dplyr) #call the specific packages in to memory

#check the reauired packages, if not, install at once only
#the require function will reture true or false
# filter()	篩選，類似 WHERE
# select()	選擇變數
# mutate()	新增衍生變數
# arrange()	排序
# summarise()	聚合變數
# group_by()	分組，常搭配 summarise()

# 以下是產生這份 CSV 的 SQL 查詢，供熟悉 SQL 的同學對照：
# SELECT o.EmployeeID, YEAR(o.OrderDate), o.ShipCountry,
# od.UnitPrice*od.Quantity as Sales, od.Discount, o.Freight
# FROM `order_details` as od, orders as o
# WHERE od.OrderID = o.OrderID
# order by o.EmployeeID

##########################################
#transform to factor
# https://www.w3schools.com/r/r_factors.asp
##########################################
# 【補充】factor（因子）是 R 用來表示「類別」的資料型態。
#   員工編號 1、2、3 雖然是數字，但拿來加減沒有意義，它其實是「類別」。
#   轉成 factor 後，R 才會把它當成分組依據，而不是數值。
#   nw$Year 的 $ 是「取出資料框中的某一欄」
nw$Year = factor(nw$Year)
nw$EmployeeID = factor(nw$EmployeeID)
nw$ShipCountry = factor(nw$ShipCountry)
##########################################

summarise(nw,mean(Sales))   # 全部銷售額的平均
#>   mean(Sales)
#> 1    628.5191
summarise(nw,max(Sales))    # 最大值
#>   max(Sales)
#> 1      15810
summarise(nw,min(Sales))    # 最小值
#>   min(Sales)
#> 1        4.8
#  沒有幫結果取名時，欄位名稱就是運算式本身 mean(Sales)
#  建議取名：summarise(nw, avg = mean(Sales))

#########################
#filter
#pipeline  %>%
#hotkey :Ctrl + Shift + M (Windows) or Cmd + Shift + M (Mac)
#########################
# 每一行都把結果存進 p，後面的會蓋掉前面的。可以每行執行後輸入 nrow(p) 看列數。
p <- nw %>% filter(Year == 1994)
#  1994 年的資料 → 324 列
p <- nw %>% filter(Year != 1994) #NOT
#  != 是「不等於」→ 1995 和 1996 年，共 1831 列
p <- nw %>% filter(Year == 1994 | Year == 1995) # OR
#  | 是「或」→ 324 + 1026 = 1350 列
p <- nw %>% filter(Year == 1994 & Year == 1995) # AND
#  & 是「且」→ 0 列！因為同一筆資料的年份不可能同時是 1994 又是 1995
#  這是常見的邏輯錯誤，同一欄位要「多選一」時應該用 |，或用 Year %in% c(1994, 1995)
p <- nw %>% filter(Year == 1994 & EmployeeID == 1)
#  1994 年「且」員工 1 → 47 列
p <- nw %>% filter(Sales >= mean(Sales))
#  銷售額大於等於整體平均 (628.5) → 618 列

#########################
#pipeline ctrl shift M
#group by ; need to associate with summarize(), filter() ,count() or mutate()
#########################
a <- group_by(nw,EmployeeID) #nothing happened
#  依員工分組。資料內容沒變，只是加上「分組標記」，要搭配後續函數才看得出效果
  summarise(a,mean(Sales))   # 每位員工的平均銷售額
#> # A tibble: 9 × 2
#>   EmployeeID `mean(Sales)`
#>   <fct>              <dbl>
#> 1 1                   586.
#> 2 2                   738.
#> 3 3                   664.
#> 4 4                   596.
#> 5 5                   646.
#> 6 6                   465.
#> 7 7                   803.
#> 8 8                   513.
#> 9 9                   775.
  summarise(a,n())           # 每位員工有幾筆訂單明細
#>   EmployeeID `n()`
#> 1 1            345
#> 2 2            241
#> 3 3            321
#> 4 4            420
#> ...（省略）...
  summarise(a,mean(Freight)) # 每位員工的平均運費
b <- filter(a,Sales >= mean(Sales))
#  重要觀念：分組後再 filter，mean(Sales) 是「每位員工自己的平均」，不是全部的平均
#  所以 b 是「每位員工高於自己平均的那些訂單」→ 650 列（比上面的 618 列多）


#########################
#pipe lines, the %>% at the end of each line
#########################
q <- nw %>%
  group_by(EmployeeID) %>%
  filter(Sales >= mean(Sales)) %>%
  summarise(mean(Sales)) # put the nw into group_by function
#  步驟：依員工分組 → 留下高於自己平均的訂單 → 再算這些訂單的平均
#  q 只剩 9 列 × 2 欄，欄位名稱是 EmployeeID 和 `mean(Sales)`
#  注意：summarise 之後，原本的 Sales、Discount 等欄位都不見了！（後面會用到這個觀念）
#> # A tibble: 9 × 2
#>   EmployeeID `mean(Sales)`
#>   <fct>              <dbl>
#> 1 1                  1430.
#> 2 2                  1888.
#> ...（省略）...
#> 9 9                  2143.


r <- nw %>% group_by(EmployeeID,ShipCountry) #group by two factors
#  同時依「員工 + 國家」兩個欄位分組，共 167 組
r1 <- r %>% filter(Sales >= mean(Sales))
#  每個「員工 × 國家」組合中，高於該組平均的訂單 → 757 列

#########################
#summarise() to aggregate with sum,mean,max,min
#########################

s1 <- q %>% summarise(sum(Sales))
#  ⚠️ 錯誤：找不到物件 'Sales'
#     原因：q 已經 summarise 過，只剩 EmployeeID 和 `mean(Sales)` 兩欄，沒有 Sales 欄
#     修正建議：改用還保留明細的 b → s1 <- b %>% summarise(sum(Sales))
s2 <- r %>% summarise(sum(Sales))
#  每個「員工 × 國家」的銷售總額 → 167 列
#  執行時會出現提示訊息 `summarise()` has regrouped the output，這不是錯誤，意思是：
#    依兩個欄位分組彙總後，結果只保留第一個分組欄位 EmployeeID 的分組
#> # A tibble: 3 × 3        ← 前 3 列
#> # Groups:   EmployeeID [1]
#>   EmployeeID ShipCountry `sum(Sales)`
#> 1 1          Argentina           687.
#> 2 1          Austria           18305.
#> 3 1          Belgium             751
s20 <- r %>% summarise(Sales)   #quite different result
#  ⚠️ 新版 dplyr 會出錯：`Sales` must be size 1, not 3.
#     原因：summarise 規定每組只能算出「1 個值」，直接放 Sales 會得到每組好幾個值
#     舊版 dplyr 會照樣輸出多列（所以原註解說結果很不一樣），新版要改用 reframe()：
#     s20 <- r %>% reframe(Sales)
s21 <- r %>% summarise(max(Sales)) # see the EmployeeID =1 and Argentina
s22 <- r %>% summarise(min(Sales))
s23 <- r %>% summarise(mean(Sales))
s25 <- r %>% summarise(n()) #count
#  每個「員工 × 國家」組合的最大值、最小值、平均、筆數
s15 <- q %>% summarise(n()) #count
#  q 經過 summarise 後已經沒有分組，所以 n() 計算整個 q 的列數 → 9

#########################
#count() to aggregate
#########################
# 【補充】count(x) 是 group_by(x) %>% summarise(n = n()) 的簡寫
s11 <- q %>% count(EmployeeID)
#  q 中每位員工只有 1 列，所以 n 全部是 1
s12 <- r %>% count(EmployeeID)
#  r 已經依「員工 + 國家」分組，count 會沿用原本的分組，結果和 s25 相同（167 列）
#> # A tibble: 3 × 3        ← 前 3 列
#>   EmployeeID ShipCountry     n
#> 1 1          Argentina       3
#> 2 1          Austria        17
#> 3 1          Belgium         3

#########################
#mutate()
#########################
t1 <- mutate(q,Earn= Sales * (1-Discount)) #q has been grouped
#  ⚠️ 錯誤：找不到物件 'Sales'
#     原因同 s1：q 已經沒有 Sales 和 Discount 欄
#     修正建議：改用分組後仍保留明細的 b → t1 <- mutate(b, Earn = Sales * (1-Discount))
#     改用 b 之後，t1 是 650 列 × 7 欄
#  Earn = 銷售額 × (1 - 折扣)，也就是折扣後的實收金額
t2 <- select(t1,-Sales) #all variables without Sales
#  select 裡的減號 - 代表「去掉這一欄」
t3 <- select(t1,Sales)  #only EmployeeID and Sales
#  只選 Sales，但因為 t1 有依 EmployeeID 分組，dplyr 會自動保留分組欄位，
#  並顯示 Adding missing grouping variables: `EmployeeID`
#  （⚠️ 原程式中 t1 出錯，所以 t2、t3 也會跟著出錯：找不到物件 't1'）

t11 <- mutate(nw,Earn= Sales * (1-Discount)) #nw hasn't been grouped
#  nw 有 Sales 和 Discount，可以正常執行 → 2155 列 × 7 欄
t21 <- select(t11,-Sales) #all variables without Sales
#  去掉 Sales → 2155 列 × 6 欄
t31 <- select(t11,Sales)  #only Sales
#  沒有分組，所以真的只有 Sales 一欄 → 2155 列 × 1 欄

#########################
#combine variables
#########################

u <- bind_cols(t21,t31) # by order of the two data frame
#  bind_cols：左右「並排」合併，依列的順序對齊（第 1 列配第 1 列）
#  兩邊列數必須相同 → u 是 2155 列 × 7 欄
#
t2id <- rep(1:nrow(t2)) #repeat 1,2,3,... to the number of row
#  nrow() 算列數；1:nrow(t2) 就是 1, 2, 3, ..., 列數
#  （外面的 rep() 只重複 1 次，其實可以省略，直接寫 1:nrow(t2)）
t22 <- cbind(id=t2id,t2)
#  cbind：在最前面加上一欄 id 當作流水號
t3id <- rep(1:nrow(t3))
t32 <- cbind(id=t3id,t3)
#  ⚠️ 以上 4 行因為 t2、t3 不存在而出錯；照上面的建議修正 t1 後就能執行

u1 <- left_join(t22,t32,by="id")
#  left_join：依 id 欄「配對」合併，保留左邊 t22 的所有列，類似 SQL 的 LEFT JOIN
#  和 bind_cols 不同：join 是「依鍵值配對」，不是依順序
#  （修正後：兩邊都有 EmployeeID，結果會出現 EmployeeID.x 和 EmployeeID.y 兩欄）
u2 <- right_join(t22,t32,by="id")
#  right_join：保留右邊 t32 的所有列，類似 SQL 的 RIGHT JOIN
v <- bind_rows(t21,t31) # 2155 * 2 = 4310
#  bind_rows：上下「堆疊」合併 → 4310 列
#  兩邊欄位不同時，缺少的欄位會補 NA：
#    前 2155 列（來自 t21）沒有 Sales → Sales 是 NA
#    後 2155 列（來自 t31）只有 Sales → 其他欄位都是 NA
#  這正好製造出一份有缺失值的資料，給下一部分練習

#########################
#missing values
#########################
# 【補充】NA 代表缺失值。大部分計算遇到 NA 結果也會是 NA，
#   例如 mean(c(1, NA, 3)) → NA，要加 na.rm = TRUE 才會忽略 NA
v1 <- v #備份起來
missing <- complete.cases(v1$Sales)
#  complete.cases()：沒有缺失值 → TRUE，有缺失值 → FALSE
#  注意：變數名稱叫 missing，但 TRUE 其實代表「完整、沒有缺失」
v1.rm <- v1[!missing, ] # candidate to be removed
#  ! 是「反向」，所以 !missing 是「Sales 有缺失」的列 → 2155 列
#  v1.rm 就是準備要刪除的那些列

v.7.mean <- mean(v1$Sales, na.rm= T)  # 第7欄平均數
v.7.mean <- mean(v1[,7], na.rm= T)  # 第7欄平均數
#  兩種寫法相同：v1 的第 7 欄就是 Sales（欄位順序：EmployeeID, Year, ShipCountry,
#  Discount, Freight, Earn, Sales）
#  na.rm = T：計算時忽略 NA（T 是 TRUE 的簡寫）→ 結果 628.5191

na.rows <- is.na(v1[, 7])    # 第7欄位中，有遺漏值存在的資料
#  is.na()：是 NA → TRUE
v1[na.rows, 7] <- v.7.mean # 用平均數填補遺漏值
#  把第 7 欄中是 NA 的格子，全部填入平均數
#  這叫「平均數插補」(mean imputation)，是處理缺失值的常見方法之一

#########################
#subset arrange
#########################
w = subset(nw, Sales >=5000) #
#  R 內建 subset()：銷售額 ≥ 5000 的資料 → 20 列 × 6 欄
w1 = subset(nw, Sales >=5000, select = EmployeeID) #
#  同樣條件，但只留 EmployeeID 一欄 → 20 列 × 1 欄
w2 = v %>% group_by(EmployeeID) %>% count() %>%
  arrange(desc(n))
#  計算每位員工的筆數，由多到少排序
#  注意：v 的後 2155 列沒有 EmployeeID（是 NA），所以 NA 也會被算成一組，而且排第一
#> # A tibble: 10 × 2
#> # Groups:   EmployeeID [10]
#>    EmployeeID     n
#>  1 <NA>        2155
#>  2 4            420
#>  3 1            345
#>  4 3            321
#>  5 8            260
#>  ...（省略）...
#> 10 9            107

# ============================================================
# 重點整理
# ============================================================
# 1. read.csv() 讀檔；找不到檔案時先檢查工作目錄 getwd()
# 2. 類別型的欄位（編號、年份、國家）用 factor() 轉換
# 3. 分組後再 filter / mutate，計算的是「每一組自己的」平均或總和
# 4. summarise() 之後只剩分組欄位和彙總結果，原始欄位會消失
# 5. bind_cols 左右並排、bind_rows 上下堆疊、left_join / right_join 依鍵值配對
# 6. NA 是缺失值；計算時用 na.rm = TRUE 忽略，或用平均數填補
#
# 練習題
# 1. 計算每一年 (Year) 的銷售總額
# 2. 找出銷售總額最高的出貨國家前 5 名
# 3. 新增 Earn 欄位後，計算每位員工的平均 Earn，由高到低排序
