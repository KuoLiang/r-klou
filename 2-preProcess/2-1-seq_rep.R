#sequence   seq.int(from, to, by, length.out, along.with, ...)
1:10        #a sequence
seq(1:10)   #連續數
seq(1,10)
seq(from =1, to=10) #指定參數
seq(1, 10, by=2)  #等差
seq(1, 10, 2)     #等差
seq(1.1, 10.1)   #from =1.1 ; to=10.1 ; by=1 預設值為1
seq(1.1, 10.1, 1.1) #from =1.1 ; to=10.1 ; by=1.1
seq(from=1,to=10,length=3)  #1至10之間等差，共3個
seq(from=1,to=10,length=100)  #1至10之間等差，共100個

#repeat     rep(x, times)
rep(1,10)
rep(1.1,10)
rep("hello",10)
rep(c(1,3),10)
rep(1:3,10)
rep(NA,10)
rep(c(1,3),each=5)
rep(c(1,3),10)

