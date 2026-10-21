# ============================================================
# R 的基本資料型態練習
# 包含：integer、double、complex、character、logical
# ============================================================

#integer
# --- 整數 (integer) ---
a <- 10L         # 數字後面加 L，代表要存成「整數」
typeof(a)        # "integer"
class(a)         # "integer"
#
a <- 10          # 沒加 L，R 預設存成「倍精度浮點數」(double)
typeof(a)        # "double"
class(a)         # "numeric"（double 的類別名稱是 numeric）
#default datatype is double
# 重點：R 的數字預設型態是 double，不是 integer

#typeof()
#Internal Type/Storage Mode: typeof() reveals the fundamental internal data type 
#or storage mode of an object, which is how R stores the data in memory. 
#This is a low-level description.
# typeof()：看物件在「記憶體中實際怎麼存」，屬於低階、底層的描述

#class()
#Object-Oriented Class: class() returns the object's class, 
#which defines how R should interact with the object in the context of object-oriented programming (OOP). 
#This is a high-level description.
# class()：看物件的「類別」，決定 R 的函式（如 print、summary）要怎麼處理它
# 屬於高階、物件導向的描述

#double
# --- 倍精度浮點數 (double) ---
b <- 10.1
typeof(b)        # "double"
class(b)         # "numeric"
b <- sqrt(b)     # 開根號後再存回 b，b 變成約 3.178（原本的 10.1 被覆蓋）

#complex
# --- 複數 (complex) ---
c <- 1 + 2i      # i 代表虛數單位
# 註：變數取名為 c 可以執行，但容易和 c() 函式混淆，實務上不建議
typeof(c)        # "complex"
class(c)         # "complex"

#character
# --- 字串 (character) ---
d <- "klou"      # 字串要用雙引號或單引號包起來
typeof(d)        # "character"
class(d)         # "character"
paste(d,d)       # 把字串接起來，預設用空白分隔 → "klou klou"
paste(d,d,d)     # → "klou klou klou"
paste("hello",d) # → "hello klou"
# 補充：不要空白可用 paste0()，或 paste(..., sep = "")
# （函式參數用的 = 不能改成 <-）

#logical
# --- 邏輯值 (logical) ---

e <- TRUE
e2 <- c(T,T,F,F) #combines the TTFF into e2
# c() 把多個值「合併」成一個向量，e2 是長度 4 的邏輯向量
typeof(e)        # "logical"
class(e)         # "logical"
#c() function presents the "combine" action

f <- T           # T 是 TRUE 的縮寫
f2 <- c(T,F,T,F)
g <- FALSE
h <- F           # F 是 FALSE 的縮寫
# 注意：T 和 F 其實是可以被改掉的變數，TRUE/FALSE 才是保留字
# 正式程式建議寫完整的 TRUE / FALSE
#############

# --- 不同型態做運算時的自動轉型 ---
i <- a+b         # a 是 10（double），b 是約 3.178
i   #shows i     # 直接打變數名稱就會印出內容 → 約 13.178
typeof(i)        # "double"
class(i)         # "numeric"
#
j <- e+f         # 邏輯值做加法時，TRUE 會轉成 1、FALSE 轉成 0
j    #shows j    # TRUE + TRUE → 2
typeof(j)        # "integer"（邏輯值被轉成整數）
class(j)         # "integer"

###
# --- 邏輯運算：& 與 && 的差別 ---
k <- e & f        # AND   element-wise comparison, vector comparison
# &：逐一元素比較，可以用在向量
k                 # TRUE
k2 <- e2 & f2     # AND   element-wise comparison, vector comparison
# c(T,T,F,F) & c(T,F,T,F) 逐位比較
k2                # TRUE FALSE FALSE FALSE
k <- e && f        # comparision between two elements
# &&：只能比較「單一」邏輯值（長度為 1）
k                  # TRUE
k2 <- e2[3] && f2[3] # comparision between two elements
# [3] 取出向量的第 3 個元素：FALSE && TRUE
k2                   # FALSE
k2 <- e2 && f2   #there is an error
# 會出錯：&& 不能接受長度大於 1 的向量
# （R 4.3.0 之後是錯誤，舊版只會出現警告並只比第一個元素）

k <- e | f  # OR    # |：或，有一個是 TRUE 就是 TRUE → TRUE
k <- !k     # NOT   # !：反向，TRUE 變 FALSE → FALSE
typeof(k)           # "logical"
class(k)            # "logical"
#==========

# --- 比較運算子：結果都是邏輯值 ---
# 此時 a = 10、b 約 3.178
a > b       # 大於       → TRUE
a < b       # 小於       → FALSE
a >= b      # 大於等於   → TRUE
a == b      # 等於（注意是兩個等號；指定值用 <-）→ FALSE
a == a      # → TRUE
a != b      # 不等於     → TRUE

z <- (a>b)  # 比較結果可以存成變數 → TRUE
z <- !(a>b) # 加上 ! 取反 → FALSE

a <- !T     # !TRUE → FALSE，a 被覆蓋成邏輯值
a           # FALSE

isTRUE(a)   # 判斷是否「剛好是」單一的 TRUE → FALSE
# 常用在 if 條件，比直接寫 if (a) 更安全（遇到 NA 或長度不是 1 都會回傳 FALSE）
