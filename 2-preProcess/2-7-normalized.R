# ============================================================
# 2-7 資料正規化 (Normalization)
# ============================================================
# 為什麼要正規化？
#   不同欄位的單位和範圍不同，例如身高 150~190、體重 40~100。
#   很多機器學習方法（例如 KNN、類神經網路）會被「數字比較大」的欄位主導，
#   所以要先把各欄縮放到相同範圍，例如 0~1。
#
# 最常見的 Min-Max 正規化公式：
#   新值 = (原值 - 最小值) / (最大值 - 最小值)   → 結果在 0 ~ 1 之間
#
# 這個範例教你：
#   1. 用 apply() 計算每一欄（或每一列）的最大值、最小值、平均
#   2. 用 scale() 做正規化
#
# 說明：#> 是 R 4.6.1 實際執行的結果；輸出太長的部分只列前幾行。
# ============================================================

install.packages('MASS')
#  安裝 MASS 套件
#  （MASS 是 R 內建就有的套件，通常不需要安裝；而且這個範例其實沒有用到 MASS 的函數。
#   每次執行都安裝會浪費時間，建議改成 if (!require("MASS")) install.packages("MASS")）
library(MASS)
iris_data = iris[1:4]
#  只取 iris 的第 1~4 欄（四個數字欄），去掉第 5 欄 Species（文字類別不能正規化）
#  資料框[1:4] 只寫一個數字範圍時，代表「取第 1~4 欄」

# ------------------------------------------------------------
# 第一部分：apply() 逐欄或逐列計算
# ------------------------------------------------------------
# 【補充】apply(資料, 方向, 函數)
#   方向 = 1：對「每一列」（橫的）計算
#   方向 = 2：對「每一欄」（直的）計算
#   記法：[列, 欄]，列在第 1 個位置、欄在第 2 個位置

iris_maxs = apply(iris_data,2,max) #2 表示各欄最大值
iris_maxs
#> Sepal.Length  Sepal.Width Petal.Length  Petal.Width
#>          7.9          4.4          6.9          2.5

iris_mins = apply(iris_data,1,min) #1 表示各列最小值
iris_mins
#  每一朵花（每一列）四個數字中的最小值 → 150 個數字
#  這裡只是示範方向 1 和 2 的差別，下一行會用方向 2 重新計算
#>   [1] 0.2 0.2 0.2 0.2 0.2 0.4 0.3 0.2 0.2 0.1 0.2 0.2 0.1 0.1 0.2 0.4 0.4 0.3
#>  ...（省略）...
#> [145] 2.5 2.3 1.9 2.0 2.3 1.8

iris_mins = apply(iris_data,2,min) #2 表示各欄最小值
iris_mins
#> Sepal.Length  Sepal.Width Petal.Length  Petal.Width
#>          4.3          2.0          1.0          0.1

iris_means = apply(iris_data,2,mean) #2 表示各欄均值
iris_means
#> Sepal.Length  Sepal.Width Petal.Length  Petal.Width
#>     5.843333     3.057333     3.758000     1.199333

# ------------------------------------------------------------
# 第二部分：scale() 正規化
# ------------------------------------------------------------
# 【補充】scale(資料, center = 中心點, scale = 縮放量)
#   計算方式：(原值 - center) / scale，對每一欄分別計算
#   這裡的 scale 都用「最大值 - 最小值」（全距），所以結果的範圍寬度都是 1
###
iris_scaled = scale(iris_data,center=iris_mins,
                    scale=iris_maxs-iris_mins)
iris_scaled #a normalized matirx 0 to 1 因為以 min為參考點
#  center = 最小值 → 這就是 Min-Max 正規化，結果在 0 ~ 1
#  最小的值變成 0，最大的值變成 1
#>        Sepal.Length Sepal.Width Petal.Length Petal.Width
#>   [1,]   0.22222222  0.62500000   0.06779661  0.04166667
#>   [2,]   0.16666667  0.41666667   0.06779661  0.04166667
#>  ...（省略）...
#  輸出最後會附上兩個屬性 (attr)，記錄計算時用的中心點和縮放量：
#> attr(,"scaled:center")
#> Sepal.Length  Sepal.Width Petal.Length  Petal.Width
#>          4.3          2.0          1.0          0.1
#> attr(,"scaled:scale")
#> Sepal.Length  Sepal.Width Petal.Length  Petal.Width
#>          3.6          2.4          5.9          2.4
#  注意：scale() 的結果是「矩陣」(matrix)，不是資料框，所以列名稱顯示為 [1,]、[2,]
#
iris_scaled = scale(iris_data,center=iris_maxs,
                    scale=iris_maxs-iris_mins)
iris_scaled #a normalized matirx 0 to -1因為以 max為參考點
#  center = 最大值 → 最大的值變成 0，最小的值變成 -1，結果在 -1 ~ 0
#>        Sepal.Length Sepal.Width Petal.Length Petal.Width
#>   [1,]  -0.77777778 -0.37500000  -0.93220339 -0.95833333
#>   [2,]  -0.83333333 -0.58333333  -0.93220339 -0.95833333
#>  ...（省略）...
#
iris_scaled = scale(iris_data,center=iris_mean,
                    scale=iris_maxs-iris_mins)
#  ⚠️ 錯誤：找不到物件 'iris_mean'
#     原因：上面建立的變數叫 iris_means（有 s），這裡少打了 s
#     修正：center = iris_means
#     出錯時 iris_scaled 不會被更新，下一行印出的會是「上一次」-1 ~ 0 的結果
iris_scaled #a normalized matirx -0.5 to 0.5因為以 mean為參考點
#  修正後：center = 平均值 → 結果以 0 為中心，寬度為 1
#  實際範圍不一定剛好是 -0.5 ~ 0.5，要看資料是否對稱。
#  以 iris 為例，四欄大約落在 -0.47 ~ 0.57 之間（例如 Sepal.Length 是 -0.43 ~ 0.57）
#  這種方法叫「平均正規化」(mean normalization)
iris_scaled = as.data.frame(iris_scaled)
#  把矩陣轉回資料框，之後才能用 $ 取欄位、用 dplyr 處理
######

# ============================================================
# 重點整理
# ============================================================
# | center 用什麼 | 結果範圍            | 名稱                  |
# |---------------|---------------------|-----------------------|
# | 最小值        | 0 ~ 1               | Min-Max 正規化（最常用）|
# | 最大值        | -1 ~ 0              | —                     |
# | 平均值        | 以 0 為中心，寬度 1 | 平均正規化            |
#
# 補充：scale(iris_data) 不加參數時，center = 平均、scale = 標準差，
#       這叫「標準化」(standardization, z-score)，結果平均為 0、標準差為 1。
#
# 練習題
# 1. 修正 iris_mean 的錯字後重新執行，用 summary(iris_scaled) 查看各欄範圍
# 2. 用 scale(iris_data) 做 z-score 標準化，再用 apply(結果, 2, sd) 確認標準差都是 1
# 3. apply(iris_data, 1, max) 算的是什麼？會得到幾個數字？
