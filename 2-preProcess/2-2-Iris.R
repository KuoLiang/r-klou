# ============================================================
# 2-2 資料框篩選入門（使用 iris 鳶尾花資料）
# ============================================================
# iris 是 R 內建的資料集：150 朵鳶尾花，5 個欄位
#   Sepal.Length 花萼長度、Sepal.Width 花萼寬度、
#   Petal.Length 花瓣長度、Petal.Width 花瓣寬度、
#   Species 品種（setosa、versicolor、virginica 各 50 朵）
## ============================================================

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

