# ============================================================
# Titanic.R：用關聯規則分析鐵達尼號的生還因素
# ============================================================
# 把每位乘客的艙等、性別、年齡、是否生還，當作一個「購物籃」，
# 用 apriori 找出像「頭等艙女性 => 生還」這樣的規則，並用 arulesViz 畫圖。
#
# 這個範例教你：
#   1. 把彙總表展開成一人一列（和 5-4 範例相同的資料，不同的做法）
#   2. 用 apriori() 找規則，並指定後項只能是「生還與否」
#   3. 用 lift 排序，找出最有意義的規則
#   4. 用 arulesViz 畫散布圖、網路圖、平行座標圖
#
# 說明：#> 是 R 4.6.1 + arules + arulesViz 1.5.4 實際執行的結果。
#       關聯規則的三個指標（support、confidence、lift）說明請見 arule_註解.R
# ============================================================
#  arulesViz：關聯規則的視覺化套件。兩個套件都要先安裝：
#  install.packages(c("arules", "arulesViz"))
library(arules)
library(arulesViz)


# ------------------------------------------------------------
# 第一部分：把彙總表展開成一人一列
# ------------------------------------------------------------
str(Titanic)  #display the structure 32objects, 5 variables
#  Titanic 其實是一個 4 維的表格 (table)，4 × 2 × 2 × 2 = 32 格，每格是人數
#>  'table' num [1:4, 1:2, 1:2, 1:2] 0 0 35 0 0 0 17 0 118 154 ...
#>  - attr(*, "dimnames")=List of 4
#>   ..$ Class   : chr [1:4] "1st" "2nd" "3rd" "Crew"
#>   ..$ Sex     : chr [1:2] "Male" "Female"
#>   ..$ Age     : chr [1:2] "Child" "Adult"
#>   ..$ Survived: chr [1:2] "No" "Yes"
Titanic.df <- as.data.frame(Titanic)
#  轉成資料框：32 列 × 5 欄（Class、Sex、Age、Survived、Freq 人數）
Titanic.df

Titanic.raw=NULL
#  先建立一個空物件，等一下把欄位一個一個接上去
for(i in 1:4)   #共有四欄,第五欄不用
{
  Titanic.raw = cbind(Titanic.raw,
                      rep(as.character(Titanic.df[,i]),
                          Titanic.df$Freq))
}
#  for 迴圈處理前 4 欄（第 5 欄 Freq 是人數，不需要）：
#    rep(第 i 欄的值, 人數)：每個值依照人數重複，例如某一列有 35 人，就重複 35 次
#    cbind()：把展開後的欄位接在右邊
#  結果是 2201 列 × 4 欄的「文字矩陣」，每列一位乘客
Titanic.raw
#  矩陣的欄位沒有名稱，顯示為 [,1] [,2] [,3] [,4]
Titanic.raw = as.data.frame(Titanic.raw)
#  矩陣轉成資料框
names(Titanic.raw) = names(Titanic.df)[1:4]
#  加上欄位名稱：Class、Sex、Age、Survived
Titanic.raw.factor <- as.data.frame(unclass(Titanic.raw),                     # Convert all columns to factor
                       stringsAsFactors = TRUE) #convert to factor
#  把所有文字欄位轉成 factor。apriori() 需要 factor 才能把每個值當成一個「項目」
#  （項目會命名為「欄位=值」，例如 Sex=Female）
#  【補充】更簡潔的寫法（和 5-4 相同）：
#   Titanic.raw.factor <- Titanic.df[rep(1:nrow(Titanic.df), Titanic.df$Freq), 1:4]

# ------------------------------------------------------------
# 第二部分：用預設參數找規則
# ------------------------------------------------------------
rules.all <- apriori(Titanic.raw.factor)
#  沒有指定參數時，預設 support ≥ 0.1、confidence ≥ 0.8
#  執行時會印出參數和進度：
#> Absolute minimum support count: 220
#  至少要有 2201 × 0.1 ≈ 220 人符合
#> writing ... [27 rule(s)] done [0.00s].
rules.all
#> set of 27 rules
inspect(rules.all)
#>      lhs                                     rhs           support   confidence coverage
#> [1]  {}                                   => {Age=Adult}   0.9504771 0.9504771  1.0000000
#> [2]  {Class=2nd}                          => {Age=Adult}   0.1185825 0.9157895  0.1294866
#>  ...
#> [7]  {Class=Crew}                         => {Sex=Male}    0.3916402 0.9740113  0.4020900
#>  ...
#> [13] {Class=3rd, Sex=Male}                => {Survived=No} 0.1917310 0.8274510  0.2317129
#>  ...（共 27 條，lift 和 count 印在下方，省略）...
#  很多規則的後項都是 Age=Adult：因為 95% 的乘客都是成人，什麼條件都容易推到「成人」，
#  這類規則 lift 接近 1，沒什麼意義。
#  第 7 條「船員 => 男性」的 lift 是 1.24，才是比較有資訊的規則
#  （另外，27 條中有 15 條是「冗餘規則」，可以用 rules.all[!is.redundant(rules.all)] 去掉）

# ------------------------------------------------------------
# 第三部分：視覺化
# ------------------------------------------------------------
plot(rules.all,engine = "interactive")

#     （互動模式要在 RStudio 的圖形視窗中用滑鼠點選區域，查看選到的規則；
#      在無法互動的環境下會出現 Not a unit object 之類的錯誤）
#     也可以用 engine = "htmlwidget" 畫出可以滑鼠移上去看規則內容的網頁圖
x <- rules.all@quality$support
y <- rules.all@quality$confidence
#  @quality：規則物件中存放各指標的地方（S4 物件用 @ 取出內容）
#  也可以寫成 quality(rules.all)$support


plot(rules.all, engine = "base", jitter = 0)
text(x, y, rownames(rules.all@quality))
plot(rules.all, method="graph")
#  網路圖：每個圓圈代表一條規則（大小 = support、顏色 = lift），
#  箭頭從前項的項目指向規則、再指向後項的項目。規則多時會很擠



# ------------------------------------------------------------
# 第四部分：只找「生還與否」的規則
# ------------------------------------------------------------
rules <- apriori(Titanic.raw.factor, control = list(verbose=F),
                 parameter = list(minlen=2, supp=0.005, conf=0.8),
                 appearance = list(rhs=c("Survived=No", "Survived=Yes"),
                                   default="lhs"))
#  control = list(verbose = F)：不要印出執行過程
#  parameter：
#    minlen = 2   ：規則至少包含 2 個項目（前項不能是空的 {}）
#    supp = 0.005 ：支持度降到 0.5%（約 11 人），才找得到「頭等艙女童」這類人數少的組合
#    conf = 0.8   ：信賴度 ≥ 80%
#  appearance：
#    rhs = c("Survived=No", "Survived=Yes")：後項只能是生還或沒生還
#    default = "lhs"：其他所有項目只能出現在前項
#  這樣找到的規則，全都是在回答「什麼樣的人會生還 / 不會生還」
rules.sorted <- sort(rules, by="lift")
#  依 lift 排序，最有意義的規則排在前面
inspect(rules.sorted)
#>      lhs                                    rhs            support     confidence
#> [1]  {Class=2nd, Age=Child}              => {Survived=Yes} 0.010904134 1.0000000
#> [2]  {Class=2nd, Sex=Female, Age=Child}  => {Survived=Yes} 0.005906406 1.0000000
#> [3]  {Class=1st, Sex=Female}             => {Survived=Yes} 0.064061790 0.9724138
#> [4]  {Class=1st, Sex=Female, Age=Adult}  => {Survived=Yes} 0.063607451 0.9722222
#> [5]  {Class=2nd, Sex=Female}             => {Survived=Yes} 0.042253521 0.8773585
#>  ...
#> [12] {Class=3rd, Sex=Male}               => {Survived=No}  0.191731031 0.8274510
#>      coverage    lift     count
#> [1]  0.010904134 3.095640  24
#> [2]  0.005906406 3.095640  13
#> [3]  0.065879146 3.010243 141
#>  ...（共 12 條，省略）...
#  第 1 條：二等艙的兒童 24 人「全部」生還（信賴度 100%），lift 3.1 代表生還機會是全體平均的 3 倍
#  第 3 條：頭等艙女性 97.2% 生還
#  最後一條：三等艙男性 82.7% 沒有生還
#  結論和歷史記載一致：「婦女和兒童優先」，而且艙等越高越容易生還
#  另外注意第 2 條是第 1 條加上 Sex=Female，資訊重複（冗餘規則）

plot(rules.all, method="paracoord",
     control=list(reorder=TRUE))
#  平行座標圖：每條規則畫成一條折線，從前項的各項目連到後項，線越粗 / 越深代表 lift 越高
#  reorder = TRUE：自動調整項目的排列順序，減少線條交叉
#  （這裡畫的是 rules.all；想畫上面找到的生還規則，可以改成 rules.sorted）
plot(rules.sorted, method="paracoord",
     control=list(reorder=TRUE))
# ============================================================
# 重點整理
# ============================================================
# | 參數 / 函數                          | 用途                              |
# |--------------------------------------|-----------------------------------|
# | parameter = list(supp, conf, minlen) | 篩選規則的門檻                    |
# | appearance = list(rhs = ..., default = "lhs") | 限定後項只能是某些項目   |
# | sort(規則, by = "lift")              | 依提升度排序                      |
# | is.redundant(規則)                   | 找出冗餘規則                      |
# | plot(規則)                           | 散布圖（engine = "base" 才能用 text()）|
# | plot(規則, method = "graph")         | 網路圖                            |
# | plot(規則, method = "paracoord")     | 平行座標圖                        |
#
# 練習題
# 1. 去掉冗餘規則：rules.pruned <- rules.sorted[!is.redundant(rules.sorted)]，剩下幾條？
# 2. 把 conf 降到 0.6，會多出哪些關於生還的規則？
# 3. 用 plot(rules.sorted, method = "graph") 畫出生還規則的網路圖
