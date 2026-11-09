# ============================================================
# 5-3 單純貝氏分類器 (Naive Bayes)：iris 與 diamonds
# ============================================================
# 【什麼是單純貝氏？】
#   用「機率」來分類：給定一朵花的尺寸，算出它是每個品種的機率，挑機率最高的。
#   計算時用到貝氏定理，並「單純地」假設每個特徵彼此獨立（naive 的由來），
#   雖然這個假設常常不成立，但方法簡單、速度快，效果常常不錯。
#
# 這個範例教你：
#   1. 把資料切成 80% 訓練集、20% 測試集
#   2. 用 e1071 套件的 naiveBayes() 建模、預測
#   3. 用 caret 套件的 confusionMatrix() 計算正確率等評估指標
#   4. 比較同樣方法在「容易分類」(iris) 和「很難分類」(diamonds) 資料上的差別
#
# 說明：#> 是 R 4.6.1 實際執行的結果。因為有 set.seed(2025)，每次執行結果都相同。
# ============================================================

if (!require("ggplot2")) install.packages("ggplot2")
library(ggplot2)
#  這裡載入 ggplot2 是為了使用它內建的 diamonds 資料
if (!require("caret")) install.packages("caret")
library(caret)
#  caret：提供 confusionMatrix() 等模型評估工具
if (!require("e1071")) install.packages("e1071")
library(e1071 )
#  e1071：提供 naiveBayes()、svm() 等演算法
########################
set.seed(2025)
#  固定亂數種子，讓抽樣結果每次都相同

# ------------------------------------------------------------
# 第一部分：iris 資料
# ------------------------------------------------------------
train.index = sample(x=1:nrow(iris), size=ceiling(0.8*nrow(iris) )) #抽樣8/2
#  從 1~150 隨機抽出 80% = 120 個列號
#  ceiling() 是無條件進位，確保是整數
train_set = iris[train.index,]  #retrieve the training set
#  訓練集：120 列，用來建立模型
test_set = iris[-train.index,]  #retrieve the test set
#  測試集：剩下 30 列，模型沒看過，用來檢驗預測能力

NBModel=naiveBayes(Species ~., data=train_set)  #build the model
#  公式 Species ~ . ：用其他所有欄位預測 Species
NBModel                                         #show the model
#> A-priori probabilities:
#> Y
#>     setosa versicolor  virginica
#>  0.3333333  0.3083333  0.3583333
#  事前機率：訓練集中各品種所佔的比例
#> Conditional probabilities:
#>             Petal.Length
#> Y                [,1]      [,2]
#>   setosa     1.445000 0.1723889
#>   versicolor 4.243243 0.4616038
#>   virginica  5.516279 0.5463865
#>  ...（其他 3 個特徵省略）...
#  條件機率：每個品種在各特徵上的分布。數字特徵假設是常態分配，
#  [,1] 是平均數、[,2] 是標準差。例如 setosa 的花瓣長度平均 1.445，明顯比其他兩種短

result=predict(NBModel,test_set)                #prediction
result
#  30 朵測試花的預測品種
summary(result)
#  各品種被預測了幾次
#>     setosa versicolor  virginica
#>         10         12          8
table(test_set$Species,result)
#  混淆矩陣：列 = 真實品種，欄 = 預測品種
#>             result
#>              setosa versicolor virginica
#>   setosa         10          0         0
#>   versicolor      0         12         1
#>   virginica       0          0         7
#  只有 1 朵 versicolor 被誤判成 virginica，30 朵中對 29 朵

# give a detail of confusion matrix and evaluation
conf <- caret::confusionMatrix(data=result, reference = test_set$Species)
#  data = 預測結果，reference = 真實答案
conf
#  注意：confusionMatrix 的表格方向和上面的 table() 相反：列 = 預測 (Prediction)，欄 = 真實 (Reference)
#> Confusion Matrix and Statistics
#>             Reference
#> Prediction   setosa versicolor virginica
#>   setosa         10          0         0
#>   versicolor      0         12         0
#>   virginica       0          1         7
#> Overall Statistics
#>                Accuracy : 0.9667
#>                  95% CI : (0.8278, 0.9992)
#>     No Information Rate : 0.4333
#>     P-Value [Acc > NIR] : 5.119e-10
#>                   Kappa : 0.949
#>  Mcnemar's Test P-Value : NA
#> Statistics by Class:
#>                      Class: setosa Class: versicolor Class: virginica
#> Sensitivity                 1.0000            0.9231           1.0000
#> Specificity                 1.0000            1.0000           0.9565
#>  ...（省略）...
#  Accuracy 正確率 = 29 / 30 = 96.67%
#  No Information Rate = 0.4333：如果每次都猜「最多的那個品種」(versicolor 13/30)，正確率是 43%
#  P-Value [Acc > NIR] 很小 → 模型明顯比亂猜好
#  Sensitivity 敏感度（召回率）：真的是這個品種的花，有多少被正確找出來
#    versicolor 0.9231 = 12 / 13
#  Specificity 特異度：不是這個品種的花，有多少被正確排除

#95% CI 百分之九十五信賴區間
#No Information Rate 隨機猜正確率
#P-Value [Acc > NIR] 檢驗Acc 是否顯著與隨機猜有所不同
#Kappa between -1 to 1 資料集是否平衡
#Mcnemar's Test P-Value 相依樣本卡方檢定，兩組間成對個案的類別相互改變
#其它請見help
#  【補充】Kappa 更精確的意思是：「扣掉碰巧猜對的部分之後」模型和真實答案的一致程度，
#   1 = 完全一致，0 = 和亂猜一樣。0.949 代表非常好
?caret::confusionMatrix
#  打開 confusionMatrix 的說明文件

# ------------------------------------------------------------
# 第二部分：diamonds 資料（用其他欄位預測鑽石顏色）
# ------------------------------------------------------------
########################
### try the diamonds
########################
train.index = sample(x=1:nrow(diamonds), size=ceiling(0.8*nrow(diamonds) )) #抽樣8/2
train_set = diamonds[train.index,]
test_set = diamonds[-train.index,]
#  diamonds 共 53940 顆：訓練集 43152 顆、測試集 10788 顆
NBModel=naiveBayes(color ~., data=train_set)
#  用重量、切工、淨度、價格、尺寸等欄位，預測顏色 (D~J 共 7 級)
NBModel
#  類別特徵（cut、clarity）會顯示「在每種顏色下，各類別出現的比例」；
#  數字特徵顯示平均數和標準差

result=predict(NBModel,test_set)
result
#  10788 個預測結果，很長
summary(result)
#>    D    E    F    G    H    I    J
#> 1061 4563  993 1359 1165  480 1167
#  模型特別喜歡猜 E
table(test_set$color,result)
# give a detail of confusion matrix and evaluation
conf <- confusionMatrix(data=result, reference = test_set$color)
conf
#> Overall Statistics
#>                Accuracy : 0.2192
#>                  95% CI : (0.2114, 0.2272)
#>     No Information Rate : 0.2111
#>     P-Value [Acc > NIR] : 0.01983
#>                   Kappa : 0.0714
#  正確率只有 21.9%，和「全部猜最多的顏色 G」的 21.1% 差不多，Kappa 接近 0
#  結論：鑽石的重量、切工、價格等，幾乎無法用來判斷顏色。
#  這不是程式寫錯，而是資料本身就沒有足夠的資訊——
#  選對「有預測力的特徵」比選演算法更重要

# ============================================================
# 重點整理
# ============================================================
# 1. 先切訓練集 / 測試集，用「沒看過的資料」評估模型
# 2. naiveBayes(Y ~ ., data = 訓練集) 建模，predict(模型, 測試集) 預測
# 3. confusionMatrix(data = 預測, reference = 真實) 看正確率、Kappa 等指標
# 4. 正確率要和 No Information Rate（亂猜的正確率）比較，才知道模型有沒有用
#
# 練習題
# 1. 把 set.seed(2025) 改成其他數字，iris 的正確率會變嗎？
# 2. 只用 Petal.Length 和 Petal.Width 兩個特徵建模：naiveBayes(Species ~ Petal.Length + Petal.Width, ...)
# 3. 用 naiveBayes 預測 diamonds 的 cut（切工），正確率是多少？
