# ============================================================
# R 的資料框 (data.frame) 練習
# 包含：建立 data.frame、取值方式、型態查詢、常用查看函式
# ============================================================

#construct three vectors a,b,c
# --- 先建立三個長度相同的向量 ---
a <- c(2,3,4)            # 數值向量
b <- c(5,6,7)            # 數值向量
c <- c("A","B","C")      # 字串向量

# a dataframe is constructed by vector(s)
# --- 用向量組成 data.frame：每個向量變成一「行」(column) ---
# 各向量長度必須相同，變數名稱會自動成為欄位名稱
mydf <- data.frame(a,b,c)
mydf #showout
#   a b c
# 1 2 5 A
# 2 3 6 B
# 3 4 7 C

#retrieve one of vectors of a dataframe
# --- 用 $ 取出某一行，結果是「向量」 ---
mydf$a            #numeric        → 2 3 4
mydf$c            #character      → "A" "B" "C"
# 註：R 4.0 以後字串預設不會轉成 factor，所以是 character

# --- 用 [列, 行] 取值：逗號前是列 (row)，逗號後是行 (column) ---
# 留空代表「全部」
mydf[2,]          ##data.frame and list 某一列,跨不同行
# 取第 2 列 → 3 6 B
# 一列裡有數字也有字串，型態不同，所以只能用 data.frame 回傳
mydf[,2]          #numeric and double    某一行,vector 需相同 type
# 取第 2 行 → 5 6 7（自動簡化成向量）
mydf[,3]          #character and character   某一行,vector 需相同 type
# 取第 3 行 → "A" "B" "C"

mydf[1,1]         #numeric and double     某一個值
# 第 1 列第 1 行 → 2
mydf[1,3]         #character and character   某一個值
# 第 1 列第 3 行 → "A"

mydf[2]           #data.frame   回傳單一行之DF,請比較mydf[,2]
# 沒有逗號：把 data.frame 當成 list，取第 2 個元素但「保留 data.frame 外框」
# mydf[,2] 回傳向量，mydf[2] 回傳只有一行的 data.frame
mydf[,1:2]        #data.frame and list ,請小心與 python 的語法不同處
# 取第 1～2 行 → 包含 a、b 兩行的 data.frame
# 和 Python 的差異：
#   R 索引從 1 開始，1:2 「包含」2
#   Python 從 0 開始，切片 [0:2] 「不包含」結尾

# --- data.frame 的本質 ---
typeof(mydf) # the type in memory : list
# 記憶體中是 list：每一行是 list 的一個元素
class(mydf)  # the type in present : data.frame
# 對外呈現的類別是 data.frame

e <- mydf$c       #set e to any one above for the next two commands
# 可以把 e 換成上面任何一種取值方式，比較結果的型態
typeof(e)         #reveal the data type of e       → "character"
class(e)          #reveal the present of e         → "character"


#class() is used to define/identify what "type" an object is from 
#        the point of view of object-oriented programming in R.
#typeof() gives the "type" of object from R's point of view
# class()：從物件導向角度看「這是什麼物件」
# typeof()：從 R 內部儲存角度看「實際怎麼存」

# --- 查看 data.frame 的常用函式 ---
head(mydf)        # 顯示前 6 列（這裡只有 3 列，所以全部顯示）
tail(mydf)        # 顯示最後 6 列
# 可指定列數，例如 head(mydf, 2)

dimnames(mydf)    # 列名稱和行名稱，以 list 回傳 → list(c("1","2","3"), c("a","b","c"))
rownames(mydf)    # 列名稱 → "1" "2" "3"（預設是字串形式的編號）
colnames(mydf)    # 行名稱 → "a" "b" "c"
nrow(mydf)        # 列數 → 3
ncol(mydf)        # 行數 → 3
dim(mydf)         # 維度（列數, 行數）→ 3 3
summary(mydf)     # 每一行的摘要統計
# 數值行：最小值、第一四分位數、中位數、平均、第三四分位數、最大值
#   a → 2, 2.5, 3, 3, 3.5, 4
# 字串行：只顯示長度 (Length)、類別 (Class)、模式 (Mode)


#mydf[,2] 和 mydf[2] 很容易搞混：前者回傳向量，後者回傳 data.frame。如果用 mydf[,2, drop = FALSE]，取單一行時也會保留 data.frame 的形式。
#取出一行最常見的三種寫法：mydf$b、mydf[["b"]]、mydf[,"b"]，結果都是向量。