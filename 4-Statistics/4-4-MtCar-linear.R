# ============================================================
# 4-4 線性迴歸：汽車馬力、煞車距離（mtcars、cars 資料）
# ============================================================
# 這個範例教你：
#   1. 比較放入不同變數的迴歸模型，看哪個模型比較好
#   2. 用 lm(Y ~ .) 一次放入所有變數
#   3. 簡單線性迴歸：畫出迴歸線，並預測新資料
#
# 使用 R 內建的兩個資料集：
#   mtcars：1974 年 32 款汽車，11 個欄位，例如
#     hp 馬力、cyl 汽缸數、disp 排氣量、carb 化油器數、mpg 油耗、wt 重量
#   cars：50 筆資料，speed 車速（英里/小時）、dist 煞車距離（英尺）
#
# 說明：#> 是 R 4.6.1 實際執行的結果。
# ============================================================

library("ggplot2")
mycars = mtcars
#  複製一份 mtcars

# ------------------------------------------------------------
# 第一部分：比較不同的模型（預測馬力 hp）
# ------------------------------------------------------------
result = lm(hp ~ cyl, data=mycars)
#  模型 1：只用汽缸數預測馬力
summary(result)
#>             Estimate Std. Error t value Pr(>|t|)
#> (Intercept)  -51.054     24.982  -2.044   0.0499 *
#> cyl           31.958      3.884   8.229 3.48e-09 ***
#> Multiple R-squared:  0.693,	Adjusted R-squared:  0.6827
#  每多 1 個汽缸，馬力平均多 32 匹；R² = 0.69
#  截距 -51 沒有實際意義（沒有 0 汽缸的車），只是讓直線落在正確的位置
result2 = lm(hp ~ cyl + disp, data=mycars)
#  模型 2：汽缸數 + 排氣量
summary(result2)
#>             Estimate Std. Error t value Pr(>|t|)
#> (Intercept) -32.4317    32.2803  -1.005    0.323
#> cyl          24.5145     9.0218   2.717    0.011 *
#> disp          0.1189     0.1300   0.915    0.368
#> Multiple R-squared:  0.7016,	Adjusted R-squared:  0.681
#  加入排氣量後，Adjusted R² 反而從 0.6827 降到 0.681，disp 也不顯著 (p = 0.368)
#  原因：汽缸越多、排氣量通常越大，兩者提供的資訊重複（共線性），加了沒有幫助

result3 = lm(hp ~ disp+carb, data=mycars)
#  模型 3：排氣量 + 化油器數
summary(result3)
#>             Estimate Std. Error t value Pr(>|t|)
#> (Intercept)  9.98848   11.61391   0.860    0.397
#> disp         0.32431    0.04298   7.546 2.56e-08 ***
#> carb        21.99928    3.29762   6.671 2.57e-07 ***
#> Multiple R-squared:  0.8523,	Adjusted R-squared:  0.8421
#  兩個變數都顯著，Adjusted R² 提高到 0.84，是目前最好的模型
#  因為排氣量和化油器數提供的是「不同面向」的資訊

result_all = lm(hp ~ ., data=mycars)  #所有
#  ~ . 的點代表「除了 hp 以外的所有欄位」，一次放入 10 個變數
summary(result_all)   #
#>             Estimate Std. Error t value Pr(>|t|)
#> (Intercept)  79.0484   184.5041   0.428  0.67270
#> mpg          -2.0631     2.0906  -0.987  0.33496
#> cyl           8.2037    10.0861   0.813  0.42513
#> disp          0.4390     0.1492   2.942  0.00778 **
#>  ...（省略）...
#> carb         18.7487     7.0288   2.667  0.01441 *
#> Multiple R-squared:  0.9028,	Adjusted R-squared:  0.8565
#  R² 最高 (0.90)，但 10 個變數只有 disp 和 carb 顯著
#  Adjusted R² 0.8565 只比模型 3 的 0.8421 高一點點，卻多用了 8 個變數
#  【重要觀念】變數放越多，R² 一定會變大，但模型不一定比較好。
#    只有 32 筆資料卻用 10 個變數，容易「過度配適」(overfitting)：
#    對這 32 台車很準，對新的車反而不準。比較模型時要看 Adjusted R²
#    （進階：step(result_all) 可以自動挑選變數）


#######
# ------------------------------------------------------------
# 第二部分：簡單線性迴歸（車速 → 煞車距離）
# ------------------------------------------------------------

cars
#  印出 cars 資料，50 列 × 2 欄
#>    speed dist
#> 1      4    2
#> 2      4   10
#>  ...（省略）...
ggplot(cars, aes(x = speed, y = dist)) + geom_point(shape = 10, size = 5) +
    geom_smooth(method = lm) + labs(x = "速度", y = "煞車距離")
#  geom_point(shape = 10, size = 5)：點的形狀 10 號（圓圈內有十字），大小 5
#  geom_smooth(method = lm)：畫出線性迴歸直線，灰色帶狀是 95% 信賴區間
#    會出現訊息 using formula = 'y ~ x'，表示用一般直線配適
#  labs()：設定座標軸標題
#  看到的圖：車速越快，煞車距離越長，點大致沿著直線往右上分布
#  如果中文顯示成方框，可以加上：+ theme(text = element_text(family = "PingFang TC"))
#    （Windows 改用 "Microsoft JhengHei"）
result4 <- lm(dist ~ speed, data = cars)
summary(result4)
#>             Estimate Std. Error t value Pr(>|t|)
#> (Intercept) -17.5791     6.7584  -2.601   0.0123 *
#> speed         3.9324     0.4155   9.464 1.49e-12 ***
#> Multiple R-squared:  0.6511,	Adjusted R-squared:  0.6438
#  迴歸方程式：煞車距離 = -17.58 + 3.93 × 車速
#  車速每增加 1 英里/小時，煞車距離平均增加約 3.93 英尺；R² = 0.65
newcar <- data.frame(speed = 10)
#  建立新資料：車速 10。欄位名稱必須和模型裡的變數名稱一樣（speed）
result5 <- predict(result4, newdata = newcar)
result5
#>        1
#> 21.74499
#  預測車速 10 時煞車距離約 21.7 英尺
#  驗算：-17.5791 + 3.9324 × 10 = 21.745
#  一次預測多個車速：predict(result4, data.frame(speed = c(10, 20, 30)))

# ============================================================
# 重點整理
# ============================================================
# | 寫法                        | 意思                          |
# |-----------------------------|-------------------------------|
# | lm(Y ~ X)                   | 簡單線性迴歸（一個 X）        |
# | lm(Y ~ X1 + X2)             | 多元線性迴歸                  |
# | lm(Y ~ .)                   | 用其他所有欄位當 X            |
# | geom_smooth(method = lm)    | 在圖上畫迴歸線                |
# | predict(模型, newdata = )   | 預測新資料                    |
#
# 比較模型看 Adjusted R²，不要只看 R²；變數不是越多越好。
#
# 練習題
# 1. 用 mtcars 建立 mpg ~ wt（油耗對車重）的模型，車重每增加 1000 磅（wt 的單位），油耗 mpg 變化多少？
# 2. 預測車速 25 時的煞車距離
# 3. 比較 lm(hp ~ disp + carb) 和 lm(hp ~ disp + carb + wt) 的 Adjusted R²，哪個比較好？
