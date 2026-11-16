##########################################
#Editor: Kuo-Liang Ou
#National Tsing Hua University ILST
##########################################
# ============================================================
# 8-4 ROCR 進階：隨機分數的 AUC，以及 iris「一對其餘」的 ROC
# ============================================================
# 這個範例教你：
#   1. 如果分數和答案完全無關，AUC 會是多少？（答案：約 0.5）
#   2. 多類別問題用「一對其餘」(one-vs-rest) 轉成二元問題：
#      setosa vs 其他、versicolor vs 其他、virginica vs 其他，各算一條 ROC
#   3. 用 SVM 的連續輸出當分數，計算 AUC
#
# 說明：#> 是 R 4.6.1 + ROCR 實際執行的結果（有 set.seed(2025)，結果固定）。
#       prediction()、performance() 的用法請見 3-ROCR_註解.R
# ============================================================

if (!require("e1071")) install.packages("e1071")
library(e1071)
if (!require("ROCR")) install.packages("ROCR")
library(ROCR)
data(ROCR.simple)
set.seed(2025)
group=c(rep(0,times=100),rep(1,times=100)) #分兩組
#  自己做一組答案：前 100 個是 0、後 100 個是 1
#pred <- prediction( ROCR.simple$labels, ROCR.simple$labels)
#  （如果把「答案本身」當分數，就是完美的預測，AUC = 1）

# ------------------------------------------------------------
# 第一部分：分數和答案無關時的 ROC
# ------------------------------------------------------------
# prediction 第一個參數位資料集，第二個參數為組別，目前支援二分法
# 多組以上需兩兩比較
#  更精確地說：第一個參數是「預測分數」，第二個參數是「真實答案」
pred1 <- prediction( rnorm(200,mean=1,sd=1), ROCR.simple$labels)
pred1 <- prediction( rnorm(200,mean=2,sd=2), ROCR.simple$labels)
#  分數是隨機產生的 200 個數字，和 ROCR.simple$labels 完全沒有關係
#  （第二行會蓋掉第一行，所以實際用的是平均 2、標準差 2 的亂數）

perf <- performance(pred1,"tpr","fpr")
perf
plot(perf)
#  ROC 曲線大致貼著對角線，代表這個「模型」和亂猜一樣
perf <- performance(pred1, measure = "auc")   #area under curve
perf@y.values
#> [[1]]
#> [1] 0.5524068
#  AUC ≈ 0.55，接近 0.5。不會剛好是 0.5，是因為亂數本身有隨機誤差
#  重點：分數的平均數、標準差是多少都沒關係，只要分數和答案無關，AUC 就會接近 0.5


########################################
pred2 <- prediction( rnorm(200,mean=1,sd=1), group)
pred2 <- prediction( rnorm(200,mean=2,sd=2), group)
#  改用自己做的 group 當答案，分數同樣是和答案無關的亂數

perf2 <- performance(pred2,"tpr","fpr")
perf2
plot(perf2)
perf2 <- performance(pred2, measure = "auc")   #area under curve
perf2@y.values
#> [[1]]
#> [1] 0.4665
#  AUC ≈ 0.47，一樣接近 0.5
#  【延伸】如果想模擬「有鑑別力」的模型，要讓兩組的分數真的不同，例如：
#    score <- c(rnorm(100, mean = 0), rnorm(100, mean = 2))   ← 第 1 組平均 0、第 2 組平均 2
#    performance(prediction(score, group), "auc")@y.values   ← AUC 約 0.92

# ------------------------------------------------------------
# 第二部分：iris 的「一對其餘」ROC
# ------------------------------------------------------------
#########
#for IRIS
#########
iris$setosa <- as.numeric(iris$Species == "setosa")
#  新增一欄：是 setosa 就是 1，不是就是 0
#  iris$Species == "setosa" 產生 TRUE/FALSE，as.numeric() 轉成 1/0
mod1 <- svm(iris$setosa~Sepal.Length+Sepal.Width, data=iris, kernel="radial")
#  只用花萼長、寬兩個特徵，預測「是不是 setosa」
#  因為 setosa 欄是數字 (0/1)，svm() 會做「迴歸」，輸出連續的分數，正好可以拿來畫 ROC
#  （公式裡寫 iris$setosa 也能執行，但既然有 data = iris，寫 setosa 就可以了）

pred1 <- prediction(predict(mod1), iris$setosa)
#  predict(mod1)：沒給新資料時，就是對訓練資料的預測分數（150 個）
perf1 <- performance(pred1,"tpr","fpr")
plot(perf1)
#  曲線幾乎貼著左上角
perf1 <- performance(pred1, measure = "auc")   #area under curve
perf1@y.values
#> [[1]]
#> [1] 0.9996
#  setosa vs 其他：AUC 0.9996，光用花萼就幾乎能完美分開
#############
iris$vcolor <- as.numeric(iris$Species == "versicolor")
mod2 <- svm(iris$vcolor~Sepal.Length+Sepal.Width, data=iris, kernel="radial")
#  versicolor vs 其他

pred2 <- prediction(predict(mod2), iris$vcolor)
perf2 <- performance(pred2,"tpr","fpr")
plot(perf2)
perf2 <- performance(pred2, measure = "auc")   #area under curve
perf2@y.values
#> [[1]]
#> [1] 0.8743
#  AUC 0.874：versicolor 和 virginica 的花萼尺寸重疊比較多，比較難分
#############
iris$vnica <- as.numeric(iris$Species == "virginica")
mod3 <- svm(iris$vnica~Sepal.Length+Sepal.Width, data=iris, kernel="radial")
#  virginica vs 其他

pred3 <- prediction(predict(mod3), iris$vnica)
perf3 <- performance(pred3,"tpr","fpr")
plot(perf3)
perf3 <- performance(pred3, measure = "auc")   #area under curve
perf3@y.values
#> [[1]]
#> [1] 0.8861
#  AUC 0.886
#  提醒：這三個 AUC 都是用訓練資料計算的，會比實際面對新資料時高一些

# ============================================================
# 重點整理
# ============================================================
# 1. 分數和答案無關 → AUC ≈ 0.5（和亂猜一樣）
# 2. 多類別可以用「一對其餘」：每次把一個類別當正例 (1)，其他全部當負例 (0)
# 3. 畫 ROC 需要連續分數；svm() 對 0/1 數字做迴歸時，輸出的就是連續分數
# 4. 只用花萼兩個特徵：setosa 很好分 (AUC ≈ 1)，versicolor 和 virginica 較難 (≈ 0.87 ~ 0.89)
#
# 練習題
# 1. 照上面「延伸」的寫法，做出 AUC 約 0.92 的模擬分數
# 2. 把 mod2 的特徵改成 Petal.Length + Petal.Width，versicolor 的 AUC 會提高嗎？
# 3. 把三條 ROC 畫在同一張圖：plot(perf1); plot(perf2, add = TRUE, col = "red"); plot(perf3, add = TRUE, col = "blue")
#    （注意：要先重新計算 "tpr", "fpr" 的 performance，因為上面已經被 AUC 的結果蓋掉了）
