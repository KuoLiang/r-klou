#install.packages("devtools") #for installing packages from github
library(devtools)
devtools::install_github("ben-aaron188/rgpt3")
library(rgpt3)
library(lsa)
setwd("/Users/klou/Documents/GitHub/")
gpt3_authenticate("access_key.txt")
a <- gpt3_test_completion()   # test connection
#################################################
sample_string = "London is one of the most liveable cities in the world. The city is always full of energy and people"
b <- gpt3_single_embedding(input = sample_string)
b
#################################################

data("travel_blog_data")

#################################################
b11 <- gpt3_single_embedding(input = travel_blog_data$gpt3[1])
b11
b12 <- gpt3_single_embedding(input = travel_blog_data$gpt3[2])
b12
#################################################

klou_cv = "Dr. Kuo-Liang Ou received his Ph.D. degree in Computer Science from National Central University in Taiwan. He is currently the associate professor of Institute of Learning Sciences and Technologies, director of Center for Institutional Research, National Tsing Hua University, Taiwan. His research interests include learning technology, VR/AR, machine learning, and natural language processing."
b_klou <- gpt3_single_embedding(input = klou_cv)
klou_ccv = "區國良教授在2001年取得中央大學資訊工程博士，研究專長包含虛擬/擴增實境、機器學習、學習科技以及自然語言處理，目前為國立清華大學學習科學與科技研究所教授，兼任校務研究中心主任；曾經擔任國立新竹教育大學計算機網路中心組長、圖書館館長、人力資源發展研究所所長以及國立清華大學副學務長等職。"
b_klouc <- gpt3_single_embedding(input = klou_ccv)

cosine(b,b11) 

cosine(b,b12) 

cosine(b11,b12) 

cosine(b,b_klou) 

cosine(b_klouc,b_klou) 

all_sentences <- cbind(b,b11,b12,b_klou,b_klouc)
cosine(all_sentences)
#################################################

vec1 = c( 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0 )
vec2 = c( 0, 0, 1, 1, 1, 1, 1, 0, 1, 0, 0, 0 )
cosine(vec1,vec2) 
vec3 = c( 0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0 )
ma = cbind(vec1,vec2, vec3)
cosine(ma)

#################################################
data(iris)
das <- c('Sepal.Length','Sepal.Width','Petal.Length','Petal.Width')
ma <- as.matrix(iris[,das])
cosine(ma)

################################################

c <- gpt3_single_completion(prompt_input = '說個冷笑話吧')
c[[1]]$gpt3

d <- gpt3_single_completion(prompt_input = "寫一封情書"
       , temperature = 0.8, max_tokens = 100)
d[[1]]$gpt3
