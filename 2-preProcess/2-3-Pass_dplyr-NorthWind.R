##########################################
#外部資料匯入及處理
#if you prefer SQL, these examples could be passed
##########################################
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
# ============================================================
# ------------------------------------------------------------
# 認識 tidyverse 與安裝 dplyr
# ------------------------------------------------------------
#tidyvese package includes:
#ggplot2, 資料視覺化 it's very helpful in data visualization
#dplyr 數據處理 , like SQL
# filter()	篩選
# select()	選擇變數
# mutate()	新增衍生變數
# arrange()	排序
# summarise()	聚合變數
# group_by()	分組，常搭配 summarise()
#tidyr 資料清理
#readr 資料讀取
#purrr 函式化程式設計
#tibble 資料型別定義
#for more info https://tidyverse.org/packages/
####
#install.packages("tidyverse") #安裝大全套
#或指定個別套件安裝即可
if (!require("dplyr")) install.packages("dplyr")
#  require() 會嘗試載入套件，成功回傳 TRUE，沒安裝則回傳 FALSE
#  !require(...) 意思是「如果載入失敗」，就執行 install.packages() 安裝
#  這樣寫的好處：已經安裝過就不會重複安裝
library(dplyr)
#  載入套件。第一次載入 dplyr 會看到類似以下訊息，這是正常的，不是錯誤：
#> 下列物件被遮斷自 'package:stats':
#>     filter, lag
#  意思是 dplyr 也有叫 filter() 的函數，之後打 filter() 會用 dplyr 的版本
####
data(iris)          # 重新載入原始的 iris 資料
typeof(iris)      # 底層儲存方式
#> [1] "list"
class(iris)       # 物件的類別
#> [1] "data.frame"
#  資料框 (data.frame) 底層其實是一個 list，每一欄是 list 的一個元素

# ------------------------------------------------------------
# dplyr 的五個核心動作
# ------------------------------------------------------------
#?filter()            #see the help
#?dplyr::filter()     #specific package name
#  在函數前面加 ? 可以打開說明文件
#  套件名稱::函數名稱 可以指定「用哪個套件的函數」，避免同名衝突

# filter()：篩選「列」，類似 SQL 的 WHERE
virginica = filter(iris, Species == "virginica")
#  留下品種是 virginica 的 50 列

#?select()            #like the SELECT clause of SQL
# select()：挑選「欄」，類似 SQL 的 SELECT
selected = select(iris, Sepal.Length, Sepal.Width, Petal.Length)
#  只留下這 3 欄，列數不變（150 列 × 3 欄）
#  dplyr 裡欄位名稱不用加引號，也不用寫 iris$

#?mutate()            #like the WHERE clause of SQL, however, it will create a new attribute
# mutate()：新增一個計算出來的欄位
#  （更精確的對應是 SQL 的 SELECT 運算式 AS 新欄位名稱，例如 SELECT a*b AS area）
newIris1 = mutate(iris, greater.mean = Sepal.Width > mean(Sepal.Width))
#Sepal.Width > mean(Sepal.Width) return T or F to the new attribute: greater.mean
#  新欄位 greater.mean：花萼寬度是否大於平均值，結果是 TRUE 或 FALSE
#  newIris1 變成 150 列 × 6 欄
newIris2 = mutate(iris, area = Sepal.Length * Sepal.Width)
# Sepal.Length * Sepal.Width return the values to the new attribute: area
#  新欄位 area：花萼長 × 寬，約略代表花萼面積


#?arrange()           #like the ORDER BY clause of SQL
# arrange()：排序，類似 SQL 的 ORDER BY
myaesc = arrange(newIris1, Petal.Length, Petal.Width)        #asc
#  先依 Petal.Length 由小到大排序；長度相同時，再依 Petal.Width 由小到大
mydesc = arrange(newIris2, desc(Petal.Length), Petal.Width) #desc
#  desc() 表示由大到小 (descending)



######
#Other usefule operations
######
# Printing the top 3 rows
sample_n(iris, 3)
#  注意：sample_n 是「隨機」抽 3 列，不是前 3 列！每次執行結果都不同
#  （要看前 3 列請用 head(iris, 3)）
#  新版 dplyr 建議改用 slice_sample(iris, n = 3)
#  以下是其中一次的結果：
#>   Sepal.Length Sepal.Width Petal.Length Petal.Width   Species
#> 1          7.7         2.8          6.7         2.0 virginica
#> 2          6.3         2.9          5.6         1.8 virginica
#> 3          5.7         2.5          5.0         2.0 virginica

# Printing 50 % of the rows
sample_frac(iris, 0.50)
#  隨機抽出 50% 的列，也就是 75 列（新版寫法：slice_sample(iris, prop = 0.5)）

summary(iris)     #NOTE: it's not the dplyr function
#  R 內建的摘要統計：每個數字欄的最小值、四分位數、平均數、最大值；類別欄則計數
#>   Sepal.Length    Sepal.Width     Petal.Length    Petal.Width
#>  Min.   :4.300   Min.   :2.000   Min.   :1.000   Min.   :0.100
#>  1st Qu.:5.100   1st Qu.:2.800   1st Qu.:1.600   1st Qu.:0.300
#>  Median :5.800   Median :3.000   Median :4.350   Median :1.300
#>  Mean   :5.843   Mean   :3.057   Mean   :3.758   Mean   :1.199
#>  3rd Qu.:6.400   3rd Qu.:3.300   3rd Qu.:5.100   3rd Qu.:1.800
#>  Max.   :7.900   Max.   :4.400   Max.   :6.900   Max.   :2.500
#>        Species
#>  setosa    :50
#>  versicolor:50
#>  virginica :50
#  1st Qu. = 第一四分位數 (25%)，Median = 中位數，3rd Qu. = 第三四分位數 (75%)

summarise(iris)   #provided to dplyr
#  沒告訴 summarise 要算什麼，所以得到一個「0 欄 1 列」的空結果
#> 資料框沒有行但有 1 列
summarise(iris, mymean = mean(Sepal.Length))
#  算出 Sepal.Length 的平均，存成名為 mymean 的欄位
#>     mymean
#> 1 5.843333

#?group_by()          #like the GROUP BY clause of SQL
# group_by()：分組，類似 SQL 的 GROUP BY
group_by(newIris1, greater.mean)
#  單獨使用 group_by 時資料「看起來沒變」，只是在資料上標記分組
#  輸出的第二行 # Groups: greater.mean [2] 表示分成 2 組（TRUE / FALSE）
#  資料也變成 tibble 格式（dplyr 的資料框，印出時只顯示前 10 列）
#> # A tibble: 150 × 6
#> # Groups:   greater.mean [2]
#>    Sepal.Length Sepal.Width Petal.Length Petal.Width Species greater.mean
#>           <dbl>       <dbl>        <dbl>       <dbl> <fct>   <lgl>
#>  1          5.1         3.5          1.4         0.2 setosa  TRUE
#>  2          4.9         3            1.4         0.2 setosa  FALSE
#>  ...（省略）...
#  <dbl> = 小數，<fct> = 類別 (factor)，<lgl> = 邏輯值 (TRUE/FALSE)
group_by(newIris1, Species)
#> # Groups:   Species [3]      ← 依品種分成 3 組

# ------------------------------------------------------------
# 管線運算子 %>%
# ------------------------------------------------------------
# %>% : the pipe line
#Windows/Linux: Ctrl + Shift + M
#Mac: Cmd + Shift + M
# 【補充】%>% 的意思是「把左邊的結果，當作右邊函數的第一個參數」
#   iris %>% group_by(Species)  等於  group_by(iris, Species)
#   好處：多個步驟可以由上往下閱讀，像「先…然後…再…」
#   R 4.1 之後也內建 |>，用法幾乎相同

iris %>%
  group_by(Species) %>%
  summarise(mymean = mean(Sepal.Length))
#  步驟：拿 iris → 依品種分組 → 算每組的花萼長度平均
#> # A tibble: 3 × 2
#>   Species    mymean
#>   <fct>       <dbl>
#> 1 setosa       5.01
#> 2 versicolor   5.94
#> 3 virginica    6.59

iris %>%
  group_by(Species) %>%
  summarise(mycount = n())
#  n() 計算每組有幾列，類似 SQL 的 COUNT(*)
#> # A tibble: 3 × 2
#>   Species    mycount
#>   <fct>        <int>
#> 1 setosa          50
#> 2 versicolor      50
#> 3 virginica       50

newIris1 %>%
  group_by(greater.mean) %>%
  summarise(mycount = n())
#  花萼寬度大於平均的有 67 朵，沒有大於平均的有 83 朵
#> # A tibble: 2 × 2
#>   greater.mean mycount
#>   <lgl>          <int>
#> 1 FALSE             83
#> 2 TRUE              67

#產生流水號
iris2 <- iris %>%
  mutate(id = row_number())
#  row_number() 產生 1, 2, 3, ... 的列編號，新增為 id 欄
irisr <- mutate(iris,id=row_number())     #the same as above
#  不用管線的寫法，結果完全相同
iris2 # make a col of id
#>     Sepal.Length Sepal.Width Petal.Length Petal.Width    Species  id
#> 1            5.1         3.5          1.4         0.2     setosa   1
#> 2            4.9         3.0          1.4         0.2     setosa   2
#> ...（省略）...
#> 150          5.9         3.0          5.1         1.8  virginica 150

# ============================================================
# 重點整理
# ============================================================
# | dplyr 函數   | 作用             | 對應 SQL           |
# |--------------|------------------|--------------------|
# | filter()     | 篩選列           | WHERE              |
# | select()     | 挑選欄           | SELECT 欄位        |
# | mutate()     | 新增計算欄位     | SELECT 運算式 AS   |
# | arrange()    | 排序             | ORDER BY           |
# | group_by()   | 分組             | GROUP BY           |
# | summarise()  | 彙總（平均、計數）| AVG()、COUNT() 等  |
# | %>%          | 把步驟串起來     | —                  |
#
# 常見錯誤
# - 條件判斷寫成一個等號：filter(iris, Species = "setosa") → 會出錯，要用 ==
# - 品種名稱大小寫或拼字錯誤："Setosa" 找不到資料（R 區分大小寫）
# - 忘記先載入 library(dplyr)：會出現「找不到函數 "filter"」或用到 stats 的 filter


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
class(nw) #dply only works on data.frame
#> [1] "data.frame" 
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

s1 <- b %>% summarise(sum(Sales))
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
#     新版 dplyr 會出錯：`Sales` must be size 1, not 3.
#     原因：summarise 規定每組只能算出「1 個值」，直接放 Sales 會得到每組好幾個值
#     舊版 dplyr 會照樣輸出多列（所以原註解說結果很不一樣），新版要改用 reframe()：
s20 <- r %>% reframe(Sales)
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
t1 <- mutate(b,Earn= Sales * (1-Discount)) #q has been grouped

#     t1 是 650 列 × 7 欄
#     Earn = 銷售額 × (1 - 折扣)，也就是折扣後的實收金額
t2 <- select(t1,-Sales) #all variables without Sales
#  select 裡的減號 - 代表「去掉這一欄」
t3 <- select(t1,Sales)  #only EmployeeID and Sales


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

