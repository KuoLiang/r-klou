# ============================================================
# 2-5 資料形狀轉換：melt()（寬變長）與 dcast()（長變寬）
# ============================================================
# 同一份資料可以有兩種擺法：
#   寬格式 (wide)：每個變數一欄，一個人一列 → 適合人閱讀
#   長格式 (long)：所有數值擠在同一欄，另一欄記錄「這是哪個變數」 → 適合畫圖、統計
# reshape2 套件提供：
#   melt()  ：寬 → 長（像把冰塊「融化」攤開，拉長）
#   dcast() ：長 → 寬（像「鑄模」把資料重新排成表格），也可以順便計算平均等統計
#
# 說明：#> 是 R 4.6.1 + reshape2 實際執行的結果。
# ============================================================

if (!require("reshape2")) install.packages("reshape2")
#  如果還沒安裝 reshape2 就自動安裝
library(reshape2)

# ------------------------------------------------------------
# 第一部分：準備一份小資料
# ------------------------------------------------------------
################
#this is the melt
################
df1 <- data.frame(
  SID = c(1, 2, 3, 4),
  Dept = c("CS", "Math", "CS", "Math"),
  Grade = c(2, 2, 3, 4),
  Scores = c(10, 20, 30, 40)
)
#  data.frame(欄名 = 向量, ...) 建立資料框；每個向量的長度必須相同
#  SID 學號、Dept 系別、Grade 年級、Scores 分數
df1
#>   SID Dept Grade Scores
#> 1   1   CS     2     10
#> 2   2 Math     2     20
#> 3   3   CS     3     30
#> 4   4 Math     4     40

# ------------------------------------------------------------
# 第二部分：melt() 寬變長
# ------------------------------------------------------------
### melt to cols with Col_Name and values
#wide to long ,伸長, 把欄位名稱變成新欄位的值
#melt(data,id.vars,measure.vars,variable.name = "variable")
# 【補充】melt 的三個重要參數：
#   id.vars       ：保持不動、當作識別用的欄位（例如學號）
#   measure.vars  ：要被「拉長」的欄位
#   variable.name ：新欄位的名稱，用來存放「原本的欄位名稱」
#   數值會放在另一個新欄位 value
#   （範例中寫 id、measure、variable 是簡寫，R 允許參數名稱只寫開頭）

df_long <- melt(df1,
             measure =c("SID", "Dept","Grade","Scores"),   #哪些"欄位名稱"需要變成值,依序往下伸長
             variable = c("Col_Name"))   #以上欄位名稱變成新欄位的值後，該欄的新名稱
df_long
#  四個欄位全部拉長：4 列 × 4 欄 = 16 列
#  Col_Name 記錄「原本是哪一欄」，value 記錄「原本的值」
#  注意：因為 Dept 是文字，所有 value 都會變成文字型態
#>    Col_Name value
#> 1       SID     1
#> 2       SID     2
#> 3       SID     3
#> 4       SID     4
#> 5      Dept    CS
#> 6      Dept  Math
#> 7      Dept    CS
#> 8      Dept  Math
#> 9     Grade     2
#> 10    Grade     2
#> 11    Grade     3
#> 12    Grade     4
#> 13   Scores    10
#> 14   Scores    20
#> 15   Scores    30
#> 16   Scores    40

df_long1 <- melt(df1,
                id = c("SID","Dept"),           #固定指定欄位設為 ID,分別對應其它欄位
                measure =c("Grade","Scores"),   #哪些"欄位名稱"需要變成值,依序往下伸長
                variable = c("Col_Name"))   #以上欄位名稱變成新欄位的值後，該欄的新名稱
df_long1
#  SID、Dept 固定不動，只拉長 Grade、Scores → 4 人 × 2 欄 = 8 列
#  這是最常見的用法：每列代表「某個人的某一項數值」
#>   SID Dept Col_Name value
#> 1   1   CS    Grade     2
#> 2   2 Math    Grade     2
#> 3   3   CS    Grade     3
#> 4   4 Math    Grade     4
#> 5   1   CS   Scores    10
#> 6   2 Math   Scores    20
#> 7   3   CS   Scores    30
#> 8   4 Math   Scores    40

df_long2 <- melt(df1,
                id=c("SID"),                 #固定指定欄位設為 ID,分別對應其它欄位
                measure =c("Dept","Scores"),   #只挑部分"欄位名稱"需要變成值,依序往下伸長
                variable = c("Col_Name"))   #原來欄位名稱變成值後，該欄的新名稱
df_long2
#  只用 SID 當識別，拉長 Dept 和 Scores；Grade 沒有被指定，所以被丟掉了
#>   SID Col_Name value
#> 1   1     Dept    CS
#> 2   2     Dept  Math
#> 3   3     Dept    CS
#> 4   4     Dept  Math
#> 5   1   Scores    10
#> 6   2   Scores    20
#> 7   3   Scores    30
#> 8   4   Scores    40

# ------------------------------------------------------------
# 第三部分：dcast() 長變寬、做交叉表
# ------------------------------------------------------------
### dcast
#long to wide, 變寬
# Reshape data from long to wide format using dcast
# formula : rowvar1 + rowvar2 +...  ~  colvar1 + colvar2 +...
# 【補充】公式「列 ~ 欄」：
#   波浪號 ~ 左邊的欄位變成「列」，右邊的欄位的值變成「新欄位名稱」
#   value.var = 要填進表格裡的數值欄位
#   第 4 個參數可以放彙總函數（mean、sum、length...），同一格有多個值時用它計算

df_wide <- dcast(df1, SID ~ Dept, value.var = "Scores") #Y~X 指定 Y 軸 X 軸
df_wide
#  每個學號一列，系別 CS、Math 變成欄位，格子裡填分數
#  NA 表示「這個學生不屬於這個系」，所以沒有值
#>   SID CS Math
#> 1   1 10   NA
#> 2   2 NA   20
#> 3   3 30   NA
#> 4   4 NA   40

df_wide <- dcast(df1, Dept ~ Grade, value.var = "Scores",mean) #Y為各系，X為年級，求平均
df_wide
#  列 = 系別，欄 = 年級，格子 = 平均分數
#  NaN (Not a Number) 表示這個格子沒有資料，算平均時是 0 ÷ 0
#>   Dept  2   3   4
#> 1   CS 10  30 NaN
#> 2 Math 20 NaN  40

df_wide <- dcast(df1, Dept ~ ., value.var = "Scores",mean) #各系平均
df_wide
#  ~ 右邊放一個點 . 代表「不分欄」，只依系別算平均
#  CS：(10+30)/2 = 20；Math：(20+40)/2 = 30
#>   Dept  .
#> 1   CS 20
#> 2 Math 30

df_wide2 <- dcast(df1, SID ~ Dept+Grade, value.var = "Scores") #Y~X 指定 Y 軸 X 軸
df_wide2
#  右邊用 + 組合兩個欄位，產生「系別_年級」的新欄位名稱
#>   SID CS_2 CS_3 Math_2 Math_4
#> 1   1   10   NA     NA     NA
#> 2   2   NA   NA     20     NA
#> 3   3   NA   30     NA     NA
#> 4   4   NA   NA     NA     40

# ------------------------------------------------------------
# 第四部分：把長格式還原回寬格式
# ------------------------------------------------------------
################
#將 melt 反向 cast 回原來的 df ,原來有 id 者才能設為 Y 反回
df_long1
df_orig <- dcast(df_long1, SID + Dept ~ Col_Name) #Y~X 指定 Y 軸 X 軸
df_orig
#  melt 時的 id（SID、Dept）放在 ~ 左邊，Col_Name 放右邊，就能完全還原
#  沒寫 value.var 時，dcast 會自動使用名為 value 的欄位
#>   SID Dept Grade Scores
#> 1   1   CS     2     10
#> 2   2 Math     2     20
#> 3   3   CS     3     30
#> 4   4 Math     4     40

#將 melt 反向 cast 回原來的 df (但少了 Grade)
df_long2
df_orig <- dcast(df_long2, SID ~ Col_Name) #Y~X 指定 Y 軸 X 軸
df_orig
#  df_long2 在 melt 時就丟掉了 Grade，所以還原後也沒有 Grade
#  另外 Scores 現在是「文字」型態（因為 melt 時和 Dept 擠在同一欄）
#  要計算前需轉回數字：df_orig$Scores <- as.numeric(df_orig$Scores)
#>   SID Dept Scores
#> 1   1   CS     10
#> 2   2 Math     20
#> 3   3   CS     30
#> 4   4 Math     40

# ============================================================
# 重點整理
# ============================================================
# | 函數    | 方向    | 關鍵參數                               |
# |---------|---------|----------------------------------------|
# | melt()  | 寬 → 長 | id（固定欄）、measure（要拉長的欄）    |
# | dcast() | 長 → 寬 | 公式 列 ~ 欄、value.var、彙總函數      |
#
# 小技巧：dcast(資料, A ~ B, value.var = "X", mean) 就是一張「A × B 的平均數交叉表」，
#         類似 Excel 的樞紐分析表。
# （新版 tidyverse 中對應的函數是 tidyr 的 pivot_longer() 和 pivot_wider()）
#
# 練習題
# 1. 用 dcast 算出各系的「分數總和」（提示：把 mean 換成 sum）
# 2. 用 dcast 算出各系有幾個學生（提示：用 length）
# 3. 把 df1 的 Grade 和 Scores 拉長，但只保留 SID 當 id，結果會有幾列？
