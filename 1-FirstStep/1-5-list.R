```r
# ============================================================
# R 的串列 (list) 練習
# 包含：建立 list、[ ] 與 [[ ]] 的差別、$ 取值、修改與合併
# ============================================================

#a list is a collection of data, they could be in different datatypes
#a list is ordered and changeable, ordered from 1, not zero!
# list 可以裝「不同型態」的資料（向量只能裝同一種型態）
# list 有順序、內容可以修改，索引從 1 開始，不是 0

# --- 建立 list ---
a <- list("THU", c("math", "ee", "cs"), c(1,2,3)) # a list contain a string and a vector
# 沒有名字的 list：3 個元素分別是字串、字串向量、數值向量
b <- list(name = "THU", dept = c("math", "ee", "cs"), grade = c(1,2,3))
# 有名字的 list：每個元素都有名稱，之後可以用名稱取值
# 這裡的 = 是「取名字」，不能改成 <-

a[1] #the list start from 1, not zero
# 取第 1 個元素，但回傳的是「包著 "THU" 的 list」
a[2]              # 回傳包著 c("math","ee","cs") 的 list
a[0]              # 索引 0 不會出錯，而是回傳空的 list → list()
a                 # 印出整個 list，[[1]]、[[2]]... 是元素編號

# --- 修改與新增元素 ---
a[1] <- "NTHU" #change the first value of a list
# 把第 1 個元素改成 "NTHU"
# 也可寫 a[[1]] <- "NTHU"，意思更明確
a <- append(a,4:6)
# 注意：向量 4:6 會被「拆開」，變成 3 個獨立的元素 4、5、6
# a 的長度從 3 變成 6
# 若想把 4:6 當成「一個」元素加入，要寫 append(a, list(4:6))
a <- append(a,c(7:9))
# 同上，再多 7、8、9 三個元素，a 長度變成 9
# 7:9 本身已經是向量，c() 可以省略

# --- 型態查詢：用 [ ] 取出來的一定還是 list ---
typeof(a)      # returns "list"
typeof(a[1])   # returns "list"
typeof(a[2])   # returns "list"
typeof(b)      # returns "list"
typeof(b[1])   # always returns "list"

#[[]] 運算子取得一個元素並保持原有的型態，可用數字或元素名稱
# --- [ ] 和 [[ ]] 的差別 ---
# [ ]  ：取出「裝著元素的小 list」（連盒子一起拿）
# [[ ]]：取出「元素本身」（把盒子打開，只拿裡面的東西）
a
a[[1]]                 # → "NTHU"
typeof(a[[1]])         # → "character"
typeof(a[1])           # → "list"
typeof(a)              # → "list"

b
b[["name"]]      #記得加雙引號      → "THU"
b["name"]              # → 包著 name 元素的 list（會顯示 $name）
b$name                 # $ 等同於 [[ ]]，而且不用加引號 → "THU"
b[1]                   # 用編號取，同 b["name"]
typeof(b[["name"]]) #character
typeof(b["name"])   #list
typeof(b$name)  #character
typeof(b[1])    #list

# --- 用 [[ ]] 查看每個元素原本的型態 ---
a[[1]]
typeof(a[[1]]) # return the datatype of list member   → "character"
typeof(a[[2]]) # return the datatype of list member   → "character"（字串向量）
typeof(a[[3]]) # return the datatype of list member   → "double"（c(1,2,3) 預設是 double）
# 補充：typeof(a[[4]]) 是 "integer"，因為 4:6 產生的是整數

a[[0]] #error
# [[ ]] 一定要取到「一個」元素，索引 0 不存在，所以出錯
# 對照：a[0] 不會出錯，只回傳空 list

# --- 多層取值：先取出元素，再取元素裡的值 ---
a[[2]][2] #get the second member's second member
# a[[2]] 是 c("math","ee","cs")，再取第 2 個 → "ee"

b$dept    #get value by $name
# → "math" "ee" "cs"

b$dept[2] #get value by $name and it's second member
# → "ee"

# combine lists
# --- 合併 list ---
b <- list("hello")      # 注意：b 被覆蓋成只有一個元素的新 list
c <- c(a,b)             # c() 也可以合併 list：a 的 9 個元素 + "hello" → 共 10 個元素
# 變數名稱 c 不會讓 c() 函式失效，但容易混淆
c


#把 list 想成火車。a[1] 是取出「第 1 節車廂」，仍然是一列火車（list）
#a[[1]] 是取出「第 1 節車廂裡的貨物」。
#append 和 c 的行為一樣：只要把向量加進 list，向量都會被拆成多個元素。想保持完整，就先用 `list()` 包起來。