install.packages("neuralnet")
library(neuralnet)
install.packages("dummy")
library(dummy)
install.packages("dplyr")
library(dplyr)
#  載入 dplyr 時會顯示「下列物件被遮斷自 'package:neuralnet': compute」，
#  意思是 dplyr 也有 compute() 函數，之後 compute() 會用 dplyr 的版本
# ============================================================
# 5-7 類神經網路 (Artificial Neural Network, ANN)：iris 分類
# ============================================================
# 【什麼是類神經網路？】
#   模仿大腦神經元的運作：
#     輸入層（4 個特徵）→ 隱藏層（若干個神經元）→ 輸出層（3 個品種）
#   每條連線都有一個「權重」，訓練時不斷調整權重，讓輸出越來越接近正確答案。
#   隱藏層的神經元越多、層數越多，模型越複雜，能學的關係也越複雜。
#
# 這個範例教你：
#   1. 用 neuralnet 套件建立類神經網路、畫出網路結構
#   2. 把輸出的數字轉換成品種名稱
#   3. 比較不同隱藏層設定的結果
#
# 說明：#> 是 R 4.6.1 + neuralnet 1.44.2 實際執行的結果。
#       類神經網路的初始權重是隨機的，即使有 set.seed，不同電腦或版本的結果也可能略有不同。
# ============================================================

# ------------------------------------------------------------
# 第一部分：準備資料
# ------------------------------------------------------------
iris_dummy = cbind(iris, dummy(iris,int=T)) #強迫轉為int
#增加三欄編碼，因為只能用數值作為class
#dummy a data frame containing at least one factor or character vector
#  dummy()：把類別欄位 Species 轉成 3 個 0/1 欄位（虛擬變數，說明見 2-9 範例）
#    Species_setosa、Species_versicolor、Species_virginica
#  int = T：結果是整數 0/1（不加的話會是文字 "0"/"1"）
#  cbind() 接在原本的 iris 後面 → 150 列 × 8 欄
iris_dummy
set.seed(2026)
sample_size = 0.8 * nrow(iris_dummy)
sample_index = sample(nrow(iris_dummy),sample_size) #取樣索引
iris_train = iris_dummy[sample_index,]
iris_test = iris_dummy[-sample_index,]
#  訓練集 120 列、測試集 30 列
##########################
#neuralnet(formula, data, hidden = 1, threshold = 0.01)
#  hidden = 隱藏層的神經元數（預設 1 個）；threshold = 停止訓練的門檻
######
#以下三選一
ann_formula = Species_setosa + Species_versicolor + Species_virginica ~ Sepal.Length + Sepal.Width + Petal.Length + Petal.Width
#use dummy
#setosa 變成欄位了；versicolor and virginica 也是欄位
#  寫法 1：用 3 個 0/1 欄位當輸出，網路會有 3 個輸出神經元
ann_formula = Species_versicolor + Species_virginica ~ Sepal.Length + Sepal.Width + Petal.Length + Petal.Width
#可以只針對特定 label
#  寫法 2：只預測其中 2 個品種（兩個都是 0 就代表 setosa）
##########
ann_formula = Species ~ Sepal.Length + Sepal.Width + Petal.Length + Petal.Width
#dummy in not needed
#  寫法 3：直接用 factor 欄位 Species，neuralnet 會自動拆成 3 個輸出
#  三行依序執行，後面的會蓋掉前面的，所以最後實際使用的是「寫法 3」
#############################################
#ANN
#############################################

# ------------------------------------------------------------
# 第二部分：1 個隱藏神經元
# ------------------------------------------------------------
model1= neuralnet(formula = ann_formula, data=iris_train) #use the training data
#  hidden 沒有指定 → 預設 1 個隱藏神經元：4 個輸入 → 1 個神經元 → 3 個輸出
plot(model1)
#  畫出網路結構：圓圈是神經元，線上的數字是權重，藍色的 1 是偏差項 (bias)

model1 #show the nn information
#  印出模型的詳細內容，很長
#  neuralnet 1.44.2 的小問題：輸出欄位的「名稱」會依照訓練資料中品種出現的順序排列
#     （這次是 virginica、setosa、versicolor），但「數值」其實是依照 factor 的
#     層級順序 setosa、versicolor、virginica。所以印出的 Intercept.to.virginica 等名稱不可信，
#     predict() 結果的第 1、2、3 欄分別是 setosa、versicolor、virginica
result_pre=predict(model1, iris_test) #predict the test data
result_pre #prediction result
#  30 列 × 3 欄，每欄是「屬於該品種的程度」，越接近 1 越像
#>            [,1]      [,2]        [,3]
#> 1    0.98759101 0.1061278 -0.09388099
#>  ...（省略）...
#> 65   0.23390314 0.3390665  0.42702467
#>  ...（省略）...
#  setosa 的花第 1 欄接近 1，很明確；但 versicolor 的花三欄都不高，模型分不清楚
#  只有 1 個隱藏神經元太簡單了

#
result_pre=round(result_pre)#四捨五入
#  四捨五入成 0 或 1
pred.df = as.data.frame(result_pre)
pred.df$Species =""
#  新增一個空的 Species 欄，準備填入預測的品種名稱
pred.df
for(i in 1:nrow(pred.df)){
  if(pred.df[i, 1]==1){ pred.df[i, "Species"] = "Setosa"}
  if(pred.df[i, 2]==1){ pred.df[i, "Species"] = "Versicolor"}
  if(pred.df[i, 3]==1){ pred.df[i, "Species"] = "Virginica"}
}
#  for 迴圈：逐列檢查，哪一欄是 1 就填入對應的品種名稱
#  如果三欄都是 0（四捨五入後沒有任何一欄 ≥ 0.5），Species 就維持空白
pred.df # you may find out some empty results
#>     V1 V2 V3   Species
#> 1    1  0  0    Setosa
#>  ...
#> 65   0  0  0              ← 空白：模型無法判斷
#>  ...（共 5 列空白）...
table(iris_test$Species, pred.df$Species) #some troubles
#>                 Setosa Virginica
#>   setosa      0     10         0
#>   versicolor  5      0         8
#>   virginica   0      0         7
#  表格看起來很亂，原因有兩個：
#   1. 預測名稱首字大寫 "Setosa"，真實名稱是小寫 "setosa"，R 視為不同的文字，所以對不上對角線
#   2. 第一欄沒有名稱的是「空白」(5 朵)；另外 8 朵 versicolor 被誤判成 Virginica
#  實際上：setosa 10 朵全對、versicolor 0 朵對、virginica 7 朵全對
####

# ------------------------------------------------------------
# 第三部分：2 個隱藏神經元
# ------------------------------------------------------------
model2= neuralnet(formula = ann_formula, data=iris_train, hidden=2) #node of hidden layer = 2
#  hidden = 2：隱藏層有 2 個神經元
plot(model2)
model2
result_pre2=predict(model2, iris_test)

###

labels <- c("setosa", "versicolor", "virginica")
prediction_label <- data.frame(max.col(result_pre2)) %>%
mutate(result_pre2=labels[max.col.result_pre2.]) %>%
select(2) %>%
unlist()
#  更好的轉換方法（不需要四捨五入，也不會有空白）：
#    max.col(result_pre2)：每一列找出「數值最大的是第幾欄」→ 1、2 或 3
#    data.frame(...)：放進資料框，欄位名稱自動變成 max.col.result_pre2.
#    mutate(...)：用 labels[欄號] 把 1、2、3 換成品種名稱
#    select(2)：只取第 2 欄（品種名稱）
#    unlist()：從資料框轉成一般的向量
#  （簡單版寫法：prediction_label <- labels[max.col(result_pre2)]）

table(iris_test$Species, prediction_label)
#>             prediction_label
#>              setosa versicolor virginica
#>   setosa         10          0         0
#>   versicolor      0         11         2
#>   virginica       0          0         7
#  正確率 28 / 30 ≈ 93.3%，比 1 個神經元好很多



# ============================================================
# 重點整理
# ============================================================
# | 項目                     | 說明                                          |
# |--------------------------|-----------------------------------------------|
# | neuralnet(Y ~ X, data)   | 建立類神經網路                                |
# | hidden = 2               | 1 層隱藏層，2 個神經元                        |
# | hidden = c(1, 1, 3)      | 3 層隱藏層，各 1、1、3 個神經元               |
# | plot(模型)               | 畫出網路結構和權重                            |
# | predict(模型, 新資料)    | 每個類別一欄，數值越大越像                    |
# | labels[max.col(結果)]    | 取每列最大值的欄位，轉成類別名稱              |
#
# 提醒：
# - 類神經網路對特徵的數值範圍很敏感，實務上通常先正規化（見 2-7 範例）
#
