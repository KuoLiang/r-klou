# ============================================================
# 5-6 K 最近鄰 (k-Nearest Neighbors, kNN)：iris 分類
# ============================================================
# 【什麼是 kNN？】
#   「物以類聚」：要判斷一朵新花的品種，就找訓練資料中「距離它最近的 k 朵花」，
#   看這 k 朵花中哪個品種最多，就猜那個品種（多數決）。
#   距離通常用歐氏距離（把 4 個尺寸當作座標，算直線距離）。
#   kNN 不需要先「訓練」模型，每次預測時直接和所有訓練資料比較。
#
# 這個範例教你：
#   1. 用 class 套件的 knn() 做分類
#   2. 比較 k = 3 和 k = 100 的差別
#   3. 用 caret 自動找出最好的 k
#
# 說明：#> 是 R 4.6.1 實際執行的結果。因為有 set.seed(2025)，抽樣結果固定。
#       （knn 遇到票數相同時會隨機決定，極少數情況結果可能略有不同）
# ============================================================

if (!require("class")) install.packages("class")
library(class)  #various classfication including knn

set.seed(2025)
train.index = sample(x=1:nrow(iris),
                     size=ceiling(0.8*nrow(iris) )) #抽樣8/2
train_set = iris[train.index,]
test_set = iris[-train.index,]
#  訓練集 120 朵、測試集 30 朵（和 5-3 的切法相同）

# ------------------------------------------------------------
# 第一部分：k = 3
# ------------------------------------------------------------
###
#需要三個 object 當參數
###
iris.knn <- knn(
    train_set[,1:4], #variables of training set
    test_set[,1:4],  #variables of testing set
    train_set[,5],   #factor of true class of training set
    k = 3, prob = T) # prob 是否回傳機率值
#  knn(訓練集特徵, 測試集特徵, 訓練集答案, k = 鄰居數)
#  和其他方法不同：knn() 一步就直接得到預測結果，沒有另外的「模型」物件
#  prob = T：同時回傳「獲勝品種的得票比例」
iris.knn
#>  [1] setosa     setosa     setosa     setosa     setosa     setosa     setosa
#>  [8] setosa     setosa     setosa     versicolor versicolor versicolor virginica
#>  ...（省略）...
#> attr(,"prob")
#>  [1] 1.00 1.00 1.00 ... 0.75 1.00
#  attr(,"prob") 是得票比例：1.00 代表最近的 3 朵全部是同一品種；
#  0.75 出現在票數有平手時（knn 會把距離相同的鄰居也算進來）
summary(iris.knn)
#>     setosa versicolor  virginica
#>         10         11          9
result = cbind(iris.knn,test_set[5])  #把預測的品種與真實的品種比較
#  cbind：把預測結果和真實品種左右並排
result
#>       iris.knn    Species
#> 1       setosa     setosa
#>  ...（省略）...
#> 71   virginica versicolor      ← 預測錯誤
#> 84   virginica versicolor      ← 預測錯誤
#>  ...（省略）...
table(result)
#  table() 遇到兩欄的資料框，會直接做交叉表（混淆矩陣）：列 = 預測，欄 = 真實
#>             Species
#> iris.knn     setosa versicolor virginica
#>   setosa         10          0         0
#>   versicolor      0         11         0
#>   virginica       0          2         7
#  30 朵中對 28 朵，正確率 93.3%

# ------------------------------------------------------------
# 第二部分：k = 100（k 太大會怎樣？）
# ------------------------------------------------------------
############
#換個參數 k=100
############
iris.knn <- knn(
    train_set[,1:4],
    test_set[,1:4],
    train_set[,5],
    k = 100, prob = F)
#  每次找最近的 100 朵花投票。但訓練集只有 120 朵，每個品種才約 40 朵，
#  100 個鄰居幾乎包含所有花，「最近」已經沒有意義了
iris.knn
summary(iris.knn)
#>     setosa versicolor  virginica
#>         11          2         17
result = cbind(iris.knn,test_set[5])
result
table(result)
#>             Species
#> iris.knn     setosa versicolor virginica
#>   setosa         10          1         0
#>   versicolor      0          2         0
#>   virginica       0         10         7
#  正確率掉到 19 / 30 ≈ 63%：13 朵 versicolor 只有 2 朵猜對，大多被誤判成 virginica
#  （訓練集中 virginica 最多 43 朵，鄰居一多，就容易被數量多的品種「灌票」）
#  結論：k 太小容易受個別雜訊影響，k 太大會變得模糊，要找適中的值

# ------------------------------------------------------------
# 第三部分：用 caret 找最好的 k
# ------------------------------------------------------------
##########
# k 應該多少呢？
##########
if (!require("caret")) install.packages("caret")
library("caret")
#The caret package contains functions to streamline
#the model training process for complex regression and
#classification problems
#  caret = Classification And REgression Training，
#  提供統一的介面來訓練、調整各種模型

ctrl <- caret::trainControl(method="repeatedcv",repeats = 10)
#repeated k-fold cross-validation
# 【補充】交叉驗證 (cross-validation, cv)：
#   把資料分成 10 份，輪流用 9 份訓練、1 份測試，做 10 次後取平均正確率。
#   repeatedcv + repeats = 10：整個流程重複 10 次（每次分法不同），結果更穩定
#   這樣每筆資料都當過測試資料，比只切一次訓練 / 測試集更可靠
knnFit <- caret::train(Species ~ . ,data = iris, method = "knn",
                       trControl = ctrl) #using the ctrl above
#  train(公式, 資料, method = 演算法, trControl = 驗證方式)
#  caret 預設會試 3 個 k 值 (5, 7, 9)，用交叉驗證比較哪個最好

#Output of kNN fit
knnFit
#> Resampling: Cross-Validated (10 fold, repeated 10 times)
#> Summary of sample sizes: 135, 135, 135, 135, 135, 135, ...
#> Resampling results across tuning parameters:
#>   k  Accuracy   Kappa
#>   5  0.9653333  0.948
#>   7  0.9653333  0.948
#>   9  0.9666667  0.950
#> The final value used for the model was k = 9.
#  每次用 135 朵訓練（150 的 9/10）；k = 9 的平均正確率最高 (96.7%)
#  想試更多 k 值：train(..., tuneGrid = data.frame(k = 1:20))
plot(knnFit)
#  橫軸 k、縱軸交叉驗證正確率的折線圖

# ============================================================
# 重點整理
# ============================================================
# | 項目         | 說明                                              |
# |--------------|---------------------------------------------------|
# | knn()        | knn(訓練特徵, 測試特徵, 訓練答案, k = 鄰居數)     |
# | k 太小       | 容易被個別雜訊影響                                |
# | k 太大       | 太模糊，容易被數量多的類別主導                    |
# | 交叉驗證     | trainControl(method = "repeatedcv")，結果較可靠   |
# | 自動找參數   | caret::train(..., method = "knn")                 |
#
# 提醒：kNN 用距離計算，如果各特徵的單位、範圍差很多，要先正規化（見 2-7 範例）
#
# 練習題
# 1. 試試 k = 1、5、15，比較混淆矩陣
# 2. 用 train(..., tuneGrid = data.frame(k = 1:30)) 找出最佳的 k，並畫出 plot(knnFit)
# 3. 加上 preProcess = c("center", "scale") 讓 caret 自動標準化，正確率有改變嗎？
