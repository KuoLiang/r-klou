if(! require("e1071")) install.packages("e1071")
library(e1071)
# ============================================================
# 5-5 支持向量機 (Support Vector Machine, SVM)：iris 與 diamonds
# ============================================================
# 【什麼是 SVM？】
#   在資料之間畫一條「邊界」把不同類別分開，而且讓邊界離兩邊的資料「越遠越好」
#   （這段空隙叫 margin）。最靠近邊界、決定邊界位置的那些點，就叫「支持向量」。
#   資料無法用直線分開時，SVM 用「核函數 (kernel)」把資料轉換到更高維度，
#   在那裡找邊界，轉回來看就變成彎曲的邊界。
#
# 這個範例教你：
#   1. 用 svm() 建模，選擇不同的 kernel
#   2. 用 plot() 畫出 SVM 的分類邊界
#   3. 兩種寫法：公式 Y ~ X，或分開指定 x、y
#   4. 用 tune() 搜尋最好的參數 cost 和 gamma
#   5. 用 diamonds 示範較大的資料（執行要幾分鐘）
#
# 說明：#> 是 R 4.6.1 實際執行的結果。
#       前半段的 sample() 沒有固定亂數種子，抽到的 10 筆每次都不同。
# ============================================================

# ------------------------------------------------------------
# 第一部分：建立 SVM 模型並畫出邊界
# ------------------------------------------------------------
########################
#SVM
########################
## classification mode
# default with factor response: 正規寫法
model <- svm(Species ~ ., data = iris,
             kernel = "polynomial")
#kernel = linear,polynomial,radial,sigmoid
#  Species 是 factor，所以 svm() 自動做「分類」；如果 Y 是數字，則會做「迴歸」
#  kernel 核函數：
#    linear 線性（直線邊界）、polynomial 多項式、radial 徑向基（最常用，預設值）、sigmoid

summary(model)
#> Parameters:
#>    SVM-Type:  C-classification
#>  SVM-Kernel:  polynomial
#>        cost:  1
#>      degree:  3
#> Number of Support Vectors:  54
#>  ( 6 26 22 )
#  共 54 個支持向量：setosa 6 個、versicolor 26 個、virginica 22 個
#  setosa 很容易分開，只需要很少的點就能決定邊界；另外兩種靠得近，需要比較多
plot(model,iris,Petal.Length~Petal.Width)
#  plot(模型, 資料, Y軸 ~ X軸)：畫出兩個特徵平面上的分類區域
#  背景顏色 = 模型預測的品種區域；x 符號 = 支持向量；o 符號 = 一般資料點
plot(model,iris,Petal.Length~Sepal.Width)
plot(model,iris,Petal.Length~Sepal.Length)
plot(model,iris,Sepal.Width~Sepal.Length)
#  換不同的特徵組合觀察。花萼 (Sepal) 的組合比較難把三種花分開

plot(model, iris, Petal.Width ~ Petal.Length)
#解析度 grid =50 , 其它維度切片slice (list object)  0 by default
# 【補充】模型用了 4 個特徵，但圖只能畫 2 個。
#   沒畫出來的另外 2 個特徵，要固定在某個值（這叫「切片」slice），預設都是 0。
#   因為花萼長寬不可能是 0，預設的背景區域可能和實際情況不太一樣

plot(model, iris, Petal.Width ~ Petal.Length, grid=100,
     slice = list(Sepal.Width = 3,Sepal.Length = 4))
#  grid = 100：背景切得更細，邊界比較平滑
#  slice：把沒畫出的兩個特徵固定在 Sepal.Width = 3、Sepal.Length = 4
plot(model, iris, Petal.Width ~ Petal.Length, grid=50,
     slice = list(Sepal.Width = 3.1,Sepal.Length = 4.1))
#  切片值稍微改變，背景區域也會跟著變化

plot(model, iris, Sepal.Width ~ Petal.Width,
     slice = list(Sepal.Length = 3, Petal.Length = 4))


# ------------------------------------------------------------
# 第二部分：預測與兩種寫法
# ------------------------------------------------------------
########################
#predict with svm model
########################
x <- subset(iris, select = -Species)
#  x：特徵，去掉 Species 的 4 個欄位
y <- iris$Species
#  y：答案（factor 向量）
model <- svm(Species ~ ., data = iris) #kernel default = radial
#  不指定 kernel，預設用 radial
pred_result <- predict(model, x)
table(pred_result,y)
#>             y
#> pred_result  setosa versicolor virginica
#>   setosa         50          0         0
#>   versicolor      0         48         2
#>   virginica       0          2         48
#  用訓練資料自己預測：150 朵對 146 朵 (97.3%)
#plot(x, data, formula, fill = TRUE, grid = 50, slice = list(),
#     symbolPalette = palette(), svSymbol = "x", dataSymbol = "o", ...)
#see ?plot.svm()



# alternatively the traditional interface: f(x)=y ；y為依變數；x為自變數
x <- subset(iris, select = -Species)
y <- subset(iris, select = Species) #如此 y 為 data frame
#y <- iris$Species #如此 y2 為 vector, not data frame
#  subset(..., select = Species) 得到的是「1 欄的資料框」，不是向量

model <- svm(x, y)           #無法執行，因為不為factor vector
#> Error: Need numeric dependent variable for regression.
#  y 是資料框而不是 factor，svm() 以為要做迴歸，又發現 y 不是數字，所以出錯
model <- svm(x, y$Species)   #ok
#  用 $ 取出 factor 向量就可以了
#############################################


# test with training data
sample_index=sample(nrow(x),10) #抽10個
pred1 <- predict(model, x[sample_index,])  #列出預測結果 using test set
#  這 10 筆是從訓練資料抽出來的，模型已經看過，不是真正的測試集
pred1
#  10 筆的預測結果，上面一行是列號（每次抽到的列號都不同）
# (same as:)
pred2 <- fitted(model) #同上的功能,但用原有的樣本 using training set
#  fitted()：直接取出模型對「全部訓練資料」的預測結果，等於 predict(model, x)
pred2

# Check accuracy:
table(pred1, iris[sample_index,5])  #table 列，欄
#  抽到的 10 筆的混淆矩陣（這次 10 筆全對）
table(pred2, y$Species)  #table 列，欄
#> pred2        setosa versicolor virginica
#>   setosa         50          0         0
#>   versicolor      0         48         2
#>   virginica       0          2         48

# compute decision values and probabilities:#列出機率,可見兩兩比較的二分法
pred11 <- predict(model, x[sample_index,], decision.values = TRUE)
pred21<- predict(model, x, decision.values = TRUE)
#  decision.values = TRUE：同時回傳「決策值」
#  （這不是機率。要機率需要建模時加 probability = TRUE，預測時也加 probability = TRUE）

attr(pred11, "decision.values")[1:10,]  #return a data frame
#>     setosa/versicolor setosa/virginica versicolor/virginica
#> 121        -0.7376231       -1.1654653           -1.6013503
#> 38          1.1720518        1.0683042            0.4820179
#>  ...（省略）...
#  SVM 處理多類別時，是「兩兩比較」：setosa vs versicolor、setosa vs virginica、versicolor vs virginica
#  每一欄的正數代表偏向前面的品種，負數代表偏向後面的品種，最後三場比賽投票決定
#  例如第 38 列三欄都是正數 → 兩場都贏的 setosa 勝出
attr(pred21, "decision.values")  #all attributes
#  全部 150 筆的決策值

# ------------------------------------------------------------
# 第三部分：用 tune() 調整參數
# ------------------------------------------------------------
#### 調校參數

if(!require("mlbench")) install.packages("mlbench")
library("mlbench")
#  mlbench 是機器學習的練習資料集套件（這個範例其實沒有用到它）
#gamma = how far the influence of s single training example reaches
#cost = 懲罰值
tune.model = tune(svm,
                  Species~.,
                  data=iris,
                  kernel="radial",
                  range=list(cost=10^(-1:2), gamma=c(.5,1,2))# 調參數的最主要一行
)
#  tune(演算法, 公式, data, ..., ranges = 要試的參數)
#  cost = 10^(-1:2) = 0.1, 1, 10, 100；gamma = 0.5, 1, 2 → 共 4 × 3 = 12 種組合
#  每種組合都用 10 折交叉驗證計算錯誤率
#  （正式的參數名稱是 ranges，這裡寫 range 也能用，因為 R 允許參數名稱只寫開頭）
plot(tune.model) #右方 error 愈小愈好（深色）
#  熱圖：橫軸 cost、縱軸 gamma，顏色代表錯誤率
summary(tune.model) #cost = 1; gamma = 0.5 are the best parameters
#> - best parameters:
#>  cost gamma
#>     1   0.5
#> - best performance: 0.03333333
#> - Detailed performance results:
#>     cost gamma      error dispersion
#> 1    0.1   0.5 0.05333333 0.06126244
#> 2    1.0   0.5 0.03333333 0.04714045
#>  ...（共 12 列，省略）...
#  best performance 是「錯誤率」：0.033 代表交叉驗證正確率 96.7%
#  dispersion 是 10 次結果的標準差
#  （交叉驗證的分組是隨機的，每次執行最佳參數可能略有不同）
model2 <- svm(Species ~ ., data = iris,
              kernel="radial",cost = 1, gamma = 0.5 )

pred23 <- predict(model2, x, decision.values = TRUE) #列出機率
table(pred23, y$Species) #tuned prediction
#> pred23       setosa versicolor virginica
#>   setosa         50          0         0
#>   versicolor      0         49         3
#>   virginica       0          1         47
table(pred21, y$Species) #previous prediction
#> pred21       setosa versicolor virginica
#>   setosa         50          0         0
#>   versicolor      0         48         2
#>   virginica       0          2         48
#  兩者都錯 4 朵。「調參後」沒有變好，部分原因就是 kernel 不一致


# ------------------------------------------------------------
# 第四部分：diamonds（較大的資料）
# ------------------------------------------------------------
###########################
#diaminds
###########################
library(ggplot2)
data(diamonds)
plot(diamonds$carat,diamonds$price)
#  重量對價格的散布圖（5 萬多個點，畫圖要等一下）
set.seed(2025)
sample_index= sample(nrow(diamonds),size=10000)
sample_data = diamonds[sample_index,]
#  抽 10000 顆來建模
tune.model = tune(svm,
                  color ~.,
                  data=sample_data,
                  kernel="radial",
                  range=list(cost=c(1,10), gamma=c(0.1,1))
)
#  2 × 2 = 4 種組合，每種做 10 折交叉驗證 → 要建 40 個 SVM 模型
#  實測約 4 分鐘
################################
#be careful of time consuming (it may cost 5 mins or more)
################################
# 調參數的最主要一行
# cost 處罰系數,愈大時代表愈不能容忍誤判,會使用MARGIN變小,易overfitting
# cost 愈小, margin 愈大
# gamma 影響系數,GAMMA愈大時,近點的影響力大,超平面會考慮近點,易overfitting
# gamma 愈小，平面愈平滑
plot(tune.model)
summary(tune.model)
#> - best parameters:
#>  cost gamma
#>    10   0.1
#> - best performance: 0.6326
#>   cost gamma  error dispersion
#> 1    1   0.1 0.6923 0.01681302
#> 2   10   0.1 0.6326 0.01895140
#> 3    1   1.0 0.7177 0.01295334
#> 4   10   1.0 0.6953 0.01173835
#  最佳組合的交叉驗證錯誤率 63.3%，也就是正確率約 36.7%
model_diamond <- svm(color ~ ., data = sample_data,
                     kernel="radial",cost = 10, gamma = 0.1 )
#  用最佳參數建模（約 7 秒）
pred_diamond <- predict(model_diamond, sample_data, decision.values = TRUE) #列出機率
table(pred_diamond,sample_data$color)

# give a detail of confusion matrix and evaluation
conf <- caret::confusionMatrix(data=pred_diamond, reference = sample_data$color)
conf
#>                Accuracy : 0.4666
#>     No Information Rate : 0.2074
#>                   Kappa : 0.3574
#  用訓練資料自己預測，正確率 46.7%，比 5-2、5-3 的約 22% 好很多（SVM 能抓到比較複雜的關係）
#  但要注意：交叉驗證的正確率只有約 36.7%。
#  46.7% 是「考自己做過的題目」，36.7% 才接近模型面對新鑽石的真實表現


model_diamond <- svm(price ~ ., data = sample_data,
                     kernel="radial")
#  price 是數字，svm() 會自動改做「迴歸」（支持向量迴歸 SVR），預測價格
pred_diamond <- predict(model_diamond, sample_data, decision.values = TRUE) #列出機率
table(pred_diamond,sample_data$price) #!!!!! 把價錢當factor ??? 
#以SVM猜數值為錯誤示範
#  用 SVM 預測數字本身沒有錯（這就是 SVR），錯的是「用 table() 評估」：
#     預測值是像 263.326... 這樣的小數，幾乎不可能剛好等於真實價格，
#     table() 會產生上萬列、上千欄、幾乎全是 0 的巨大表格，印出來沒有意義。
#  數值預測應該用誤差來評估
cor(pred_diamond, sample_data$price)^2                 ← R²，越接近 1 越好
sqrt(mean((pred_diamond - sample_data$price)^2))       ← RMSE，越小越好
plot(sample_data$price, pred_diamond)                  ← 點越接近對角線越準

# ============================================================
# 重點整理
# ============================================================
# | 項目               | 說明                                                  |
# |--------------------|-------------------------------------------------------|
# | svm(Y ~ ., data)   | Y 是 factor → 分類；Y 是數字 → 迴歸                   |
# | kernel             | linear、polynomial、radial（預設）、sigmoid           |
# | cost               | 越大越不容忍誤判，邊界越貼近資料，容易過度配適        |
# | gamma              | 越大越受附近的點影響，邊界越彎曲，容易過度配適        |
# | tune()             | 用交叉驗證搜尋參數，best.model 是調好的模型           |
# | 評估分類           | table()、confusionMatrix()                            |
# | 評估數值預測       | R²、RMSE，不要用 table()                              |
#
# 練習題
# 1. 用 tune.model$best.model 直接預測 iris，和 model2 的結果比較
# 2. 把 kernel 改成 "linear"，iris 的支持向量數量會變多還是變少？
# 3. 計算 diamonds 價格預測的 R² 和 RMSE
