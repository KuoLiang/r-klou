##########################################
#Editor: Kuo-Liang Ou
#National Tsing Hua University ILST
##########################################
#ROC = the probability curve of the values
#AUC = separability of the different groups of values/labels.
# ============================================================
# 8-1 ROC 曲線、AUC 與 PR 曲線（用亂數模擬兩組分數）
# ============================================================
# 【先懂四個名詞】二元分類（例如：有病 / 沒病）時，預測結果分成四種：
#                    實際為正 (有病)        實際為負 (沒病)
#   預測為正         TP 真陽性（抓對了）    FP 偽陽性（誤報）
#   預測為負         FN 偽陰性（漏抓）      TN 真陰性
#
#   TPR（真陽性率、敏感度 Sensitivity、召回率 Recall）= TP / (TP + FN)：有病的人中被抓出來的比例
#   FPR（偽陽性率）= FP / (FP + TN) = 1 - 特異度：沒病的人中被誤報的比例
#   Precision（精確率）= TP / (TP + FP)：被判定有病的人中，真的有病的比例
#
# 【ROC 曲線】模型通常給每個人一個「分數」，再設一個門檻 (threshold)：分數高於門檻就判為正。
#   門檻從高調到低，每個門檻都算出一組 (FPR, TPR)，連起來就是 ROC 曲線。
#   曲線越靠近左上角越好。
# 【AUC】ROC 曲線下的面積 (Area Under Curve)，介於 0 ~ 1：
#   1.0 = 完美分開；0.5 = 和亂猜一樣（對角線）；< 0.5 = 比亂猜還差（通常是正負搞反了）
#   另一個解釋：隨機抽一個正例、一個負例，正例分數比較高的機率
# 【PR 曲線】x 軸 Recall、y 軸 Precision。正例很少的資料（例如詐騙偵測）看 PR 曲線比 ROC 更準確
#
# 這個範例用 rnorm() 產生三組分數，模擬「正例分數」和「負例分數」，觀察分布重疊程度對 AUC 的影響。
#
# 說明：#> 是 R 4.6.1 + PRROC 實際執行的結果（有 set.seed(2025)，結果固定）。
# ============================================================
if (!require("PRROC")) install.packages("PRROC")
library(PRROC)
#  PRROC：計算並畫出 ROC 曲線和 PR 曲線
if (!require("verification")) install.packages("verification")
library(verification)
#  ⚠️ 這個範例其實沒有用到 verification 套件。而且載入它會連帶載入 proxy 等十幾個套件，
#     其中 proxy 會「遮蔽」R 內建的 dist() 和 as.matrix()（會看到「下列物件被遮斷自 'package:stats': as.dist, dist」），
#     可能影響同一個 R 工作階段中之後的分群程式。建議刪除這兩行
set.seed(2025)

# ------------------------------------------------------------
# 第一部分：產生三組分數
# ------------------------------------------------------------
# random generate C1
C1 = rnorm(300); #mean = 0 ; sd =1
#  300 個分數，平均 0、標準差 1
#  （行尾的分號 ; 在 R 中可以省略）
C1
summary(C1)
#>      Min.   1st Qu.    Median      Mean   3rd Qu.      Max.
#> -2.849243 -0.671678 -0.044903  0.004334  0.693408  2.852781
#random generate C2
C2 = rnorm(300,-2); #mean = -2 ; sd =1
C2
summary(C2)
#>    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.
#>  -4.645  -2.709  -1.984  -1.990  -1.421   1.271
#random generate C3
C3 = rnorm(300,2,2); #mean = 2 ; sd =2
C3
summary(C3)
#>    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.
#> -3.8818  0.7573  2.0198  2.0078  3.2849  7.5745
### 觀察C1C2C3的分布
boxplot(C1,C2,C3)
#  三組並排的箱形圖：C2 最低、C1 中間、C3 最高而且最分散

# ------------------------------------------------------------
# 第二部分：ROC 曲線
# ------------------------------------------------------------
### C1 C2 ROC and threshold C1=postive score C2=negative score
#Sensitividy = TPR
roc_12 = roc.curve(C1, C2, curve = TRUE) #curve must be T
#  roc.curve(正例的分數, 負例的分數, curve = TRUE)
#  curve = TRUE：保留整條曲線的資料，才能畫圖；FALSE 只算 AUC
roc_12
#>   ROC curve
#>     Area under curve:
#>      0.9160111
#  C1（正例）平均 0、C2（負例）平均 -2，正例分數大多比較高，兩組重疊不多 → AUC 0.916，分得很好
plot(roc_12)
#  曲線靠近左上角；曲線上的顏色代表門檻值（右邊有色條對照）

### C1 C3 ROC and threshold
roc_13 = roc.curve(C1, C3, curve = TRUE) #curve must be T
roc_13
#>     Area under curve:
#>      0.1702667
#  AUC 只有 0.17，比 0.5 還低！
#  原因：這裡把 C1 當正例，但負例 C3 的分數（平均 2）反而比正例（平均 0）高，
#  「分數越高越可能是正例」的假設剛好相反。
#  其實兩組分得還不錯，只是方向反了：把兩者對調 roc.curve(C3, C1) 會得到 1 - 0.17 = 0.83
plot(roc_13)
#  曲線在對角線的右下方

### C2 C3 ROC and threshold
roc_23 = roc.curve(C2, C3, curve = TRUE) #curve must be T
roc_23
#>     Area under curve:
#>      0.0396
#  同樣是方向相反：C2（平均 -2）當正例，C3（平均 2）當負例。
#  對調後 AUC = 0.96，代表這兩組其實分得非常開
plot(roc_23)

# ------------------------------------------------------------
# 第三部分：PR 曲線
# ------------------------------------------------------------
#################################
### PR Curve - Precision-Recall
#################################
pr = pr.curve(C1, C2,curve = TRUE) #C1 positive C2 negative
#  pr.curve(正例的分數, 負例的分數, curve = TRUE)
pr
#>   Precision-recall curve
#>     Area under curve (Integral):
#>      0.9065888
#>     Area under curve (Davis & Goadrich):
#>      0.906588
#  PR 曲線下面積 0.907。兩個數字是用不同方法計算的面積，結果幾乎相同
#  注意：PR 曲線的「亂猜」基準不是 0.5，而是正例所佔的比例（這裡 300 : 300，所以是 0.5）
plot(pr)

### PR Curve - Precision-Recall
pr = pr.curve(C1, C3,curve = TRUE) #C1 positive C3 negative
pr
#>     Area under curve (Integral):
#>      0.3368517
#  比基準 0.5 低，原因和 roc_13 相同：正負方向反了
plot(pr)

### PR Curve - Precision-Recall
pr = pr.curve(C2, C3,curve = TRUE) #C2 positive C3 negative
pr
#>     Area under curve (Integral):
#>      0.31215
plot(pr)
#############################################################
#以上圖形中之顏色為分割點 threshold
#############################################################
#  沿著曲線移動，就是在調整門檻：門檻高 → 判為正的人少，Precision 高但 Recall 低；
#  門檻低 → 判為正的人多，Recall 高但 Precision 低。要依實際需求取捨

# ============================================================
# 重點整理
# ============================================================
# | 指標 / 圖    | 意思                                       | 好的方向          |
# |--------------|--------------------------------------------|-------------------|
# | TPR / Recall | 正例中被抓出的比例                         | 越高越好          |
# | FPR          | 負例中被誤判的比例                         | 越低越好          |
# | Precision    | 判為正的當中，真的是正例的比例             | 越高越好          |
# | ROC 曲線     | x = FPR、y = TPR                           | 靠近左上角        |
# | AUC          | ROC 曲線下面積，0.5 = 亂猜                 | 越接近 1 越好     |
# | PR 曲線      | x = Recall、y = Precision                  | 靠近右上角        |
#
# AUC < 0.5 時，先檢查正例、負例是不是放反了
#
# 練習題
# 1. 執行 roc.curve(C3, C1, curve = TRUE)，確認 AUC 是否等於 1 - 0.17
# 2. 產生兩組平均只差 0.5 的分數：rnorm(300, 0) 和 rnorm(300, -0.5)，AUC 大約是多少？
# 3. 把負例改成 3000 個（正例仍是 300 個），比較 ROC 的 AUC 和 PR 的 AUC 哪一個變化比較大
