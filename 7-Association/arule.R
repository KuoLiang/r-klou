
# ============================================================
# arule.R：關聯規則入門（Adult 人口普查資料）
# ============================================================
# 【什麼是關聯規則 (association rules)？】
#   從大量資料中找出「如果 A 出現，B 也常常出現」的規則，寫成 {A} => {B}。
#   最有名的例子是購物籃分析：買了麵包的人，也常買牛奶 → {麵包} => {牛奶}
#   {A} 叫做「前項」(lhs, left-hand side)，{B} 叫做「後項」(rhs, right-hand side)
#
# 【三個重要指標】
#   支持度 support    ：A 和 B「同時出現」的資料佔全部的比例 → 這個組合常不常見
#   信賴度 confidence ：出現 A 的資料中，也出現 B 的比例 → 規則有多可靠
#   提升度 lift       ：信賴度 ÷ B 本身出現的比例
#     lift > 1：A 出現會「提高」B 出現的機會（正相關，有意義的規則）
#     lift ≈ 1：A 和 B 沒有關係，只是 B 本來就很常見
#     lift < 1：A 出現反而「降低」B 出現的機會
#
# 說明：#> 是 R 4.6.1 + arules 實際執行的結果。
# ============================================================

if (!require("arules")) install.packages("arules")
library(arules)
#  載入時「下列物件被遮斷自 'package:base': abbreviate, write」是正常訊息

data("Adult")
#  Adult：1994 年美國人口普查資料，已經轉成「交易資料」(transactions) 格式
#  每一筆是一個人，每個屬性（例如 sex=Male、race=White）就像購物籃裡的一件商品
Adult
#> transactions in sparse format with
#>  48842 transactions (rows) and
#>  115 items (columns)
#  48842 人、115 種「項目」（屬性和值的組合）
rules = apriori(Adult, parameter = list(supp = 0.5, conf = 0.9))
#  apriori()：最常用的關聯規則演算法
#  supp = 0.5：只保留支持度 ≥ 50% 的規則（至少一半的人都符合）
#  conf = 0.9：只保留信賴度 ≥ 90% 的規則
#  執行時會印出演算法的參數和進度，最後一行附近顯示：
#> writing ... [52 rule(s)] done [0.00s].
#  共找到 52 條規則
rules.sorted = sort(rules,by="confidence")
#  依信賴度由高到低排序
inspect(rules.sorted)
#  inspect()：把規則印成易讀的表格
#>      lhs                               rhs                   support confidence  coverage      lift count
#> [1]  {hours-per-week=Full-time}     => {capital-loss=None} 0.5606650  0.9582531 0.5850907 1.0052191 27384
#> [2]  {workclass=Private}            => {capital-loss=None} 0.6639982  0.9564974 0.6941976 1.0033773 32431
#>  ...（省略）...
#> [7]  {}                             => {capital-loss=None} 0.9532779  0.9532779 1.0000000 1.0000000 46560
#>  ...（共 52 條，省略）...
#  欄位說明：coverage = 前項出現的比例；count = 符合規則的人數
#  第 1 條的意思：全職工作的人中，95.8% 沒有資本損失
#
#  【重要觀念：信賴度高 ≠ 規則有用】
#   第 7 條 {} => {capital-loss=None} 的前項是空的，代表「不管什麼人」，95.3% 都沒有資本損失。
#   所以第 1 條的 95.8% 只比全體高一點點，lift 只有 1.005，幾乎沒有資訊。
#   這 52 條規則的 lift 都在 0.98 ~ 1.06 之間，大多只是在說「大部分的人都沒有資本損益」。
#   找有意義的規則時，應該依 lift 排序：
rules.sorted = sort(rules, by = "lift")
inspect(rules.sorted)
#   並把 supp 調低，才找得到「不那麼普遍、但關聯很強」的規則

# ============================================================
# 重點整理
# ============================================================
# | 指標         | 意思                                  | 用途                 |
# |--------------|---------------------------------------|----------------------|
# | support      | A、B 同時出現的比例                   | 過濾太少見的組合     |
# | confidence   | 有 A 的人中，也有 B 的比例            | 規則的可靠程度       |
# | lift         | confidence ÷ B 本身的比例             | 判斷是否真的有關聯   |
#
# apriori(資料, parameter = list(supp = , conf = )) 找規則
# sort(規則, by = "lift") 排序、inspect() 查看
#
# 練習題
# 1. 改成 sort(rules, by = "lift")，排在最前面的是哪一條？lift 是多少？
# 2. 把 supp 降到 0.1，規則數量變多少？再依 lift 排序，看看前 5 條
# 3. 只找後項是收入的規則：
apriori(Adult, parameter = list(supp = 0.05, conf = 0.6),
    appearance = list(rhs = c("income=small", "income=large"), default = "lhs"))
