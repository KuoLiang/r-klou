if (!require("reshape2")) install.packages("reshape2")
library(reshape2)
################
#this is the melt
################
df1 <- data.frame(
  SID = c(1, 2, 3, 4),
  Dept = c("CS", "Math", "CS", "Math"),
  Grade = c(2, 2, 3, 4),
  Scores = c(10, 20, 30, 40)
)
df1
### melt to cols with Col_Name and values
#wide to long ,伸長, 把欄位名稱變成新欄位的值
#melt(data,id.vars,measure.vars,variable.name = "variable")

df_long <- melt(df1, 
             measure =c("SID", "Dept","Grade","Scores"),   #哪些"欄位名稱"需要變成值,依序往下伸長
             variable = c("Col_Name"))   #以上欄位名稱變成新欄位的值後，該欄的新名稱
df_long

df_long1 <- melt(df1, 
                id = c("SID","Dept"),           #固定指定欄位設為 ID,分別對應其它欄位
                measure =c("Grade","Scores"),   #哪些"欄位名稱"需要變成值,依序往下伸長
                variable = c("Col_Name"))   #以上欄位名稱變成新欄位的值後，該欄的新名稱
df_long1

df_long2 <- melt(df1, 
                id=c("SID"),                 #固定指定欄位設為 ID,分別對應其它欄位
                measure =c("Dept","Scores"),   #只挑部分"欄位名稱"需要變成值,依序往下伸長
                variable = c("Col_Name"))   #原來欄位名稱變成值後，該欄的新名稱
df_long2

### dcast 
#long to wide, 變寬
# Reshape data from long to wide format using dcast
# formula : rowvar1 + rowvar2 +...  ~  colvar1 + colvar2 +...

df_wide <- dcast(df1, SID ~ Dept, value.var = "Scores") #Y~X 指定 Y 軸 X 軸 
df_wide

df_wide <- dcast(df1, Dept ~ Grade, value.var = "Scores",mean) #Y為各系，X為年級，求平均 
df_wide

df_wide <- dcast(df1, Dept ~ ., value.var = "Scores",mean) #各系平均 
df_wide

df_wide2 <- dcast(df1, SID ~ Dept+Grade, value.var = "Scores") #Y~X 指定 Y 軸 X 軸 
df_wide2

################
#將 melt 反向 cast 回原來的 df ,原來有 id 者才能設為 Y 反回
df_long1
df_orig <- dcast(df_long1, SID + Dept ~ Col_Name) #Y~X 指定 Y 軸 X 軸 
df_orig

#將 melt 反向 cast 回原來的 df (但少了 Grade)
df_long2
df_orig <- dcast(df_long2, SID ~ Col_Name) #Y~X 指定 Y 軸 X 軸 
df_orig

