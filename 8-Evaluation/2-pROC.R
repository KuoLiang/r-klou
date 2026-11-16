##########################################
#Editor: Kuo-Liang Ou
#National Tsing Hua University ILST
##########################################
#ROC = the probability curve of the values
#AUC = separability of the different groups of values/labels.
#多類別ROC
# ============================================================
# 8-2 多類別 ROC：比較不同 gamma 的 SVM 模型（pROC 套件）
# ============================================================
# ROC 曲線原本是給「二元分類」（是 / 否）用的。iris 有 3 個品種，
# 做法是「兩兩比較」：setosa vs versicolor、setosa vs virginica、versicolor vs virginica，
# 每一對各畫一條 ROC 曲線。
#
# 這個範例用 3 個不同 gamma 的 SVM 預測 iris，畫出「versicolor vs virginica」的 ROC 曲線比較。
# （ROC、AUC 的基本觀念請見 1-PR_ROC_註解.R；SVM 和 gamma 請見 5-5 範例）
#
# 說明：AUC 數值為 R 4.6.1 + pROC 實際執行的結果。
# ============================================================

if (!require("pROC")) install.packages("pROC")
library(pROC)
#  載入時「下列物件被遮斷自 'package:stats': cov, smooth, var」是正常訊息
if (!require("e1071")) install.packages("e1071")
library(e1071)

# ------------------------------------------------------------
# 第一部分：建立 3 個 SVM 模型
# ------------------------------------------------------------
result_radial_1<-svm(Species~.,iris,
                     kernel="radial",gamma=10^-1)
#gamma值如果愈小資料點影響的範圍愈大
#  gamma = 0.1
#  gamma 越小，每個點的影響範圍越大，邊界越平滑（太小會「欠擬合」，分不開類別）

result_radial_2<-svm(Species~.,iris,
                     kernel="radial",gamma=10^-2)
#  gamma = 0.01

result_radial_3<-svm(Species~.,iris,
                     kernel="radial",gamma=10^-3)
#  gamma = 0.001

# ------------------------------------------------------------
# 第二部分：計算多類別 ROC
# ------------------------------------------------------------
#將預測結果 Specise 轉為 123代號
pre_1<-as.numeric(predict(result_radial_1,iris))
pre_2<-as.numeric(predict(result_radial_2,iris))
pre_3<-as.numeric(predict(result_radial_3,iris))
#  predict() 得到預測品種，as.numeric() 轉成代號：setosa = 1、versicolor = 2、virginica = 3
#  （注意：這裡用訓練資料自己預測，結果會偏樂觀）

#執行 multicalss.roc
a1<-multiclass.roc(iris$Species,pre_1)
a2<-multiclass.roc(iris$Species,pre_2)
a3<-multiclass.roc(iris$Species,pre_3)
#  multiclass.roc(真實類別, 預測分數)：每兩個類別算一條 ROC
#  每一對會印出 Setting direction: controls < cases，意思是自動判斷「分數越高越像後面那個類別」
#
#  ⚠️ 觀念提醒：ROC 需要「連續的分數」，才能逐步調整門檻畫出曲線。
#     這裡用的是預測「類別代號」(1、2、3)，每對只有兩種值，曲線只會有一個轉折點，
#     AUC 其實就等於「平衡正確率」（兩類各自的正確率平均）。
#     比較標準的做法是用 SVM 的機率或決策值當分數：
#       m <- svm(Species ~ ., iris, gamma = 0.1, probability = TRUE)
#       p <- attr(predict(m, iris, probability = TRUE), "probabilities")
#       multiclass.roc(iris$Species, p)
#  整體的平均 AUC：auc(a1)

#a1[["rocs"]][[1]] setosa vs versicolor
#a1[["rocs"]][[2]] setosa vs virginicar
#a1[["rocs"]][[3]] viersicolor vs virginica
#  a1 裡的 rocs 是一個清單，依序存放三對比較的 ROC 結果
#  [[3]] 是 versicolor vs virginica，這兩種花最難分，最能看出模型的差異
#print.auc.y  : y position for the printing of the AUC.
#add = TRUE, the ROC curve will be added to an existing plot

# ------------------------------------------------------------
# 第三部分：畫在同一張圖上比較
# ------------------------------------------------------------
plot.roc(a1[["rocs"]][[3]],print.auc = T,col="blue",
         print.auc.y = .5,legacy.axes = TRUE,lty=4,
         main="Versicolor & Virginica")
#  print.auc = T：在圖上印出 AUC
#  print.auc.y = .5：AUC 文字放在 y = 0.5 的位置（三條曲線錯開，才不會重疊）
#  legacy.axes = TRUE：x 軸顯示「1 - 特異度」(0 → 1)，和一般教科書的 ROC 圖相同；
#                      預設是「特異度」(1 → 0)
#  lty = 4：線條樣式（點虛線）
#  γ = 0.1 的 AUC = 0.970
plot.roc(a2[["rocs"]][[3]],print.auc = T,col="red",
         print.auc.y = .4,add=T,legacy.axes = TRUE,lty=3)
#  add = T：畫在同一張圖上
#  γ = 0.01 的 AUC = 0.850
plot.roc(a3[["rocs"]][[3]],print.auc = T,col="green",
         print.auc.y = .3,add=T,legacy.axes = TRUE,lty=2)
#  γ = 0.001 的 AUC = 0.790
legend(.2,.3,legend = c("γ=10^-1","γ=10^-2","γ=10^-3")
       ,col = c("blue","red","green"),lty=c(4,3,2))
#  在圖的 (0.2, 0.3) 位置加上圖例，顏色和線條樣式要和上面三條曲線一致
#  （pROC 的 x 軸座標方向和一般圖不同，圖例位置可能需要自行調整）
#
#  結論：gamma 從 0.1 降到 0.001，AUC 從 0.97 降到 0.79
#  → 對 iris 來說，gamma 太小讓邊界過於平滑，分不開 versicolor 和 virginica

# ============================================================
# 重點整理
# ============================================================
# | 函數                           | 用途                                  |
# |--------------------------------|---------------------------------------|
# | multiclass.roc(真實, 分數)     | 多類別 ROC，兩兩比較                  |
# | 結果[["rocs"]][[i]]            | 取出第 i 對的 ROC                     |
# | plot.roc(..., print.auc = T)   | 畫 ROC 並標示 AUC                     |
# | add = T                        | 疊在同一張圖上比較                    |
# | auc(結果)                      | 計算 AUC                              |
#
# ROC 應該用「連續分數」（機率、決策值）計算，用預測類別會失去大部分資訊
#
# 練習題
# 1. 用 auc(a1)、auc(a2)、auc(a3) 比較三個模型的整體 AUC
# 2. 依照上面「觀念提醒」的寫法，改用機率計算 ROC，AUC 有什麼變化？
# 3. 加入 gamma = 1 的模型，畫成第四條曲線
