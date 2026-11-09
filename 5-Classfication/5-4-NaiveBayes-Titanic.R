# ============================================================
# 5-4 單純貝氏分類器：預測鐵達尼號乘客是否生還
# ============================================================
# 使用 R 內建的 Titanic 資料，根據乘客的艙等、性別、年齡，預測是否生還。
# 這個範例的特色：
#   1. 原始資料是「彙總表」（每種組合有幾個人），要先展開成「一人一列」
#   2. 所有特徵都是類別資料，單純貝氏直接計算各類別出現的比例
#
# 說明：#> 是 R 4.6.1 實際執行的結果。
# ============================================================

if(!require("e1071")) install.packages("e1071")
library(e1071)
?naiveBayes
#  打開 naiveBayes 的說明文件

# ------------------------------------------------------------
# 第一部分：把彙總表展開成一人一列
# ------------------------------------------------------------
data("Titanic")
#  Titanic 是一個 4 維的表格 (table)：
#    Class 艙等 (1st, 2nd, 3rd, Crew 船員) × Sex 性別 × Age 年齡 (Child, Adult) × Survived 是否生還

Titanic_df=as.data.frame(Titanic)
#  轉成資料框：4 × 2 × 2 × 2 = 32 列，每列是一種組合，Freq 欄是人數
#  例如「1st, Male, Child, No, 0」代表頭等艙男童沒有生還的人數是 0


repeating_sequence=rep.int(seq_len(nrow(Titanic_df)), Titanic_df$Freq)
#This will repeat each combination equal to the frequency of each combination
#  seq_len(32) 產生 1~32 的列號；rep.int(列號, 次數) 把每個列號重複「人數」次
#  例如第 3 列的 Freq 是 35，列號 3 就重複 35 次
#  總共 2201 個列號，對應船上 2201 人
#Create the dataset by row repetition created
Titanic_dataset=Titanic_df[repeating_sequence,]
#  依照這些列號取資料 → 一人一列，共 2201 列
Titanic_dataset
#  印出來很長（2201 列）
#We no longer need the frequency, drop the feature
Titanic_dataset$Freq=NULL
#  Freq 欄已經沒用了，設為 NULL 刪除

# ------------------------------------------------------------
# 第二部分：建立模型並預測
# ------------------------------------------------------------
#Fitting the Naive Bayes model
Naive_Bayes_Model=naiveBayes(Survived ~., data=Titanic_dataset)
#  用艙等、性別、年齡預測 Survived（生還 Yes / 沒有生還 No）
#What does the model say? Print the model summary
Naive_Bayes_Model
#> A-priori probabilities:
#> Y
#>       No      Yes
#> 0.676965 0.323035
#  事前機率：全部乘客中 67.7% 沒有生還、32.3% 生還
#> Conditional probabilities:
#>      Class
#> Y            1st        2nd        3rd       Crew
#>   No  0.08187919 0.11208054 0.35436242 0.45167785
#>   Yes 0.28551336 0.16596343 0.25035162 0.29817159
#  讀法：在「沒有生還」的人當中，8.2% 是頭等艙、45.2% 是船員；
#        在「生還」的人當中，28.6% 是頭等艙
#>      Sex
#> Y           Male     Female
#>   No  0.91543624 0.08456376
#>   Yes 0.51617440 0.48382560
#  沒有生還的人 91.5% 是男性；生還的人男女約各半
#>      Age
#> Y          Child      Adult
#>   No  0.03489933 0.96510067
#>   Yes 0.08016878 0.91983122
#  從這些比例可以看出「婦女和小孩優先」：女性、兒童、頭等艙的生還比例較高
NB_Predictions=predict(Naive_Bayes_Model,Titanic_dataset)
#  用模型預測每個人是否生還
#  （注意：這裡用「訓練資料」本身來預測，沒有切測試集，正確率會偏樂觀）
table(NB_Predictions,Titanic_dataset$Survived)
#  混淆矩陣：列 = 預測，欄 = 真實
#> NB_Predictions   No  Yes
#>            No  1364  362
#>            Yes  126  349
#  預測正確：1364 + 349 = 1713 人；正確率 = 1713 / 2201 ≈ 77.8%
#  362 人其實生還了，但被預測為沒有生還（多半是男性）
NB_Predictions
#  印出 2201 個預測結果

# ============================================================
# 重點整理
# ============================================================
# 1. 彙總表要先用 as.data.frame() + rep.int() 展開成一人一列，才能建模
# 2. 類別特徵的條件機率，就是「在每個結果下，各類別所佔的比例」
# 3. 混淆矩陣對角線加總 ÷ 總數 = 正確率
#
# 練習題
# 1. 用 sum(diag(table(NB_Predictions, Titanic_dataset$Survived))) / nrow(Titanic_dataset) 計算正確率
# 2. 先切 80% 訓練集、20% 測試集再建模（參考 5-3），正確率會差多少？
# 3. 預測一位「頭等艙、女性、成人」是否生還：
#    predict(Naive_Bayes_Model, data.frame(Class = "1st", Sex = "Female", Age = "Adult"), type = "raw")
