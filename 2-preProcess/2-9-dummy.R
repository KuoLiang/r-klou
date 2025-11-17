################################
#dummyVars
#將類別資料轉為數值資料
################################

if(! require("dummy")) install.packages("dummy")
library(dummy)

dummy_diamonds <- dummy(diamonds[,-3]) #without color
my_diamonds <- cbind(diamonds,dummy_diamonds)


