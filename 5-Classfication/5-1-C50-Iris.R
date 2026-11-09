##########################################
#Editor: Kuo-Liang Ou
#National Tsing Hua University ILST
##########################################
# ============================================================
# 5-1 決策樹 C5.0：用花的尺寸判斷鳶尾花品種
# ============================================================
# 【什麼是分類 (classification)？】
#   根據已知的特徵（花瓣長、寬…），預測一筆資料屬於哪個「類別」（品種）。
#   做法：先用「答案已知」的資料訓練模型，再拿模型去猜新資料的類別。
#
# 【什麼是決策樹？】
#   像玩「猜猜看」：一連串的是非題，例如
#     「花瓣長度 ≤ 1.9？」→ 是 → setosa
#                         → 否 → 「花瓣寬度 > 1.7？」→ …
#   C5.0 是一種常用的決策樹演算法，用「資訊熵 (entropy)」挑選最能分開類別的問題。
#
# 這個範例教你：
#   1. 先用 subset、boxplot、hist、beanplot 認識資料（和 3-1 相同）
#   2. 用 C5.0 建立決策樹、畫出樹狀圖
#   3. 比較「修剪」和「不修剪」的樹
#   4. 用模型預測，並用混淆矩陣 (confusion matrix) 檢查結果
#
# 說明：#> 是 R 4.6.1 實際執行的結果；圖形用文字描述。
# ============================================================

# ------------------------------------------------------------
# 第一部分：認識資料
# ------------------------------------------------------------
library(datasets) #load built-in dataset
str(iris)       #show structure, notice: the lable attribute must be the factor data type
#  重點：要預測的欄位（標籤 label，這裡是 Species）必須是 factor（類別）型態，
#  分類演算法才知道這是「分類」問題，而不是預測數字
#>  $ Species     : Factor w/ 3 levels "setosa","versicolor",..: 1 1 1 1 1 1 1 1 1 1 ...

subset(iris, Species == "setosa" | Species =="versicolor") # OR
#  | 是「或」：setosa 或 versicolor → 100 列
subset(iris, Species == "setosa" , Species =="versicolor") # 常見錯誤用法
#     這行不是 AND！subset() 的第 3 個參數是 select（要留下哪些欄位），
#     所以 Species == "versicolor" 被當成「選欄位」的條件，結果沒有選到任何欄位：
#> 資料框沒有行但有 50 列
#  也就是「50 列 setosa，但 0 個欄位」
subset(iris, Species == "setosa" & Species =="versicolor") # AND
#  & 才是「且」。同一朵花不可能同時是兩個品種，所以結果是 0 列：
#> <0 列> (或零長度的 row.names)
subset(iris, Species != "setosa" )[1:5,]
#  != 是「不等於」：除了 setosa 以外的前 5 列（從第 51 列 versicolor 開始）
#>    Sepal.Length Sepal.Width Petal.Length Petal.Width    Species
#> 51          7.0         3.2          4.7         1.4 versicolor
#> 52          6.4         3.2          4.5         1.5 versicolor
#>  ...（省略）...

summary(iris)
#  每欄的最小值、四分位數、平均、最大值；Species 各 50 朵

####
# 以下畫圖的部分和 3-1 範例相同，用來觀察「哪個特徵最能區分品種」

par(mar=c(7,5,1,1)) # more space to labels 下左上右 inches
#  mar 的單位其實是「文字行數」，不是英吋
boxplot(iris,las=2)
#  las = 2：x 軸文字直立，欄位名稱比較不會重疊
#  （Species 也被當成數字 1~3 畫了一個箱子，可以忽略）
irisVer <- subset(iris, Species == "versicolor")
irisSet <- subset(iris, Species == "setosa")
irisVir <- subset(iris, Species == "virginica")

par(mfrow=c(1,3),mar=c(6,3,2,1))  #一列三欄
boxplot(irisVer[,1:4], main="Versicolor",ylim = c(0,8),las=2)
boxplot(irisSet[,1:4], main="Setosa",ylim = c(0,8),las=2)
boxplot(irisVir[,1:4], main="Virginica",ylim = c(0,8),las=2)
#  三個品種並排比較：Petal.Length、Petal.Width 差異最明顯
#  → 可以猜到決策樹會優先用花瓣來分類


##

hist(iris$Petal.Length)
#  全部 150 朵的花瓣長度：左邊一群（setosa）和右邊一群明顯分開
par(mfrow=c(1,3))
hist(irisVer$Petal.Length,breaks=seq(0,8,l=17),xlim=c(0,8),ylim=c(0,40))
hist(irisSet$Petal.Length,breaks=seq(0,8,l=17),xlim=c(0,8),ylim=c(0,40))
hist(irisVir$Petal.Length,breaks=seq(0,8,l=17),xlim=c(0,8),ylim=c(0,40))
#  三個品種各自的花瓣長度分布，區間和座標軸都相同，方便比較

##
if (!require("beanplot")) install.packages("beanplot")
library(beanplot)
xiris <- iris
xiris$Species <- NULL
#  刪除 Species 欄，只留 4 個數字欄
beanplot(xiris, main = "Iris flowers",
         col=c('#ff8080','#0000FF','#0000FF','#FF00FF'), border = "#000000")
#  豆莢圖：豆莢越寬代表那附近的資料越多；Petal.Length 明顯有兩個高峰

# ------------------------------------------------------------
# 第二部分：建立 C5.0 決策樹
# ------------------------------------------------------------
###
if (!require("C50")) install.packages("C50")
library(C50)
input <- iris[,1:4]
#  input：用來判斷的特徵（自變數 X），4 個尺寸欄位
output <- iris[,5]
#  output：要預測的答案（依變數 Y），品種
model1 <- C5.0(input, output, control = C5.0Control(noGlobalPruning = TRUE,minCases=1))
#  C5.0(特徵, 答案, control = 設定)
#  noGlobalPruning = TRUE：不做整體修剪，樹會長得比較大
#  minCases = 1：每個葉節點最少只要 1 筆資料就可以再分，樹會分得很細
#  兩者合起來 → 「不修剪」的大樹，容易把訓練資料背得太熟（過度配適 overfitting）
#  這棵樹共 6 個葉節點，訓練資料只錯 2 朵 (1.3%)
plot(model1,main="C5.0 Decision Tree - Unpruned, min=1") #try to change minCases to 3
#  畫出決策樹：最上面是第一個問題，往下一層層分支，
#  最底下的長條圖是每個葉節點中各品種的比例

model2 <- C5.0(input, output, control = C5.0Control(noGlobalPruning = FALSE))
#  noGlobalPruning = FALSE：做修剪（預設值），把不重要的分支剪掉，樹比較小、比較穩定
#  這棵樹只有 4 個葉節點，可以用 summary(model2) 看到文字版的樹：
#> Petal.Length <= 1.9: setosa (50)
#> Petal.Length > 1.9:
#> :...Petal.Width > 1.7: virginica (46/1)
#>     Petal.Width <= 1.7:
#>     :...Petal.Length <= 4.9: versicolor (48/1)
#>         Petal.Length > 4.9: virginica (6/2)
#  括號 (46/1) 代表：這個葉節點有 46 朵花，其中 1 朵分錯
#  第一個問題就是「花瓣長度 ≤ 1.9」，一刀就把 50 朵 setosa 全部分出來
plot(model2, main="C5.0 Decision Tree - Pruned")

# ------------------------------------------------------------
# 第三部分：用模型預測
# ------------------------------------------------------------
newcases <- iris[c(1:3,51:53,101:103),]
#  取出 9 朵花當作「新資料」：每個品種各 3 朵（第 1~3、51~53、101~103 列）
#  （注意：這些花在訓練時已經用過了，比較嚴謹的做法是另外切出測試集，見 5-3 範例）
#newcases2 = data.frame(Sepal.Length=c(1,2,3),Sepal.Width=c(2,3,4),
#                       Petal.Length=c(3,4,5),Petal.Width=c(4,5,6),
#                       Spaecies=c(NA,NA,NA)) #maka a new cases data frame
#above are non-sense iris cases, but you can try it
#  也可以自己用 data.frame() 編造新的花來預測（欄位名稱要和訓練資料相同）

newcases
#>     Sepal.Length Sepal.Width Petal.Length Petal.Width    Species
#> 1            5.1         3.5          1.4         0.2     setosa
#> 2            4.9         3.0          1.4         0.2     setosa
#>  ...（共 9 列，省略）...
predicted <- predict(model1, newcases, type="class")
#  predict(模型, 新資料, type = "class")：預測類別
#  （type = "prob" 則會回傳每個品種的機率）
predicted
#> [1] setosa     setosa     setosa     versicolor versicolor versicolor virginica
#> [8] virginica  virginica
#> Levels: setosa versicolor virginica

#show the paried list by dataframe
result_frame= data.frame(newcases$Species,predicted)
result_frame
#  把「真實品種」和「預測品種」並排，方便逐筆對照
#>   newcases.Species  predicted
#> 1           setosa     setosa
#>  ...（省略）...
result_frame= data.frame(ori=newcases$Species,pre=predicted)
result_frame
#  同上，但自己取欄位名稱 ori（原始）和 pre（預測），比較好讀
#>          ori        pre
#> 1     setosa     setosa
#> 2     setosa     setosa
#>  ...（9 筆全部預測正確）...

# table(x,y) count the match number between two factors objects
# show the confusion matrix
result_table= table(newcases$Species,predicted)
result_table
#  混淆矩陣：列 = 真實品種，欄 = 預測品種
#  對角線（左上到右下）是預測正確的數量，其他格子是預測錯誤
#>             predicted
#>              setosa versicolor virginica
#>   setosa          3          0         0
#>   versicolor      0          3         0
#>   virginica       0          0         3
#  9 筆全部在對角線上 → 100% 正確
#  正確率可以這樣算：sum(diag(result_table)) / sum(result_table)



# ============================================================
# 重點整理
# ============================================================
# | 步驟         | 程式                                      |
# |--------------|-------------------------------------------|
# | 建立模型     | C5.0(特徵, 答案, control = C5.0Control()) |
# | 看樹的結構   | plot(模型)、summary(模型)                 |
# | 預測         | predict(模型, 新資料, type = "class")     |
# | 混淆矩陣     | table(真實, 預測)                         |
#
# 修剪 (pruning)：把不重要的分支剪掉，避免樹太複雜而過度配適
#   noGlobalPruning = TRUE 不修剪；minCases 越小，樹分得越細
#
# 練習題
# 1. 把 minCases 改成 3 或 10，樹的大小有什麼變化？
# 2. 用 type = "prob" 預測 newcases，看看每朵花屬於各品種的機率
# 3. 用 C5.0Control(winnow = TRUE) 讓演算法自動挑選特徵，比較和原本的樹有什麼不同
