##########################################
#Reference: ggplot2 cheat sheet
##########################################
# ============================================================
# 3-2 用 ggplot2 畫 NorthWind 銷售資料
# ============================================================
# ggplot2 是 R 最常用的繪圖套件，畫圖的方式像「疊圖層」：
#   ggplot(資料, aes(x = ..., y = ...))   ← 第 1 層：指定資料和座標軸（還沒有圖形）
#     + geom_xxx()                        ← 第 2 層：要畫成什麼圖（點、長條、線…）
#     + facet_xxx() / coord_xxx() / ...   ← 其他層：分面、座標、主題…
# 用 + 號把圖層一層一層疊上去。
#
# aes() 是 aesthetic（美學對應）的縮寫：把資料的欄位對應到圖的元素，
#   例如 x 軸、y 軸、顏色 color、填色 fill、大小 size、形狀 shape
#
# 這個範例依照「變數的個數和類型」分類練習（和 ggplot2 cheat sheet 的分類相同）：
#   一個連續變數、一個類別變數、兩個連續變數、類別 x + 連續 y、分面
#
# 說明：圖會顯示在 RStudio 的 Plots 視窗；以下用文字描述會看到什麼。
#       同資料夾的 ggplot2-CheetSheet.pdf 是 ggplot2 官方速查表，可以對照。
# ============================================================

# ------------------------------------------------------------
# 第一部分：讀取資料
# ------------------------------------------------------------
#from database
setwd("/Users/klou/Documents/GitHub/r-klou/3-Plot")
#  設定工作目錄。這是老師電腦上的路徑，同學要改成自己的資料夾
source("mysql_conn.R") #connect to mysql
#  執行 mysql_conn.R：連線到課程的資料庫，並送出查詢（需要能連到伺服器）
nw <-  fetch(myquery_result, n=-1)  #read all the data from result
#  把查詢結果全部抓回來。沒有連線時這行會出錯，可以跳過，改用下面讀 CSV 的方式
#or you can import the NW from local file
#setwd("somewhere of your working directory")
nw <-  read.csv("NWSales.csv")
#  從本機的 CSV 檔讀入，內容和資料庫查詢的結果相同（2155 列 × 6 欄）
#from remote file
#nw <-  read.csv("https://github.com/KuoLiang/r-klou/blob/main/3-Plot/NWSales.csv")
#     要讀 GitHub 上的檔案，網址要改成 raw 格式：
nw <-  read.csv("https://raw.githubusercontent.com/KuoLiang/r-klou/main/3-Plot/NWSales.csv")
nw #showout the dataframe
#  印出全部資料（2155 列，很長）。只看前幾列可以用 head(nw)

# ------------------------------------------------------------
# 第二部分：轉換成類別 (factor)
# ------------------------------------------------------------
##########################################
#transform
##########################################
nw$Year = factor(nw$Year)
nw$EmployeeID = factor(nw$EmployeeID)
nw$ShipCountry = factor(nw$ShipCountry)
#  年份、員工編號、國家都是「類別」。轉成 factor 後，ggplot2 才會：
#    - 把它們畫成一格一格的類別軸，而不是連續的數字軸
#    - 用不同的顏色區分，而不是深淺漸層

##########################################
#packages
if (!require("ggplot2")) install.packages("ggplot2")
library(ggplot2)
##########################################
#hints:
#Aesthetic : x y shape, color, size
#Layer : geom_point() geom_line() geom_bar() geom_violin()
#                 geom_boxplot() geom_histogram() geom_path()
# the followings are the practices of geom functions
##########################################

# ------------------------------------------------------------
# 第三部分：一個連續變數（看 Sales 的分布）
# ------------------------------------------------------------
#One Variable - Continuous
c <-  ggplot(data=nw, aes(Sales))
#  先建立底圖存在 c，只指定 x 軸是 Sales，還沒有圖形
#  之後用 c + geom_xxx() 就能用同一個底圖畫出不同的圖
#  （提醒：c 和函數 c() 同名，能執行但容易混淆）
##########################################
c + geom_area(stat="bin")
#  面積圖：把 Sales 切成區間計算筆數，再連成一片面積
#  會出現訊息 `stat_bin()` using `bins = 30`：沒有指定區間大小，預設切 30 段
c + geom_area(stat="bin", binwidth=1000)
#  binwidth = 1000：每 1000 元一個區間
c + geom_density()
#  密度圖：平滑的分布曲線。大部分訂單金額很小，所以曲線在左邊很高，右邊拖一條長尾巴
c + geom_dotplot()
#  點圖：每筆資料一個點，堆疊起來。資料多時點會非常小、堆得很高
c + geom_dotplot(binwidth = 1000)
c + geom_histogram()
#  直方圖：最常用來看單一數值變數的分布
c + geom_histogram(binwidth = 1000,color="blue")
#  color = 長條的「外框」顏色；要改長條的「填色」用 fill = "blue"
#  這裡的 color 寫在 aes() 外面，代表「固定」用藍色，不是依資料變化

# ------------------------------------------------------------
# 第四部分：一個類別變數（長條圖）
# ------------------------------------------------------------
##########################################
#One Variable - discrete
d <-  ggplot(data=nw, aes(EmployeeID))
d1 <-  ggplot(data=nw, aes(EmployeeID,fill=Year)) #fill用在實心
#  fill = Year 寫在 aes() 裡面，代表「依 Year 的值決定填色」，每年一種顏色
##########################################
d + geom_bar() #default y = count
#  長條圖：x 軸是員工，長條高度是「這位員工有幾筆資料」（自動計數）
#  員工 4 最多（420 筆），員工 9 最少（107 筆）
d1 + geom_bar()
#  依年份上色，三個年份的長條疊在一起
d1 + geom_bar(position="stack")
#  stack 堆疊：和上一張相同（stack 就是預設值）
d1 + geom_bar(position="fill")
#  fill 填滿：每根長條都拉到 100%，看的是「各年份所佔的比例」
d1 + geom_bar(position="dodge")
#  dodge 並排：三個年份的長條左右並排，方便比較數量
d1 + geom_bar(position="dodge")+ coord_flip()
#  coord_flip()：把 x、y 軸對調，長條變成橫的。類別很多或名稱很長時很好用

# ------------------------------------------------------------
# 第五部分：兩個連續變數（散布圖、趨勢線）
# ------------------------------------------------------------
##########################################
#Two Variables - Continuous X and Continuous Y
e <- ggplot(data=nw, aes(x=Freight,y=Sales))
e1 <-  ggplot(data=nw, aes(x=Freight,y=Sales,fill=Year,color=Year)) #fill用在實心；color 用在線條
##########################################
e + geom_point()
#  散布圖：每筆訂單一個點，x 是運費、y 是銷售額
e + geom_point() + geom_smooth()
#  再疊一層平滑趨勢線，灰色帶狀區域是信賴區間
#  訊息 using method = 'gam'：資料超過 1000 筆時，自動用 GAM 方法算平滑線
e1+ geom_point() + geom_smooth()
#  依年份分色，每年各畫一條趨勢線
e1+ geom_quantile()       # need to install stat_quantile()
#  分位數迴歸線：預設畫出 25%、50%、75% 三條線
#  需要先安裝 quantreg 套件：install.packages("quantreg")
#  訊息 Smoothing formula not specified. Using: y ~ x 表示用直線來配適
e1+ geom_point() + geom_quantile(quantiles = c(0.1, 0.5, 0.9),size=2,alpha=0.5)
#  改畫 10%、50%、90% 三條分位數線；alpha = 透明度（0 全透明 ~ 1 不透明）
#  會出現警告：線的粗細在新版 ggplot2 要用 linewidth，不要用 size
#  新寫法：geom_quantile(quantiles = c(0.1, 0.5, 0.9), linewidth = 2, alpha = 0.5)

# ------------------------------------------------------------
# 第六部分：類別 x + 連續 y（比較各組）
# ------------------------------------------------------------
##########################################
#Two Variables - Discrete X and Continuous Y
f <- ggplot(data=nw, aes(x=EmployeeID,y=Sales))
f1 <-  ggplot(data=nw, aes(x=EmployeeID,y=Sales,fill=Year))
f2 <-  ggplot(data=nw, aes(x=ShipCountry,y=Sales))
##########################################
f + geom_point()
#  每位員工的每筆銷售額，點會在同一條直線上重疊
#  （改用 geom_jitter() 會把點稍微左右散開，比較容易看）
f + geom_bar(stat="summary", fun="mean") #default position=stack
#  stat = "summary", fun = "mean"：長條高度是「每位員工的平均銷售額」，不是筆數
f1 + geom_bar(stat="summary", fun="mean",position = "dodge")
#  每位員工、每一年的平均銷售額，三年並排
f1 + geom_bar(stat="summary", fun="mean",position = "fill") #normalized
#  每根長條拉到 100%，看三年平均值的相對比例
f1 + geom_boxplot()
#  箱形圖：每位員工每年的銷售額分布
f1 + geom_violin()
#  小提琴圖：形狀越寬，代表那個金額附近的訂單越多
f2 + geom_violin()
#  依國家畫小提琴圖。國家名稱很多，x 軸文字可能擠在一起
#  可以加上 + coord_flip() 改成橫的，或用 theme(axis.text.x = element_text(angle = 90))
f2 + geom_violin() + ylim(0,1000) #設定y 軸距離
#  ylim(0, 1000)：只保留 y 在 0~1000 的資料
#  會出現警告 Removed 350 rows：超過 1000 的 350 筆資料被「刪掉」後才畫圖，
#  所以小提琴的形狀也會跟著改變
f2 + geom_violin() + ylim(0,1000) + coord_cartesian(ylim=c(0,500)) #格放
#  coord_cartesian(ylim = ...)：只是「放大鏡頭」，不會刪掉資料
#  和 ylim() 的差別：ylim() 刪資料再畫圖，coord_cartesian() 畫完再放大
#  （這裡兩個都用了，所以仍然先刪掉超過 1000 的資料）

# ------------------------------------------------------------
# 第七部分：分面 (facet)：依類別拆成多張小圖
# ------------------------------------------------------------
##########################################
#Facet
u <- ggplot(data=nw, aes(x=Sales))
##########################################
# 【補充】facet_grid(列 ~ 欄)：
#   ~ 左邊的變數決定「上下排」，右邊的變數決定「左右排」，不需要的那一邊寫一個點 .
#   新寫法 facet_grid(rows = vars(...), cols = vars(...)) 的效果相同

u + geom_density(aes(fill=EmployeeID),alpha= 0.2)+
  facet_grid(EmployeeID~.) #y = EmployeeID
#  每位員工一張密度圖，9 張由上往下排
u + geom_density(aes(fill=EmployeeID),alpha= 0.2)+
  facet_grid(rows=vars(EmployeeID)) #y = EmployeeID
#  和上一張相同，換成新寫法

u + geom_density(aes(fill=EmployeeID),alpha= 0.2)+
  facet_grid(.~Year)      #x= Year
#  依年份拆成 3 張，左右排；每張圖裡 9 位員工的密度曲線疊在一起
#  alpha = 0.2 讓填色半透明，重疊的地方才看得到
u + geom_density(aes(fill=EmployeeID),alpha= 0.2)+
  facet_grid(cols=vars(Year))      #x= Year

u + geom_density(aes(fill=EmployeeID),alpha= 0.2)+
  facet_grid(EmployeeID~Year) #y = EmployeeID x= Year
#  9 位員工 × 3 年 = 27 張小圖排成表格
u + geom_density(aes(fill=EmployeeID),alpha= 0.2)+
  facet_grid(rows=vars(EmployeeID),cols=vars(Year))

# ------------------------------------------------------------
# 第八部分：複習 dplyr
# ------------------------------------------------------------
##########################################
#Review of dplyr
##########################################
#dplyr 數據處理 , like SQL
# filter()	篩選
# select()	選擇變數
# mutate()	新增衍生變數
# arrange()	排序
# summarise()	聚合變數
# group_by()	分組，常搭配 summarise()

library(dplyr)

#The NW dataset
f <-  filter(nw, ShipCountry == "France")
#  出貨到法國的訂單（184 筆）。注意這裡把上面的 ggplot 底圖 f 蓋掉了
f2 <- filter(f,Sales >= 1000, Sales <=1100)
#  filter 裡用逗號分隔多個條件，等於「且」(&)：銷售額介於 1000 ~ 1100
f2
#>   EmployeeID Year ShipCountry Sales Discount Freight
#> 1          1 1994      France  1000     0.05  166.31
#> 2          2 1995      France  1060     0.05  113.15
#> 3          4 1994      France  1092     0.00  131.70
#> 4          4 1995      France  1100     0.15  350.64
#> 5          4 1995      France  1050     0.00  487.38

#The Iris dataset
selected = select(iris, Sepal.Length, Sepal.Width, Petal.Length)
selected
#  只留下 3 個欄位（150 列）

newIris = mutate(iris, greater.mean = Sepal.Width > mean(Sepal.Width))
newIris
#  新增 greater.mean 欄：花萼寬度是否大於平均（TRUE / FALSE）

newIris2 = mutate(iris, area = Sepal.Length * Sepal.Width)
newIris2
#  新增 area 欄：花萼長 × 寬

myaesc = arrange(newIris, Petal.Length, Petal.Width)  #排序
#  由小到大排序
mydesc = arrange(newIris, desc(Petal.Length), Petal.Width)
#  desc()：Petal.Length 由大到小

##########################################
#try to plot some for above datasets by yourself
##########################################
plot(newIris)
#  R 內建的 plot() 遇到資料框，會畫出所有欄位兩兩配對的散布圖矩陣（和 pairs() 相同）
newIris$greater.mean <- as.factor((newIris$greater.mean))
#  把 TRUE / FALSE 轉成類別，才能拿來決定顏色
plot(newIris[,1:4],col=newIris$greater.mean)
#  前 4 個數字欄的散布圖矩陣，依「花萼寬度是否大於平均」上色：
#  FALSE 是第 1 種顏色（黑），TRUE 是第 2 種顏色（紅）

# ============================================================
# 重點整理
# ============================================================
# | 資料類型            | 常用 geom                                        |
# |---------------------|--------------------------------------------------|
# | 一個連續變數        | geom_histogram、geom_density、geom_area          |
# | 一個類別變數        | geom_bar（stack / fill / dodge）                 |
# | 兩個連續變數        | geom_point、geom_smooth、geom_quantile           |
# | 類別 x + 連續 y     | geom_boxplot、geom_violin、geom_bar(stat="summary") |
# | 拆成多張小圖        | facet_grid(列 ~ 欄)                              |
#
# aes() 裡面 vs 外面：
#   aes(color = Year) → 顏色「依資料變化」，會出現圖例
#   color = "blue"    → 顏色「固定」，寫在 aes() 外面
#
# 練習題
# 1. 畫出每個國家 (ShipCountry) 的訂單筆數長條圖，並用 coord_flip() 轉成橫的
# 2. 畫出 Discount 和 Sales 的散布圖，依 Year 上色
# 3. 用 facet_grid(.~Year) 把第 2 題拆成三張圖
