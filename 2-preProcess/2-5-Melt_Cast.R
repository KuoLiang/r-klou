if (!require("reshape2")) install.packages("reshape2")
library(reshape2)
################
#this is the melt
################
df1 <- data.frame(
  SID = c(1, 1, 2, 2),
  Category = c("A", "B", "A", "B"),
  Value = c(10, 20, 30, 40)
)
# 若有空值時
# df1 <- data.frame(
#   SID = c(1, 1, 2, 2),
#   Category = c("A", "B", "A", "C"),
#   Value = c(10, 10, 20, 20)
# )

df1
### melt to 2 cols with Col_Name and values
#wide to long ,接長, 把欄位名稱變成新欄位的值

df_long <- melt(df1, 
             measure.vars =c("SID", "Category","Value"),   #哪些欄位需要拉長
             variable.name = c("Col_Name"))   #原來欄位名稱變成值後，該欄的新名稱
df_long

### dcast 
#long to wide, 變寬
# Reshape data from long to wide format using dcast
df_wide <- dcast(df1, SID ~ Category, value.var = "Value") #Y~X 指定 Y 軸 X 軸 
df_wide
df_wide <- dcast(df1, Category ~ Value, value.var = "SID") #Y~X 指定 Y 軸 X 軸 
df_wide

################
