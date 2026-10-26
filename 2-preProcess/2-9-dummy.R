################################
#dummyVars
#將類別資料轉為數值資料
################################
# ============================================================
# 2-9 虛擬變數 (Dummy Variables)：把類別資料轉成 0 和 1
# ============================================================
# 為什麼需要虛擬變數？
#   迴歸、類神經網路等方法只能吃「數字」。
#   類別資料（例如鑽石切工 Fair、Good、Ideal）不能直接拿來計算，
#   也不能隨便編成 1、2、3，因為那會讓電腦以為 Ideal 是 Fair 的 3 倍。
#   做法是：每一個類別各開一欄，是這個類別就填 1，不是就填 0。
#
#   例：cut = "Ideal" 這一列 →
#       cut_Fair  cut_Good  cut_Very.Good  cut_Premium  cut_Ideal
#          0         0           0              0           1
#   這種方法也叫「獨熱編碼」(one-hot encoding)。
#
# 說明：#> 是 R 4.6.1 實際執行的結果。
#       標題寫的 dummyVars 是 caret 套件的函數；這個範例實際使用的是 dummy 套件的 dummy()。
# ============================================================

if(! require("dummy")) install.packages("dummy")
library(dummy)
#  載入時會顯示版本訊息 dummy 0.1.3，這是正常的

dummy_diamonds <- dummy(diamonds[,-3]) #without color
#  ⚠️ 錯誤：找不到物件 'diamonds'
#     原因：diamonds 資料集在 ggplot2 套件裡，要先載入 ggplot2
#     修正：在這行之前加上 library(ggplot2)
#
#  diamonds 是約 5 萬 4 千顆鑽石的資料，共 10 欄：
#    carat 重量、cut 切工、color 顏色、clarity 淨度、depth、table、price 價格、x、y、z
#  diamonds[,-3]：負號代表「去掉」第 3 欄 color，只留其他 9 欄
#
#  dummy() 會自動找出所有「類別欄位」並轉成虛擬變數，數字欄位不處理：
#    cut（5 種切工）→ 5 欄
#    clarity（8 種淨度）→ 8 欄
#  所以 dummy_diamonds 是 53940 列 × 13 欄（修正後的結果）：
#> [1] "cut_Fair"      "cut_Good"      "cut_Very.Good" "cut_Premium"
#> [5] "cut_Ideal"     "clarity_I1"    "clarity_SI2"   "clarity_SI1"
#> [9] "clarity_VS2"   "clarity_VS1"   "clarity_VVS2"  "clarity_VVS1"
#> [13] "clarity_IF"
#
#  前 3 列（只列 cut 部分）：
#>   cut_Fair cut_Good cut_Very.Good cut_Premium cut_Ideal
#> 1        0        0             0           0         1    ← 第 1 顆是 Ideal
#> 2        0        0             0           1         0    ← 第 2 顆是 Premium
#> 3        0        1             0           0         0    ← 第 3 顆是 Good
#  注意：dummy() 產生的 0/1 欄位是「文字」(character) 型態，
#        要當數字計算時可用 as.numeric(欄位) 轉換

my_diamonds <- cbind(diamonds,dummy_diamonds)
#  cbind：把原始資料和虛擬變數左右並排合併
#  修正後的結果：53940 列 × 23 欄（原本 10 欄 + 新增 13 欄）
#  ⚠️ 原程式因為 diamonds 不存在，這行也會出錯：找不到物件 'diamonds'

# ============================================================
# 重點整理
# ============================================================
# 1. 類別資料要轉成虛擬變數（0/1 欄位）才能放進大多數模型
# 2. 每個類別各一欄，是該類別填 1，否則填 0
# 3. 使用套件內建資料集前，記得先載入該套件（diamonds 在 ggplot2 裡）
# 4. 其他常用做法：
#      caret 套件：dummyVars(~ ., data = 資料) 搭配 predict()
#      fastDummies 套件：dummy_cols(資料)
#      R 內建：model.matrix(~ cut - 1, data = diamonds)
#
# 補充：做迴歸時，k 個類別通常只需要 k-1 個虛擬變數，
#       否則各欄加總永遠等於 1，會造成「共線性」問題（又稱虛擬變數陷阱）。
#
# 練習題
# 1. 加上 library(ggplot2) 後重新執行，用 dim(my_diamonds) 確認是 53940 列 × 23 欄
# 2. 用 table(diamonds$cut) 看每種切工各有幾顆，再對照 cut_Ideal 欄中 1 的數量
# 3. 改成保留 color 欄 dummy(diamonds)，會多出幾個虛擬變數欄位？（答案：7 個，共 20 欄）
