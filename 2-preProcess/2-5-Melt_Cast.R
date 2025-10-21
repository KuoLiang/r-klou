if (!require("reshape2")) install.packages("reshape2")
library(reshape2)
################
#this is the melt
################
df1 <- data.frame(
  SID = c(1, 2, 3, 4),
  Dept = c("A", "B", "A", "B"),
  Scores = c(10, 20, 30, 40)
)
# 若有空值時
# df1 <- data.frame(
#   SID = c(1, 2, 3, 4),
#   Dept = c("A", "B", "A", "C"),
#   Scores = c(10, 10, 20, 20)
# )

df1
### melt to 2 cols with Col_Name and values
#wide to long ,伸長, 把欄位名稱變成新欄位的值
#melt(data,id.vars,measure.vars,variable.name = "variable")

df_long <- melt(df1, 
             measure =c("SID", "Dept","Scores"),   #哪些欄位需要依序往下伸長
             variable = c("Col_Name"))   #原來欄位名稱變成值後，該欄的新名稱
df_long
df_long2 <- melt(df1, 
                id=c("SID"),
                measure =c("Dept","Scores"),   #哪些"欄位"需要依序往下伸長
                variable = c("Col_Name"))   #原來欄位名稱變成值後，該欄的新名稱
df_long2

### dcast 
#long to wide, 變寬
# Reshape data from long to wide format using dcast
df_wide <- dcast(df1, SID ~ Category, value.var = "Value") #Y~X 指定 Y 軸 X 軸 
df_wide
df_wide2 <- dcast(df1, Category ~ Value, value.var = "SID") #Y~X 指定 Y 軸 X 軸 
df_wide2

################
