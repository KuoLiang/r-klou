# https://en.wikibooks.org/wiki/Data_Mining_Algorithms_In_R/Sequence_Mining/SPADE
# ============================================================
# arulesSequences.R：序列樣式探勘 (Sequential Pattern Mining)
# ============================================================
# 【和一般關聯規則有什麼不同？】
#   一般關聯規則（arule.R、Titanic.R）只看「同一次」出現了什麼，不管順序。
#   序列樣式考慮「時間先後」：同一個人（序列）在不同時間點（事件）做了什麼。
#   例如：先買手機 → 之後買手機殼 → 再買耳機
#   記法：<{手機}, {手機殼}, {耳機}>，大括號內是同一次發生的，逗號分隔先後順序
#
# 這個範例使用 SPADE 演算法（cspade 函數）和 Zaki 論文中的小型範例資料。
#
# 說明：#> 是 R 4.6.1 + arulesSequences 實際執行的結果。
# ============================================================
#install.packages("arulesSequences")
library(arulesSequences)
library(arules)
#  arulesSequences 會自動載入 arules，所以第二行其實可以省略

# ------------------------------------------------------------
# 第一部分：認識資料
# ------------------------------------------------------------
data(zaki)
#zaki data https://github.com/cran/arulesSequences/blob/master/inst/misc/zaki.txt
#  zaki：SPADE 演算法作者 Zaki 論文中的範例，4 位顧客、共 10 次購買紀錄、8 種商品 (A~H)
zaki
#> transactions in sparse format with
#>  10 transactions (rows) and
#>  8 items (columns)
summary(zaki)
#> most frequent items:
#>       A       B       F       C       D (Other)
#>       6       5       5       3       3       5
#  A 出現在 6 次購買中，最常見
#> element (itemset/transaction) length distribution:
#> sizes
#> 1 2 3 4
#> 1 2 6 1
#  每次購買的商品數：1 件的有 1 次、2 件的有 2 次、3 件的有 6 次、4 件的有 1 次
#> includes extended transaction information - examples:
#>   sequenceID eventID SIZE
#>  ...
#  sequenceID = 顧客編號、eventID = 時間點、SIZE = 這次買了幾件
zaki_df = as(zaki, "data.frame")
#  轉成資料框，方便閱讀
zaki_df
#>        items sequenceID eventID SIZE
#> 1      {C,D}          1      10    2
#> 2    {A,B,C}          1      15    3
#> 3    {A,B,F}          1      20    3
#> 4  {A,C,D,F}          1      25    4
#> 5    {A,B,F}          2      15    3
#> 6        {E}          2      20    1
#> 7    {A,B,F}          3      10    3
#> 8    {D,G,H}          4      10    3
#> 9      {B,F}          4      20    2
#> 10   {A,G,H}          4      25    3
#  例如顧客 1：時間 10 買 C、D → 時間 15 買 A、B、C → 時間 20 買 A、B、F → 時間 25 買 A、C、D、F

# ------------------------------------------------------------
# 第二部分：從文字檔讀入序列資料
# ------------------------------------------------------------
#############以下轉換為 transactional data
x = read_baskets(con = system.file("misc", "zaki.txt", package = "arulesSequences"),
                  info = c("sequenceID","eventID","SIZE"))
#  read_baskets()：從文字檔讀入序列資料
#  system.file()：找到套件內附檔案的完整路徑（zaki.txt 和上面的 zaki 資料相同）
#  info：檔案每一行前幾個數字代表什麼，依序是顧客編號、時間點、商品數，後面才是商品
#  實際應用時，可以把 con 換成自己的檔案路徑
x
#> transactions in sparse format with
#>  10 transactions (rows) and
#>  8 items (columns)

# ------------------------------------------------------------
# 第三部分：用 cSPADE 找頻繁序列
# ------------------------------------------------------------
# 以下使用 cspade
s1 = cspade(x, parameter = list(support = 0.4), control = list(verbose = TRUE))
#  cspade()：找出「頻繁序列」
#  support = 0.4：至少 40% 的「顧客」有這個序列（4 位顧客中至少 2 位）
#  注意：這裡的支持度是以「顧客（序列）」計算，不是以「購買次數」計算
#  verbose = TRUE：印出執行過程
s1
#> set of 18 sequences
summary(s1)
#  找到 18 個頻繁序列；最長的包含 4 個商品
#> sequence length distribution:
#> lengths
#> 1 2 3 4
#> 4 8 5 1
### 以下較容易閱讀
as(s1, "data.frame")
#>           sequence support
#> 1            <{A}>    1.00
#> 2            <{B}>    1.00
#> 3            <{D}>    0.50
#> 4            <{F}>    1.00
#> 5          <{A,F}>    0.75
#> 6          <{B,F}>    1.00
#> 7        <{D},{F}>    0.50
#>  ...
#> 17 <{D},{B,F},{A}>    0.50
#> 18   <{D},{B},{A}>    0.50
#  讀法：
#    <{A}>  support 1.00：4 位顧客全都買過 A
#    <{B,F}> 1.00：4 位顧客都曾在「同一次」買 B 和 F
#    <{D},{F}> 0.50：一半的顧客「先」買了 D，「之後」買了 F
#    <{D},{B,F},{A}> 0.50：一半的顧客先買 D → 再一起買 B、F → 最後買 A（顧客 1 和 4）
r1 = as(ruleInduction(s1, confidence = 0.4, control = list(verbose = TRUE)), "data.frame")
#  ruleInduction()：從頻繁序列產生「序列規則」，例如 <{D}> => <{F}>（先買 D 的人，之後會買 F）
#  confidence = 0.4：只保留信賴度 ≥ 40% 的規則
r1
#>                    rule support confidence lift
#> 1        <{D}> => <{F}>     0.5        1.0  1.0
#> 2      <{D}> => <{B,F}>     0.5        1.0  1.0
#> 3        <{D}> => <{B}>     0.5        1.0  1.0
#> 4        <{B}> => <{A}>     0.5        0.5  0.5
#>  ...（共 10 條，省略）...
#  第 1 條：買過 D 的顧客，之後 100% 都買了 F
#  lift = 1.0：因為「所有」顧客都買過 F，買 D 並沒有提高買 F 的機會
#  第 4 條 lift = 0.5 < 1：先買 B 的人，之後買 A 的比例反而比較低
#  資料只有 4 位顧客，結果只是示範；實際應用需要大量資料才有參考價值

# ============================================================
# 重點整理
# ============================================================
# | 項目               | 一般關聯規則 (apriori) | 序列樣式 (cspade)               |
# |--------------------|------------------------|---------------------------------|
# | 是否考慮順序       | 否                     | 是                              |
# | 規則範例           | {A, B} => {C}          | <{A}, {B}> => <{C}>             |
# | 支持度的分母       | 交易（購買）次數       | 序列（顧客）數                  |
# | 資料需要           | 每筆交易的項目         | 顧客編號 + 時間點 + 項目        |
#
# 練習題
# 1. 把 support 改成 0.5、0.75，頻繁序列的數量有什麼變化？
# 2. 把 confidence 改成 0.8，剩下哪些規則？
# 3. 找出顧客 4 的購買順序，確認 <{D},{B,F},{A}> 是否真的出現在他的紀錄中
