##########################################
#Editor: Kuo-Liang Ou
#National Tsing Hua University ILST
##########################################
# ============================================================
# 6-3 分群進階：決定群數、模糊 C-means、EM 分群、自組織映射 SOM
# ============================================================
# 這個範例教你：
#   1. 用「手肘法」(elbow method) 決定要分幾群
#   2. 模糊 C-means：每筆資料可以「部分屬於」多個群
#   3. EM 分群 (Mclust)：用常態分配模型分群，並用 BIC 自動選擇群數
#   4. 自組織映射 SOM：用類神經網路分群，把資料排在一張網格地圖上
#
# 使用 iris 和從 diamonds 隨機抽出的 10000 顆鑽石。
#
# 說明：#> 是 R 4.6.1 實際執行的結果；圖形用文字描述。
#       需要的套件：e1071、ggplot2、factoextra、mclust、kohonen
# ============================================================
if (!require("e1071")) install.packages("e1071")
library(e1071)
#  e1071 提供 cmeans()
if (!require("ggplot2")) install.packages("ggplot2")
library(ggplot2)
#  這裡載入 ggplot2 是為了使用 diamonds 資料

iris_sample = iris[,1:4]
#  iris 的 4 個數字欄（去掉品種）

set.seed(2025)
sample_index=sample(nrow(diamonds),10000)
diamond_sample= diamonds[sample_index,-c(2,3,4)] #omitted the nominal
#  隨機抽 10000 顆鑽石，去掉第 2、3、4 欄（cut、color、clarity 三個類別欄）
#  剩下 7 個數字欄：carat、depth、table、price、x、y、z
#  ⚠️ 提醒：price 的範圍是 326 ~ 18823，其他欄位大多在 0 ~ 80 之間。
#     沒有標準化就直接算距離，分群幾乎只會依照 price。
#     建議分群前先標準化：diamond_sample <- scale(diamond_sample)（SOM 那段就有這樣做）

# ------------------------------------------------------------
# 第一部分：手肘法決定群數
# ------------------------------------------------------------
### illustrate the SSE
install.packages("factoextra")
#  每次執行都會重新安裝；建議改成 if (!require("factoextra")) install.packages("factoextra")
library(factoextra)
#  factoextra：分群結果的視覺化套件
# 【補充】WSS（組內平方和，Within Sum of Squares，也稱 SSE）：
#   每個點到所屬群中心距離的平方，全部加總。WSS 越小，群內越緊密。
#   群數越多，WSS 一定越小（極端情況：每個點自成一群，WSS = 0），
#   所以要找「再多分一群，WSS 也降不了多少」的轉折點，形狀像手肘，就叫手肘法
### for iris
fviz_nbclust(iris_sample,
             FUNcluster = kmeans,  #kmeans
             method = "wss",     # total Within Sum of Square
             k.max = 12          # max number of clusters to consider
)
#  fviz_nbclust()：試 k = 1 ~ 12 群，畫出每個 k 的 WSS 折線圖
#  iris 的折線在 k = 2 ~ 3 之後變平緩 → 分 2 或 3 群比較合適
fviz_nbclust(iris_sample,
             FUNcluster = hcut,  # hierarchical clustering
             method = "wss",     # total Within Sum of Square
             k.max = 12          # max number of clusters to consider
)
#  hcut：改用階層式分群
### for diamonds
fviz_nbclust(diamond_sample,
             FUNcluster = kmeans,  # kmeans
             method = "wss",     # total within sum of square
             k.max = 12          # max number of clusters to consider
)
#  10000 筆資料，約需 10 秒
#  可能出現警告「Quick-TRANSfer 階段跨越了最大值」：kmeans 的某一步達到迭代上限，
#  結果仍可使用；資料標準化後通常就不會出現
fviz_nbclust(diamond_sample,
             FUNcluster = hcut,  # hierarchical clustering
             method = "wss",     # total within sum of square
             k.max = 12          # max number of clusters to consider
)
#  階層式分群要計算 10000 × 10000 的距離矩陣，比較慢（約 30 秒）、也比較吃記憶體

# ------------------------------------------------------------
# 第二部分：模糊 C-means
# ------------------------------------------------------------
#########################################
#Cmeans
#########################################
# 【補充】K-means 中每個點「只屬於一群」；C-means 則給每個點一組「隸屬度」，
#   例如某朵花屬於第 1 群 0.7、第 3 群 0.3，加總為 1。
#   適合邊界模糊、介於兩群之間的資料
#cmeans(x, centers, iter.max = 100, verbose = FALSE,
#       dist = "euclidean", method = "cmeans", m = 2,
#       rate.par = NULL, weights = 1, control = list())
#  centers = 群數；m = 模糊程度（越大越模糊，預設 2）
result_iris2=cmeans(iris_sample,2)
result_iris3=cmeans(iris_sample,3)
#  分別分成 2 群、3 群
#  （初始中心是隨機的，每次群的編號可能不同）
result_iris3
#> Fuzzy c-means clustering with 3 clusters
#> Cluster centers:
#>   Sepal.Length Sepal.Width Petal.Length Petal.Width
#> 1     5.888868    2.761046     4.363857    1.397266
#> 2     5.003966    3.414092     1.482810    0.253544
#> 3     6.774933    3.052359     5.646684    2.053509
#> Memberships:
#>                   1           2            3
#>   [1,] 0.0023043872 0.996623592 0.0010720206
#>   [2,] 0.0166507877 0.975850840 0.0074983727
#>  ...（150 列，省略）...
#  Memberships 隸屬度：第 1 朵花屬於第 2 群的程度是 0.997，幾乎確定
#  Closest hard clustering：取隸屬度最高的群，當作「硬」分群結果，存在 $cluster
table(result_iris3$cluster,iris$Species)
#>     setosa versicolor virginica
#>   1      0         47        13
#>   2     50          0         0
#>   3      0          3        37
#  結果和 kmeans 很接近：setosa 完全分開，versicolor 和 virginica 有少數混在一起
result_diam2=cmeans(diamond_sample,2)
result_diam3=cmeans(diamond_sample,3)
#how to show the table of diamonds?
#  【解答】diamond_sample 已經去掉類別欄位，可以用抽樣時的列號拿回原本的欄位對照，例如：
#    table(result_diam3$cluster, diamonds$cut[sample_index])
#  也可以看各群的平均價格：aggregate(price ~ result_diam3$cluster, data = diamond_sample, FUN = mean)
#  實際執行的結果，三群的平均價格約為 13511、5793、1449 美元（群的編號每次可能不同），
#  而且每一群裡五種切工都有 → 證明沒有標準化時，分群幾乎只依照價格高低
result_diam3$cluster
#  10000 顆鑽石各被分到哪一群

# ------------------------------------------------------------
# 第三部分：EM 分群（高斯混合模型）
# ------------------------------------------------------------
#########################################
#EM clustering
#Baysiean Information Criterion (BIC)
#########################################
# 【補充】EM 分群假設資料是由幾個「常態分配（鐘形曲線）」混合而成，
#   用 EM（期望值最大化）演算法找出每個常態分配的位置和形狀。
#   Mclust() 會自動嘗試不同的群數和形狀，用 BIC 挑出最好的模型
#   （BIC 兼顧「配適得好」和「模型簡單」，mclust 中 BIC 越大越好）
install.packages("mclust")
#  每次執行都會重新安裝；建議改成 if (!require("mclust")) install.packages("mclust")
library(mclust)
result_iris_mc =  Mclust(iris_sample)
#  預設試 1 ~ 9 群、14 種形狀，全部自動比較
summary(result_iris_mc) # display the best model
#> Mclust VEV (ellipsoidal, equal shape) model with 2 components:
#>  log-likelihood   n df       BIC       ICL
#>        -215.726 150 26 -561.7285 -561.7289
#> Clustering table:
#>   1   2
#>  50 100
#  BIC 選出的最佳模型是「2 群」：setosa 50 朵一群，versicolor 和 virginica 合成 100 朵一群
#  VEV 是形狀代碼：各群是橢圓形、形狀相同，但大小和方向可以不同
#  在完全不知道答案的情況下，從資料來看，iris 最自然的分法其實是 2 群
#  想強制分成 3 群：Mclust(iris_sample, G = 3)
plot(result_iris_mc) # plot results
#  ⚠️ 在 RStudio 中執行時，主控台會出現選單，要輸入數字選擇要畫哪一種圖：
#     1: BIC（各模型、各群數的 BIC 比較）  2: classification（分群結果）
#     3: uncertainty（不確定性）           4: density（密度）     0: 離開
#  也可以直接指定：plot(result_iris_mc, what = "classification")

# ------------------------------------------------------------
# 第四部分：自組織映射 SOM
# ------------------------------------------------------------
#########################################
#Self Organizing Maps 以類神經網路分群
#SOM(data, grid = somgrid(), rlen = 10000, alpha, radii, init)
#scale(x, center = TRUE, scale = TRUE) center:SD(T) or mean square(F)
#                                      scale:
# center 中心化，即減去均數
# scale 標準化，即除以這組數的均方根
#########################################
# 【補充】SOM 準備一張網格（例如 5 × 5 = 25 格），每格是一個「神經元」。
#   訓練時，每筆資料找最像的格子，並讓那格和附近的格子都往這筆資料靠近。
#   最後相似的資料會落在同一格或相鄰的格子，就像把高維資料攤平成一張地圖。
#
# 【scale() 的參數更精確的說明】
#   center = TRUE ：每個值減去平均數（中心化）
#   scale  = TRUE ：再除以一個數：
#       有中心化時，除以標準差 → 結果平均 0、標準差 1（這就是 z 分數標準化）
#       沒中心化時，除以均方根 √(Σx² / (n-1))
#先將資料中心化及標準化
a=scale(iris$Sepal.Length,center = TRUE, scale = TRUE)
#  中心化 + 除以標準差 → z 分數
b=scale(iris$Sepal.Length,center = T, scale = F)
#  只減去平均數
c=scale(iris$Sepal.Length,center = F, scale = TRUE)
#  只除以均方根
d=scale(iris$Sepal.Length,center = F, scale = F)
#  什麼都不做（結果是矩陣格式的原始資料）
#  可以用 mean(a)、sd(a) 檢查：a 的平均約 0、標準差 1
iris_scal=scale(iris_sample) #所有欄位都中心化標準化
#  4 個欄位都轉成 z 分數。SOM 用距離計算，一定要先標準化
##################################
#install.packages("kohonen")
library(kohonen)
#  kohonen 套件提供 som()。第一次使用要先安裝：install.packages("kohonen")
#  載入時「下列物件被遮斷自 'package:mclust': map」是正常訊息

#Plot SOM Fits for IRIS
sg=somgrid(5,5,topo="rectangular")
#  建立 5 × 5 的網格；topo = "rectangular" 方形格子，也可以用 "hexagonal" 六角形
smodel=som(iris_scal,grid=sg)
#  訓練 SOM（每次結果略有不同，因為初始值是隨機的）
plot(smodel,type="codes")
#  每格畫一個扇形圖，顯示這格神經元在 4 個特徵上的值，可以看出地圖上各區的特色
plot(smodel,type="count")
#  每格有幾朵花落在這裡，顏色越深（紅）越多；灰色代表沒有任何資料
summary(smodel)
#> SOM of size 5x5 with a rectangular topology and a bubble neighbourhood function.
#> Training data included: 150 objects.
#> Mean distance to the closest unit in the map: 0.186.
#  每筆資料和它所屬格子的平均距離 0.186，越小代表地圖越能代表資料
som.pred <- predict(smodel, iris_scal)
som.pred$unit.classif
# 顯示出分群結果
som.pred$unit.classif
#  每朵花被分到第幾格（1 ~ 25）。25 格可以視為 25 個小群
#  想和品種對照：table(som.pred$unit.classif, iris$Species)

####Plot SOM Fits for Diamonds
diad_scal=scale(diamond_sample)
#  鑽石資料先標準化
sg=somgrid(xdim=10,ydim=10,topo="rectangular") #rectangular #hexagonal
#  資料比較多，改用 10 × 10 = 100 格
smodel=som(diad_scal,grid=sg)
plot(smodel,type="codes")
plot(smodel,type="count")
summary(smodel)

# ============================================================
# 重點整理
# ============================================================
# | 方法       | 函數                      | 特色                                     |
# |------------|---------------------------|------------------------------------------|
# | 手肘法     | fviz_nbclust(method="wss")| 找 WSS 曲線的轉折點，決定群數            |
# | C-means    | cmeans(x, k)              | 每筆資料有隸屬度，可以部分屬於多群       |
# | EM / Mclust| Mclust(x)                 | 常態混合模型，用 BIC 自動選群數          |
# | SOM        | som(scale(x), grid)       | 類神經網路，把資料排在網格地圖上         |
#
# 分群前記得用 scale() 標準化，避免數值大的欄位主導距離
#
# 練習題
# 1. 把 diamond_sample 標準化後再用 fviz_nbclust 畫手肘圖，和原本的圖比較
# 2. 用 Mclust(iris_sample, G = 3) 強制分成 3 群，再和 iris$Species 做交叉表
# 3. 把 SOM 網格改成 3 × 1（只有 3 格），看看分群結果和品種是否接近
