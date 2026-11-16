##########################################
#Editor: Kuo-Liang Ou
#National Tsing Hua University ILST
##########################################
#ROC = the probability curve of the values
#AUC = separability of the different groups of values/labels.
#不同演算法比較
# ============================================================
# 8-3 用 ROCR 套件畫 ROC 曲線、計算 AUC
# ============================================================
# ROCR 是另一個常用的評估套件，用法分兩步：
#   1. prediction(預測分數, 真實答案)：把資料整理成 ROCR 的格式
#   2. performance(上一步的結果, 指標)：計算想要的指標，再用 plot() 畫圖
# 好處是換個指標名稱，就能畫出 ROC、PR、敏感度 / 特異度等不同的圖。
# （ROC、AUC 的基本觀念請見 1-PR_ROC_註解.R）
#
# 說明：#> 是 R 4.6.1 + ROCR 實際執行的結果。
# ============================================================

if (!require("ROCR")) install.packages("ROCR")
library(ROCR)
data(ROCR.simple)
#  ROCR 內附的練習資料：某個分類模型對 200 筆資料的預測結果
ROCR.simple      #200 samples of 1 and 0
#  是一個 list，包含兩個部分：
#    $predictions：模型給的分數（0 ~ 1 之間，越高越可能是 1）
#    $labels：真實答案，0 或 1（107 個 0、93 個 1）
ROCR.simple$predictions
ROCR.simple$labels

# ------------------------------------------------------------
# 第一部分：ROC 曲線
# ------------------------------------------------------------
pred <- prediction( ROCR.simple$predictions, ROCR.simple$labels)
#  prediction(分數, 答案)：答案中數值較大的 (1) 預設為正例
perf <- performance(pred,"tpr","fpr")
#  performance(pred, y 軸指標, x 軸指標)：這裡 y = TPR、x = FPR，就是 ROC 曲線
perf
#> A performance instance
#>   'False positive rate' vs. 'True positive rate' (alpha: 'Cutoff')
#>   with 201 data points
#  201 個點：200 筆資料可以設 200 種門檻，再加上起點
#  alpha: 'Cutoff' 表示每個點對應的門檻值也存起來了
plot(perf)
#  ROC 曲線，明顯在對角線上方
#  加上 colorize = TRUE 可以用顏色顯示門檻值：plot(perf, colorize = TRUE)
#ROC curves: measure="tpr", x.measure="fpr".
#Precision/recall graphs: measure="prec", x.measure="rec".
#Sensitivity/specificity plots: measure="sens", x.measure="spec".
#  三種常見的圖：
#    ROC 曲線              ：performance(pred, "tpr", "fpr")
#    Precision-Recall 曲線 ：performance(pred, "prec", "rec")
#    敏感度-特異度         ：performance(pred, "sens", "spec")

# ------------------------------------------------------------
# 第二部分：AUC 與其他指標
# ------------------------------------------------------------
perf2 <- performance(pred, measure = "auc")   #area under curve
#  只算一個數字的指標，不用指定 x 軸
perf2@y.values
#> [[1]]
#> [1] 0.8341875
#  AUC = 0.834，模型的鑑別能力不錯
#  @y.values：ROCR 的結果是 S4 物件，用 @ 取出內容；結果是 list，所以用 [[1]] 取出數字
#  直接取數字：perf2@y.values[[1]]
###
# acc: accuracy
# rec: recall
# prec: precision
perf3 <- performance(pred, measure = "rec")   #area under curve
#  （這行的註解 area under curve 是從上面複製的，rec 其實是召回率 Recall）
perf3@y.values
#> [[1]]
#>   [1] 0.00000000 0.01075269 0.02150538 0.03225806 0.03225806 0.04301075 0.04301075
#>  ...（共 201 個，省略）...
#  召回率會隨門檻改變，所以得到的是「每個門檻下的召回率」，一共 201 個值，
#  從 0（門檻最高，什麼都不判為正）逐漸增加到 1（門檻最低，全部判為正）
#  對應的門檻值存在 perf3@x.values
#  想看召回率和門檻的關係：plot(perf3)

# ============================================================
# 重點整理
# ============================================================
# | 步驟                              | 說明                              |
# |-----------------------------------|-----------------------------------|
# | prediction(分數, 答案)            | 整理資料                          |
# | performance(pred, "tpr", "fpr")   | ROC 曲線                          |
# | performance(pred, "prec", "rec")  | PR 曲線                           |
# | performance(pred, "auc")          | AUC（單一數字）                   |
# | performance(pred, "acc")          | 每個門檻下的正確率                |
# | 結果@y.values[[1]]                | 取出數值                          |
#
# 練習題
# 1. 畫出 PR 曲線：plot(performance(pred, "prec", "rec"))
# 2. 用 plot(performance(pred, "acc")) 找出正確率最高的門檻大約是多少
# 3. 用 plot(perf, colorize = TRUE) 畫出有門檻顏色的 ROC 曲線
