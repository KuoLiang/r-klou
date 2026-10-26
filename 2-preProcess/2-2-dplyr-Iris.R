# ============================================================
# 2-2 資料框篩選與 dplyr 入門（使用 iris 鳶尾花資料）
# ============================================================
# 這個範例教你：
#   1. 用 R 內建的 subset() 挑出需要的資料
#   2. 用 dplyr 套件的 filter / select / mutate / arrange /
#      summarise / group_by 處理資料，觀念很像 SQL
#   3. 用管線運算子 %>% 把多個步驟串起來
#
# iris 是 R 內建的資料集：150 朵鳶尾花，5 個欄位
#   Sepal.Length 花萼長度、Sepal.Width 花萼寬度、
#   Petal.Length 花瓣長度、Petal.Width 花瓣寬度、
#   Species 品種（setosa、versicolor、virginica 各 50 朵）
#
# 說明：#> 是 R 4.6.1 實際執行的結果；輸出太長的部分只列前幾行。
# ============================================================

# ------------------------------------------------------------
# 第一部分：subset() 篩選資料（R 內建，不需安裝套件）
# ------------------------------------------------------------
#subset function
#subset(dataframe, select...)
# 【補充】subset(資料框, 條件, select = 要留下的欄位)
library(datasets)   # 載入內建資料集套件（R 啟動時其實已自動載入）
str(iris)           # str = structure，查看資料的結構：幾列幾欄、每欄的型態
#> 'data.frame':	150 obs. of  5 variables:
#>  $ Sepal.Length: num  5.1 4.9 4.7 4.6 5 5.4 4.6 5 4.4 4.9 ...
#>  $ Sepal.Width : num  3.5 3 3.2 3.1 3.6 3.9 3.4 3.4 2.9 3.1 ...
#>  $ Petal.Length: num  1.4 1.4 1.3 1.5 1.4 1.7 1.4 1.5 1.4 1.5 ...
#>  $ Petal.Width : num  0.2 0.2 0.2 0.2 0.2 0.4 0.3 0.2 0.2 0.1 ...
#>  $ Species     : Factor w/ 3 levels "setosa","versicolor",..: 1 1 1 1 1 1 1 1 1 1 ...
#  obs. = observations（觀察值，也就是列數）；num = 數字；Factor = 類別

a <- iris           # 把 iris 複製一份存到 a
b <- subset(iris, Species == "versicolor")
#  只留下品種是 versicolor 的資料 → 50 列 × 5 欄
#  注意：比較「是否相等」要用兩個等號 ==，一個等號 = 是賦值

c <- subset(iris,
            Species == "versicolor" |          #OR operator
            Species == "setosa"  )[,c(1,3,5)]  #tell me what's that?
#  【解答】
#  | 是「或」(OR)：品種是 versicolor「或」setosa 都留下 → 100 列
#  後面的 [,c(1,3,5)] 是「取出第 1、3、5 欄」：
#    中括號 [列, 欄]，逗號前面空白代表「所有列」，
#    c(1,3,5) 代表第 1 欄 Sepal.Length、第 3 欄 Petal.Length、第 5 欄 Species
#  結果 c 是 100 列 × 3 欄
#  （提醒：這裡用 c 當變數名稱，和函數 c() 同名，雖然能執行但容易混淆）

# ------------------------------------------------------------
# 第二部分：認識 tidyverse 與安裝 dplyr
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
# 第三部分：dplyr 的五個核心動作
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
# 第四部分：管線運算子 %>%
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
# - 忘記先 library(dplyr)：會出現「找不到函數 "filter"」或用到 stats 的 filter
#
# 練習題
# 1. 找出 Petal.Length 大於 5 的花，只顯示 Species 和 Petal.Length 兩欄
# 2. 計算每個品種的 Petal.Width 最大值
# 3. 新增一欄 ratio = Petal.Length / Petal.Width，並由大到小排序
