##########################################
#Editor: Kuo-Liang Ou
#Affililation: National Tsing Hua University ILST
##########################################
# ============================================================
# 3-3 用 esquisse 拖拉介面產生 ggplot2 程式碼
# ============================================================
# esquisse 是一個「圖形化介面」的 ggplot2 小工具：
#   不用寫程式，用滑鼠把欄位拖到 x、y、顏色等位置，就能即時看到圖。
#   畫好之後，它會幫你產生對應的 ggplot2 程式碼，可以複製回 R 使用。
#   很適合初學者：先拖拉看效果，再看產生的程式碼，學習 ggplot2 的寫法。
#
# 說明：esquisser() 會打開一個互動視窗，需要在 RStudio 裡手動操作，
#       所以這個範例沒有附執行結果。
# ============================================================

#install required packages
if (!require("esquisse")) install.packages("esquisse")
#  如果還沒安裝 esquisse 就自動安裝
library("esquisse")
data(iris)
#  載入 iris 資料，讓它出現在 esquisse 可以選擇的資料清單中
options("esquisse.viewer" = "browser")
#  設定 esquisse 的介面要在哪裡打開：
#    "browser" = 用網頁瀏覽器打開（畫面比較大）
#    "dialog"  = RStudio 的對話視窗；"pane" = RStudio 右下角的 Viewer 窗格
esquisser() #or esquisser(iris)
#  打開拖拉介面。操作步驟：
#    1. 選擇資料（例如 iris 或 diamonds）
#    2. 把欄位拖到 X、Y、fill、color、size、facet 等格子
#    3. 上方可以切換圖形種類（長條圖、散布圖、小提琴圖…）
#    4. 下方的 Code 頁籤可以複製產生的程式碼
#  執行期間 R 主控台會被佔用，關掉 esquisse 視窗（或按 Close）才能繼續輸入其他指令
#  esquisser(iris) 則是直接指定要用 iris 資料

library("ggplot2")
ggplot(diamonds) +
  aes(x = cut, y = carat) +
  geom_violin(adjust = 1L, scale = "area", fill = "#0c4c8a") +
  labs(title = "Mytest") +
  theme_minimal()
#  這段就是 esquisse 產生的程式碼範例，用 diamonds（鑽石）資料畫小提琴圖：
#    ggplot(diamonds)        ：使用 ggplot2 內建的 diamonds 資料（約 5 萬 4 千顆鑽石）
#    aes(x = cut, y = carat) ：x 軸是切工等級，y 軸是重量（克拉）
#                              aes() 也可以像這樣用 + 號單獨加上去
#    geom_violin(...)        ：小提琴圖
#      adjust = 1L           ：平滑程度，數字越大曲線越平滑（1L 的 L 代表整數）
#      scale = "area"        ：每把小提琴的面積相同
#      fill = "#0c4c8a"      ：填色固定為深藍色
#    labs(title = "Mytest")  ：圖的標題
#    theme_minimal()         ：簡潔的主題（白底、淡格線）
#  看到的圖：5 種切工各一把深藍色的小提琴，大部分鑽石集中在 1 克拉以下

# ============================================================
# 重點整理
# ============================================================
# 1. esquisser() 打開拖拉介面，不用寫程式也能畫 ggplot2 圖
# 2. 畫完可以複製程式碼，貼回 R 腳本保存，下次直接執行
# 3. theme_minimal()、theme_bw()、theme_classic() 等主題可以快速改變整體風格
#
# 練習題
# 1. 用 esquisser(iris) 畫出 Sepal.Length 對 Petal.Length 的散布圖，依 Species 上色，
#    再把產生的程式碼複製到這個檔案下方執行
# 2. 把上面範例的 theme_minimal() 換成 theme_classic()，比較差異
