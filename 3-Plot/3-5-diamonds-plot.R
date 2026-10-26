# ============================================================
# 3-5 鑽石資料：重量和價格的關係
# ============================================================
# 使用 ggplot2 內建的 diamonds 資料（53,940 顆鑽石），畫出：
#   x 軸 = 重量 (carat)、y 軸 = 價格 (price)、顏色 = 淨度 (clarity)
# 學習重點：
#   1. 資料很多時，用透明度 alpha 避免點全部糊成一團
#   2. 用 geom_smooth() 加上各組的趨勢線
#
# 說明：#> 是 R 4.6.1 實際執行的結果。
# ============================================================

library(ggplot2)
#mydata = read.csv(file.choose())
#  （補充）file.choose() 會跳出選擇檔案的視窗，讓你用滑鼠挑一個 CSV 檔讀進來
data(diamonds)
#  載入 diamonds 資料，共 10 欄：
#    carat 重量、cut 切工、color 顏色、clarity 淨度、depth 深度比例、
#    table 檯面比例、price 價格（美元）、x/y/z 長寬高（mm）
mydiamonds = data.frame(diamonds)
#  diamonds 原本是 tibble 格式，轉成一般的 data.frame
summary(mydiamonds)
#  每一欄的摘要統計：
#>      carat               cut        color        clarity          depth
#>  Min.   :0.2000   Fair     : 1610   D: 6775   SI1    :13065   Min.   :43.00
#>  1st Qu.:0.4000   Good     : 4906   E: 9797   VS2    :12258   1st Qu.:61.00
#>  Median :0.7000   Very Good:12082   F: 9542   SI2    : 9194   Median :61.80
#>  Mean   :0.7979   Premium  :13791   G:11292   VS1    : 8171   Mean   :61.75
#>  3rd Qu.:1.0400   Ideal    :21551   H: 8304   VVS2   : 5066   3rd Qu.:62.50
#>  Max.   :5.0100                     I: 5422   VVS1   : 3655   Max.   :79.00
#>                                     J: 2808   (Other): 2531
#>  ...（price、x、y、z 等欄位省略）...
#  類別欄位（cut、color、clarity）顯示每個類別的數量；
#  類別太多時只列前幾個，其餘合併成 (Other)
#  price 最低 326、中位數 2401、最高 18823 美元
#  x、y、z 的最小值是 0，代表有些資料可能是輸入錯誤（尺寸不可能是 0）

ggplot(data=diamonds,
       aes(x=carat,y=price,color=clarity))+
  geom_point(alpha=0.1)+
  geom_smooth()
#  aes(..., color = clarity)：依淨度上色，8 種淨度各一種顏色
#  geom_point(alpha = 0.1)：每個點只有 10% 不透明，
#    5 萬多個點重疊時，顏色越深的地方代表鑽石越多
#  geom_smooth()：每種淨度各畫一條趨勢線
#    會出現訊息 using method = 'gam'：資料超過 1000 筆時自動用 GAM 方法
#    資料量大，這一步可能要等幾秒鐘
#  看到的圖：
#    - 重量越重，價格越高，而且不是直線，越重漲得越快
#    - 同樣重量下，淨度越好（例如 IF、VVS1）價格越高
#    - 大部分鑽石都在 2 克拉以下

# ============================================================
# 重點整理
# ============================================================
# 1. summary() 可以快速看出資料範圍和可疑的值（例如尺寸為 0）
# 2. 資料點很多時，用 alpha 調整透明度
# 3. aes() 裡指定 color，geom_smooth() 會自動依顏色分組各畫一條線
#
# 練習題
# 1. 把 color = clarity 換成 color = cut，觀察切工對價格的影響
# 2. 加上 + scale_y_log10()，把價格改成對數刻度，趨勢會變得比較直
# 3. 用 subset(diamonds, x == 0) 找出長度為 0 的可疑資料，看看有幾筆
