##########################################
#Editor: Kuo-Liang Ou
#Affililation: National Tsing Hua University ILST
##########################################
# ============================================================
# 4-3 線性迴歸：用花瓣、花萼寬度預測花萼長度（iris 資料）
# ============================================================
# 線性迴歸 (linear regression) 找出一條「最適合」的直線（或平面），
# 用幾個已知的變數（自變數 X）來預測另一個變數（依變數 Y）：
#   Sepal.Length = 截距 + b1 × Sepal.Width + b2 × Petal.Length + b3 × Petal.Width
#
# 這個範例教你：
#   1. 用 lm() 建立迴歸模型，用 summary() 解讀結果
#   2. 用 predict() 做預測
#   3. 把資料切成「訓練集」和「測試集」，用沒看過的資料檢驗模型
#
# 說明：#> 是 R 4.6.1 實際執行的結果。sample() 是隨機抽樣，
#       第一部分的 test_index 每次執行都不同（第二部分有 set.seed，所以結果固定）。
# ============================================================

data("iris")

# ------------------------------------------------------------
# 第一部分：建立迴歸模型
# ------------------------------------------------------------
my_iris=lm(Sepal.Length ~ Sepal.Width+Petal.Length+Petal.Width, data=iris)
#  lm = linear model（線性模型）
#  公式 Y ~ X1 + X2 + X3：~ 左邊是要預測的變數，右邊是用來預測的變數，用 + 連接

summary(my_iris)
#> Residuals:
#>      Min       1Q   Median       3Q      Max
#> -0.82816 -0.21989  0.01875  0.19709  0.84570
#> Coefficients:
#>              Estimate Std. Error t value Pr(>|t|)
#> (Intercept)   1.85600    0.25078   7.401 9.85e-12 ***
#> Sepal.Width   0.65084    0.06665   9.765  < 2e-16 ***
#> Petal.Length  0.70913    0.05672  12.502  < 2e-16 ***
#> Petal.Width  -0.55648    0.12755  -4.363 2.41e-05 ***
#> Residual standard error: 0.3145 on 146 degrees of freedom
#> Multiple R-squared:  0.8586,	Adjusted R-squared:  0.8557
#> F-statistic: 295.5 on 3 and 146 DF,  p-value: < 2.2e-16
#
#  【如何解讀】
#  Residuals 殘差：實際值 - 預測值，中位數接近 0、上下大致對稱是好的
#  Coefficients 係數：
#    Estimate = 係數。例如 Petal.Length 是 0.709：
#      其他變數不變時，花瓣長度每增加 1 cm，預測的花萼長度增加 0.709 cm
#    Petal.Width 是負的 -0.556：花瓣寬度和花瓣長度高度相關（相關係數 0.96），
#      兩個一起放進模型時，係數可能和直覺相反，這叫「共線性」，解讀時要小心
#    Pr(>|t|) = 這個係數是否顯著不為 0；四個都有 *** 表示都很顯著
#  R-squared (R²) = 0.8586：模型解釋了 85.9% 的花萼長度變異，越接近 1 越好
#  Adjusted R-squared：考慮變數個數後調整的 R²，比較不同模型時用這個
#  F-statistic 的 p 值 < 2.2e-16：整個模型顯著

# ------------------------------------------------------------
# 第二部分：用模型預測
# ------------------------------------------------------------
test_index = sample(nrow(iris),15)
#  sample(150, 15)：從 1~150 隨機抽出 15 個不重複的列號

test_index
#> [1] 121  38  45 111  91 108 133  31  44  58  98  88  79  93 110   ← 每次執行都不同

test_set = iris[test_index,]
#  取出這 15 列當作要預測的資料

test_set
#>     Sepal.Length Sepal.Width Petal.Length Petal.Width    Species
#> 121          6.9         3.2          5.7         2.3  virginica
#> 38           4.9         3.6          1.4         0.1     setosa
#>  ...（省略）...

my_predict = predict(my_iris,test_set)
#  predict(模型, 新資料)：用模型和新資料的 X，算出預測的 Y（花萼長度）

my_predict
#>      121       38       45      111       91      108      133       31
#> 6.700818 5.136148 5.453936 6.442284 6.000576 7.209288 6.425219 4.896907
#>  ...（省略）...
#  第 121 朵花實際花萼長度 6.9，預測 6.70，很接近
#  注意：這 15 朵花本來就在建模時用過了（模型「看過答案」），
# 所以預測得準不代表模型好。正確做法見下一部分。

###
# ------------------------------------------------------------
# 第三部分：切分訓練集與測試集（正確的做法）
# ------------------------------------------------------------
# 【補充】機器學習的基本流程：
#   訓練集 (training set)：用來建立模型（例如 80% 的資料）
#   測試集 (test set)    ：模型「沒看過」的資料，用來檢驗預測能力（剩下 20%）

set.seed(100) # setting seed to reproduce results of random sampling
#  設定亂數種子：之後的隨機抽樣每次執行結果都相同，方便重現和比較

trainingRowIndex <- sample(1:nrow(iris), 0.8*nrow(iris)) # row indices for training data
#  從 150 列隨機抽出 0.8 × 150 = 120 列的列號

trainingData <- iris[trainingRowIndex, ] # model training data
#  訓練集：120 列

testData <- iris[-trainingRowIndex, ] # test data
#  負號 = 去掉訓練集的列 → 剩下 30 列當測試集



lmMod <- lm(Sepal.Length ~ Sepal.Width+Petal.Length+Petal.Width, data=trainingData) # build the model
#  只用訓練集建立模型

Pred <- predict(lmMod, testData) # predict
#  用模型預測測試集的花萼長度

Pred
#>        1        6       10       11       13       21       33       34
#> 5.021408 5.392546 4.872926 5.221847 4.738774 5.158714 5.535798 5.485419
#>  ...（共 30 個，省略）...
#  上面一行是列號（第幾朵花），下面一行是預測的花萼長度
#
#  【接下來可以做的事】比較預測值和實際值，評估模型好壞：
#    plot(testData$Sepal.Length, Pred)                 ← 點越接近對角線越準
#    sqrt(mean((testData$Sepal.Length - Pred)^2))      ← RMSE 均方根誤差，越小越好

# ============================================================
# 重點整理
# ============================================================
# | 步驟         | 函數                          |
# |--------------|-------------------------------|
# | 建立模型     | lm(Y ~ X1 + X2, data = 資料)  |
# | 看結果       | summary(模型)                 |
# | 預測         | predict(模型, 新資料)         |
# | 固定隨機結果 | set.seed(數字)                |
# | 切分資料     | sample() 抽列號，負號取剩下的 |
#
# summary() 要看的三件事：係數 Estimate、係數的 p 值、R-squared
#
# 練習題
# 1. 計算第三部分的 RMSE（見上方提示）
# 2. 只用 Petal.Length 一個變數預測 Sepal.Length，R-squared 會變多少？
# 3. 把 set.seed(100) 改成其他數字，RMSE 會改變嗎？為什麼？
