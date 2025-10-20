#製造連續等差數列
#多行註解熱鍵
#Comment for multiple lines
#Ctrl + Shift + C (Windows/Linux) or Command + Shift + C (Mac).

#sequence  製造由X開始到Y結束之等差數列,差值為實數
#seq(from, to, by, length.out, along.with, ...)
###
1:10        #it is a sequence
seq(1:10)   #連續數，使用預設參數，無法使用其它參數
seq(1,10)   #同上，但可再指定其它參數如下
seq(from =1, to=10) #指定參數
seq(1, 10, by=2)    #等差為2
seq(1, 10, 2)       #等差同上
seq(1.1, 10.1)      #from =1.1 ; to=10.1 ; by=1 預設值為1
seq(1.1, 10.1, 1.1) #from =1.1 ; to=10.1 ; by=1.1
seq(from=1,to=10,length=3)  #1至10之間等差，共3個
seq(from=1,to=10,length=100)  #1至10之間等差，共100個

### 製造由X開始共Y個等差數列,差值為整數
#sequence() ,it's difference with seq()
###
sequence(c(5,6))  # 1:5 and 1:6 ( from 預設值為1)
sequence(c(3,2), from=2) # 2 to 4 (共3個) and 2 to 3 (共2個)
sequence(c(3,2,5,2), from=6, by=2) #結果是什麼？

###製告X重覆Y次
#rep(x, times)
###
rep(1,10)
rep(1.1,10)
rep("hello",10)
rep(1:3,10)       #repeat 1 to 3 for 10 times
rep(NA,10)
rep(c(1,3),10)    #repeat vector (1,3) 10 times
rep(c(1,3),each=5)#repeat each element 5 times of vector (1,3)
