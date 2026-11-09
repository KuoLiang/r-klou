#https://topepo.github.io/caret/model-training-and-tuning.html
# ============================================================
# 5-8 caret 套件：分層抽樣與多種分類模型的比較
# ============================================================
# caret（Classification And REgression Training）把上百種演算法包裝成同一種寫法：
#   train(公式, data = 資料, method = "演算法名稱")
# 換演算法只要改 method，不用學每個套件不同的寫法。
#
# 這個範例教你：
#   1. 用 dummyVars() 產生虛擬變數
#   2. 比較「一般隨機抽樣」和「分層抽樣」createDataPartition()
#   3. 用同一份資料訓練 C5.0、kNN、SVM 三種模型，比較預測結果
#
# 說明：#> 是 R 4.6.1 實際執行的結果。
#       需要的套件：caret、C50、kernlab（svmPoly 用）
# ============================================================
library(caret)
iris
set.seed(2026)

# ------------------------------------------------------------
# 第一部分：dummyVars() 產生虛擬變數
# ------------------------------------------------------------
dummy <- dummyVars(formula = ~ ., data = iris)
dummy
#  dummyVars()：建立「轉換規則」，把所有類別欄位轉成 0/1 虛擬變數
#  公式 ~ . 代表處理所有欄位（數字欄位保持不變）
#  （這裡把結果取名為 dummy，和 dummy 套件的函數同名，容易混淆）
pred <- predict(dummy, newdata = iris)
#  用 predict() 套用轉換規則，產生新的資料（矩陣）
pred
#>     Sepal.Length Sepal.Width Petal.Length Petal.Width Species.setosa Species.versicolor ...
#> 1            5.1         3.5          1.4         0.2              1                  0 ...
#>  ...（省略）...
#  Species 變成 3 欄：Species.setosa、Species.versicolor、Species.virginica

# ------------------------------------------------------------
# 第二部分：一般隨機抽樣 vs 分層抽樣
# ------------------------------------------------------------
###############
#作為抽樣用途
#it preserves the proportion of the categories in Y variable
###############
### 傳統隨機抽,可能各品種代表性不一致
set.seed(2020)
train.index = sample(x=1:nrow(iris), size=ceiling(0.8*nrow(iris) )) #抽樣8/2
train_set = iris[train.index,]
test_set = iris[-train.index,]
nrow(train_set)
#> [1] 120
table(train_set$Species)
#>     setosa versicolor  virginica
#>         41         36         43
#  完全隨機抽樣：三個品種的數量不一樣（36 ~ 43）
###############
### caret::createDataPartition 依三種品種各抽 80%
# Y 為 iris$Species
###############
set.seed(2020)
index2 <- createDataPartition(iris$Species, p = 0.8, list = F)
#  分層抽樣 (stratified sampling)：在「每個品種內」各抽 80%
#  p = 0.8 抽 80%；list = F 回傳矩陣（而不是 list），方便拿來當列號
index2
#  被抽中的列號，欄名是 Resample1
train_set <- iris[index2,]
test_set <- iris[-index2,]
nrow(train_set)
#> [1] 120
table(train_set$Species)
#>     setosa versicolor  virginica
#>         40         40         40
#  每個品種剛好 40 朵（50 × 80%），訓練集和原始資料的比例相同
#  類別數量不平均的資料（例如詐騙偵測，正常交易遠多於詐騙）特別需要分層抽樣

# ------------------------------------------------------------
# 第三部分：訓練三種模型
# ------------------------------------------------------------
###############
#c50
###############
model_c50 = train(Species ~ ., data=train_set, method='C5.0')
#  沒有指定 trControl，預設用 bootstrap 重抽樣 25 次來評估各參數組合
#  執行時會出現很多 'trials' should be <= 7 ... 的警告，是 boosting 提早停止，可以忽略
model_c50
#> Resampling: Bootstrapped (25 reps)
#>   model  winnow  trials  Accuracy   Kappa
#>   rules  FALSE    1      0.9281490  0.8913297
#>   rules  FALSE   10      0.9411189  0.9110599
#>  ...（共 12 種組合，省略）...
#> The final values used for the model were trials = 10, model = rules and winnow = FALSE.
#  bootstrap：每次從訓練集「可重複地」抽出 120 筆來訓練，沒被抽到的拿來測試
plot(model_c50)
predicted_c50 <- predict(model_c50, test_set, type="raw")
#  caret 模型用 type = "raw" 取得預測類別；type = "prob" 則是各類別的機率
predicted_c50
#>  [1] setosa     setosa     setosa     versicolor setosa     setosa     setosa
#>  [8] setosa     versicolor setosa     versicolor ...
#  測試集前 10 朵都是 setosa，但第 4、9 朵被預測成 versicolor
###############
#knn
###############
model_knn = train(Species ~ ., data=train_set, method='knn')
model_knn
#>   k  Accuracy   Kappa
#>   5  0.9483010  0.9212961
#>   7  0.9519400  0.9268410
#>   9  0.9547311  0.9310969
#> The final value used for the model was k = 9.
plot(model_knn)
predicted_knn <- predict(model_knn, test_set, type="raw")
predicted_knn
###############
#svm
###############
model_svm = train(Species ~ ., data=train_set, method='svmPoly')
#  svmPoly：多項式核的 SVM（使用 kernlab 套件），會調整 degree 次方、scale、C 三個參數
model_svm
#> The final values used for the model were degree = 3, scale = 0.1 and C = 1.
plot(model_svm)
predicted_svm <- predict(model_svm, test_set, type="raw")
predicted_svm
###############

comp=cbind(predicted_c50,predicted_knn,predicted_svm)
comp
#  把三個模型的預測並排比較
#  注意：cbind() 把 factor 合併時會變成「數字代碼」：1 = setosa、2 = versicolor、3 = virginica
#>       predicted_c50 predicted_knn predicted_svm
#>  [1,]             1             1             1
#>  ...
#>  [4,]             2             1             1      ← 只有 C5.0 猜錯
#>  ...（共 30 列，省略）...
#  想看品種名稱，改用資料框：data.frame(predicted_c50, predicted_knn, predicted_svm)
#  這次的結果：C5.0 對 27 / 30 (90%)，kNN 和 SVM 都對 29 / 30 (96.7%)
#  比較正確率：confusionMatrix(predicted_c50, test_set$Species)

# ============================================================
# 重點整理
# ============================================================
# | 函數                                   | 用途                              |
# |----------------------------------------|-----------------------------------|
# | dummyVars(~ ., data) + predict()       | 產生虛擬變數                      |
# | createDataPartition(Y, p = 0.8)        | 分層抽樣，保持各類別比例          |
# | train(Y ~ ., data, method = "...")     | 訓練模型，自動調參數              |
# | predict(模型, 新資料, type = "raw")    | 預測類別（"prob" 為機率）         |
#
# 常用的 method："C5.0"、"rpart"、"knn"、"svmPoly"、"svmRadial"、"nnet"、"rf"、"nb"
# 完整清單：names(getModelInfo())
#
# 練習題
# 1. 用 confusionMatrix() 分別計算三個模型在測試集的正確率
# 2. 加上 trControl = trainControl(method = "cv", number = 10) 改用 10 折交叉驗證
# 3. 再加入一個 method = "rf"（隨機森林，需要 randomForest 套件），和其他三個比較
