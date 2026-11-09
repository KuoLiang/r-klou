# ============================================================
# 5-2 決策樹進階：rpart 與 C5.0、caret 調參數、條件推論森林
# ============================================================
# 這個範例教你：
#   1. 兩種決策樹演算法：
#      rpart（CART 演算法，用 Gini 指數選擇分割）
#      C5.0 （用資訊熵 entropy 選擇分割）
#   2. 用公式 Y ~ X 或分開指定 x、y 兩種寫法建模
#   3. 用 caret 的交叉驗證找出最好的參數
#   4. cforest（條件推論隨機森林）：很多棵樹一起投票
#
# 資料：從 diamonds 隨機抽 1000 顆鑽石，試著預測顏色 (color)；另外也用 iris。
#
# 說明：#> 是 R 4.6.1 實際執行的結果。檔案開頭有 set.seed(2025)，
#       從頭依序執行時，抽樣結果會和下面相同。
# ============================================================

if (!require("ggplot2")) install.packages("ggplot2")
library(ggplot2)

data(diamonds)
#3-5-diamonds-plot.R
#  diamonds 資料的介紹請見 3-5 範例

set.seed(2025) #固定的亂數
sample_index <- sample(1:nrow(diamonds), size = 1000)
sample_diamonds <- diamonds[sample_index,]
#  5 萬多顆太多了，先隨機抽 1000 顆來練習，執行比較快

# ------------------------------------------------------------
# 第一部分：rpart 決策樹
# ------------------------------------------------------------
############################################
#first method : rpart with regular expression (based on Gini index)
############################################
#  （這裡的 regular expression 指的是「公式寫法」Y ~ X，不是文字處理用的正規表達式）

if (!require("rpart")) install.packages("rpart")
library(rpart)
if (!require("rpart.plot")) install.packages("rpart.plot")
library(rpart.plot)
#  rpart：建立決策樹；rpart.plot：畫出漂亮的樹狀圖

model1 <- rpart(color ~., data = sample_diamonds, method = 'class')
#  用其他所有欄位預測顏色；method = 'class' 指定做「分類」（預測類別）
rpart.plot(model1, extra = 106) #Display extra information at the nodes
#  extra = 106：在每個節點顯示「第 2 個類別的機率」和「這個節點佔全部資料的比例」
#  這個設定是給「兩類」問題用的。color 有 7 類，所以會出現警告：
#> Warning: extra=106 but the response has 7 levels (only the 2nd level is displayed)
#  多類別問題建議改用 extra = 104（顯示每一類的機率）
summary(model1)
#  文字版的詳細結果，很長，重點如下：
#>           CP nsplit rel error    xerror       xstd
#> 1 0.01898734      0 1.0000000 1.0000000 0.01630407
#> 2 0.01012658      3 0.9430380 0.9797468 0.01674162
#> 3 0.01000000      5 0.9227848 0.9936709 0.01644474
#  CP（複雜度參數）表：nsplit 是分割次數，rel error 是相對錯誤率（1 = 和完全不分一樣）
#  分了 5 次，錯誤率只降到 0.92 → 這棵樹幾乎沒有預測能力
#> Variable importance
#>       z   carat       y       x   price clarity   depth
#>      23      20      18      18      14       7       1
#  變數重要性：z（深度）、carat（重量）最常被用來分割
#> Node number 1: 1000 observations,    complexity param=0.01898734
#>   predicted class=G  expected loss=0.79  P(node) =1
#>     class counts:   123   178   169   210   164    97    59
#  根節點：1000 顆中 G 色最多 (210)，全部猜 G 會錯 79%
prp(model1) #plot r part model
#  prp() 是另一種比較精簡的樹狀圖畫法

model11 <- rpart(color ~ carat + cut, data = sample_diamonds, method = 'class')
#  只用重量和切工兩個特徵
rpart.plot(model11, extra = 100) # try 106, 104, 100
#  extra = 100：只顯示每個節點佔全部資料的百分比
summary(model11)
#> Variable importance
#> carat   cut
#>    99     1
#  幾乎只用到 carat，切工對判斷顏色幾乎沒幫助
prp(model11)

# ------------------------------------------------------------
# 第二部分：C5.0 決策樹
# ------------------------------------------------------------
############################################
#second method : C50 with regular expression, based on entropy
############################################

if (!require("C50")) install.packages("C50")
library(C50)

model2 <- C5.0(color ~ ., data = sample_diamonds, method = 'class')
model2 <- C5.0(color ~ carat + cut, data = sample_diamonds, method = 'class')
#  C5.0 也可以用公式寫法。method = 'class' 是 rpart 的參數，C5.0 用不到，會被忽略
#  （第二行會蓋掉第一行的結果）


#second method : C50 with x y specific
#  另一種寫法：分開指定 x（特徵）和 y（答案）

input <- sample_diamonds[,c(2,4)] #cut and clarity
#  第 2 欄 cut（切工）、第 4 欄 clarity（淨度）
output <- sample_diamonds$color # color for predict
output <- as.factor(output)
#  確保答案是 factor（diamonds 的 color 本來就是 factor，這行是保險）
model2 <- C5.0(x=input, y=output, method = 'class')

#plot
#plot(model2) # ???? something wrong
#  （x / y 寫法建立的 C5.0 模型，畫圖時有時會出錯；用公式寫法比較穩定）

summary(model2)
#  文字版的樹：
#> Decision tree:
#> clarity in [VVS1-IF]: G (113/82)
#> clarity in [I1-VVS2]:
#> :...clarity = VVS2: F (92/68)
#>     clarity in [I1-VS1]:
#>  ...（省略）...
#  (113/82) 代表這個節點有 113 顆，其中 82 顆猜錯 → 用切工、淨度判斷顏色非常不準

mod1 <- C5.0(Species ~ ., data = iris)
plot(mod1)
#  對照組：用 iris 建 C5.0 樹，畫出來很清楚（見 5-1 範例）

# ------------------------------------------------------------
# 第三部分：預測新資料
# ------------------------------------------------------------
##### prediction

sample_index2 <- sample(1:nrow(diamonds), size = 10)
sample_index2
#> [1] 47834 15697 38092 51705 45602 24413 20427 38589 28649 29571
newcases <- diamonds[sample_index2,-3]
#  隨機抽 10 顆當新資料，-3 去掉第 3 欄 color（假裝不知道答案）
newcases
predicted <- predict(model1, newcases, type="prob")
#  type = "prob"：每顆鑽石屬於 7 種顏色的機率（10 列 × 7 欄）
predicted <- predict(model1, newcases, type="class")
#  type = "class"：直接給出機率最高的顏色（這行蓋掉上一行）

predicted
#>  1  2  3  4  5  6  7  8  9 10
#>  G  G  E  E  G  J  G  E  E  E
#> Levels: D E F G H I J
#  可以用 diamonds$color[sample_index2] 對照真實顏色

# ------------------------------------------------------------
# 第四部分：用 caret 交叉驗證找最佳參數
# ------------------------------------------------------------
################################################
#caret = Classification And REgression Training
#find out the best parameters of classfication and regression
################################################

if (!require("caret")) install.packages("caret")
library(caret)

ctrl <- caret::trainControl(method="repeatedcv",  # cross validation method
                            repeats = 10) #repeated k-fold cross-validation
#  10 折交叉驗證，重複 10 次（說明見 5-6 範例）
C50Fit <- caret::train(Species ~ . ,data = iris, method = "C5.0",
                       trControl = ctrl)
#  caret 會試多種 C5.0 參數組合，用交叉驗證比較
#  執行時會出現很多 'trials' should be <= 3 ... 的警告：
#  意思是提早停止了 boosting（不需要那麼多棵樹），可以忽略
C50Fit
#> Resampling results across tuning parameters:
#>   model  winnow  trials  Accuracy   Kappa
#>   rules  FALSE    1      0.9520000  0.928
#>   rules  FALSE   10      0.9460000  0.919
#>  ...（共 12 種組合，省略）...
#> The final values used for the model were trials = 1, model = rules and winnow = FALSE.
#  三個參數：
#    model  ：tree（樹）或 rules（轉成一條條規則）
#    winnow ：是否先自動挑選特徵
#    trials ：boosting 的次數（建幾棵樹一起投票），1 = 只建一棵
#  最佳組合：rules、不 winnow、trials = 1，平均正確率 95.2%
ggplot(C50Fit)
#  把各參數組合的正確率畫成折線圖
#  （可能出現 aes_string() was deprecated 的警告，是 caret 內部的寫法較舊，可以忽略）
#winnowing : select which features include in the analysis


#try the suggessed parameters above
input <- iris[,1:4]
output <- iris[,5]
model1 <- C5.0(input, output, trials = 1, rules = F,
  control = C5.0Control(winnow = FALSE, noGlobalPruning = F, minCases = 1))
#     （注意 rules = TRUE 的模型無法用 plot() 畫成樹，要用 summary() 看規則）
plot(model1,main="C5.0 Decision Tree, min=1") #try to change minCases to 3
#  （noGlobalPruning = F 其實是「有修剪」，標題寫的 Unpruned 不太正確）

model_ori <- C5.0(input, output, control = C5.0Control(noGlobalPruning = T,minCases=1))
plot(model_ori,main="C5.0 Decision Tree - Unpruned, min=1") #try to change minCases to 3


##################################################
#try to fit diamonds data with rpart algorithm
##################################################

RpartFit <- caret::train(color ~ . ,data = sample_diamonds,
                         method = "rpart",
                        trControl = ctrl)
#  用交叉驗證找 rpart 最好的 cp（複雜度參數）
#  cp 越小，樹可以長得越大；cp 越大，樹越早停止分割
RpartFit
#>   cp           Accuracy   Kappa
#>   0.008860759  0.2213334  0.05408849
#>   0.010126582  0.2184380  0.04651592
#>   0.018987342  0.2144485  0.01632709
#> The final value used for the model was cp = 0.008860759.
#  最佳 cp 的正確率也只有 22%，Kappa 接近 0 → 再怎麼調參數，也無法用這些特徵預測顏色
ggplot(RpartFit)

model1 <- rpart(color ~., data = sample_diamonds, method = 'class',cp = 0.008860759)
#  用 caret 建議的 cp 重新建樹（比預設的 cp = 0.01 小，樹會更大）
rpart.plot(model1, extra = 106) #Display extra information at the nodes
summary(model1)
prp(model1) #plot r part model

model_ori <- rpart(color ~., data = sample_diamonds, method = 'class')
#  預設 cp = 0.01 的樹，和上面比較
rpart.plot(model_ori, extra = 106) #Display extra information at the nodes
summary(model_ori)
prp(model_ori) #plot r part model

#quite different,right?
#  cp 只差一點點，樹的大小就明顯不同。但兩棵樹的正確率都只有約 22%，
#  樹變大不代表預測變準

# ------------------------------------------------------------
# 第五部分：cforest 條件推論隨機森林
# ------------------------------------------------------------
##################################################
# cforest
##################################################
# 【補充】隨機森林 (random forest)：建立很多棵決策樹，每棵樹用不同的資料和特徵，
#   最後所有樹一起投票。通常比單一棵樹更準、更穩定。
#   cforest 是 party 套件中的版本，需要先安裝：install.packages("party")

CForestFit <- caret::train(Species ~ . ,data = iris,
                           method = "cforest",
                          trControl = ctrl)
#  這一步比較花時間（約十幾秒）
CForestFit
#>   mtry  Accuracy   Kappa
#>   2     0.9493333  0.924
#>   3     0.9453333  0.918
#>   4     0.9486667  0.923
#> The final value used for the model was mtry = 2.
#  mtry：每次分割時隨機挑幾個特徵來考慮，最佳是 2
ggplot(CForestFit)

sample_index3 <- sample(1:nrow(iris), size = 10)
sample_index3
#> [1]  22  42 109 126  23 115  70  46 108 120
newcases <- iris[sample_index3,-5]
#  隨機抽 10 朵花，去掉第 5 欄 Species
newcases
predicted <- predict(CForestFit, newcases, type="prob")
#  caret 模型的 type = "prob"：每個品種的機率
predicted
#>         setosa  versicolor    virginica
#> 1  0.996850649 0.002593795 0.0005555556
#>  ...（省略）...
#> 10 0.000000000 0.512917342 0.4870826584
#  第 10 朵（iris 第 120 列）versicolor 和 virginica 的機率幾乎各半，模型很猶豫
predicted <- predict(CForestFit, newcases, type="raw")
#  caret 模型的 type = "raw"：直接給出預測類別（一般 C5.0 / rpart 則是寫 type = "class"）
predicted
#>  [1] setosa     setosa     virginica  virginica  setosa     virginica  versicolor
#>  [8] setosa     virginica  versicolor
#  第 10 朵預測為 versicolor，但 iris 第 120 列其實是 virginica → 猜錯了

# ============================================================
# 重點整理
# ============================================================
# | 項目          | rpart                         | C5.0                        |
# |---------------|-------------------------------|-----------------------------|
# | 分割依據      | Gini 指數                     | 資訊熵 (entropy)            |
# | 建模          | rpart(Y ~ ., method = "class")| C5.0(Y ~ .) 或 C5.0(x, y)   |
# | 畫圖          | rpart.plot()、prp()           | plot()                      |
# | 主要參數      | cp（越小樹越大）              | trials、rules、winnow       |
#
# caret::train(..., method = "rpart" / "C5.0" / "cforest") 可以用交叉驗證自動找參數
#
# 本範例最重要的觀念：鑽石的其他欄位幾乎無法預測顏色，
# 換演算法、調參數都只有約 22% 正確率——資料本身沒有資訊，模型也變不出來
#
# 練習題
# 1. 把 rpart.plot 的 extra 改成 104，比較顯示的資訊
# 2. 改用 sample_diamonds 預測 cut（切工），正確率會比預測顏色高嗎？
# 3. 用正確寫法 rules = TRUE 建立 C5.0 規則模型，用 summary() 看產生的規則
