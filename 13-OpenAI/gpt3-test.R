#install.packages("devtools") #for installing packages from github
library(devtools)
devtools::install_github("ben-aaron188/rgpt3")
library(rgpt3)
install.packages("lsa")
library(lsa)
setwd("/Users/klou/Documents/GitHub/")
rgpt_authenticate("access_key.txt")
a <- rgpt_test_completion()   # test connection
#################################################
sample_string = "London is one of the most liveable cities in the world. The city is always full of energy and people"
b <- rgpt_single_embedding(input = sample_string)
b
#################################################

data("travel_blog_data")

#################################################
b11 <- rgpt_single_embedding(input = travel_blog_data$gpt_content[1])
b11
b12 <- rgpt_single_embedding(input = travel_blog_data$gpt_content[2])
b12
#################################################

klou_cv = "Dr. Kuo-Liang Ou received his Ph.D. degree in Computer Science from National Central University in Taiwan. He is currently the associate professor of Institute of Learning Sciences and Technologies, director of Center for Institutional Research, National Tsing Hua University, Taiwan. His research interests include learning technology, VR/AR, machine learning, and natural language processing."
b_klou <- rgpt_single_embedding(input = klou_cv)
klou_ccv = "區國良教授在2001年取得中央大學資訊工程博士，研究專長包含虛擬/擴增實境、機器學習、學習科技以及自然語言處理，目前為國立清華大學學習科學與科技研究所教授，兼任校務研究中心主任；曾經擔任國立新竹教育大學計算機網路中心組長、圖書館館長、人力資源發展研究所所長以及國立清華大學副學務長等職。"
b_klouc <- rgpt_single_embedding(input = klou_ccv)
john_ccv = "高為元出生	1968年10月13日（55歲）臺灣台北市 居住地	 臺灣新竹市 母校	約翰斯·霍普金斯大學、凱斯西儲大學科學生涯 研究領域	生物材料與生物醫學工程 機構	國立清華大學 高為元（W. John Kao，1968年10月13日—）出生於中華民國臺北市，生物材料與生物醫學工程學者，美國醫學與生物工程院院士、國際生物材料科學與工程學會聯合會院士、香港工程師學會院士，現任國立清華大學校長、劉炯朗講座教授，曾任香港大學講座教授、副校長、香港科技園轉化研發所所長及威斯康辛大學麥迪遜分校講座教授、國際研究院副院長、臨床及轉化科學研究所副所長。"
b_johnc <- rgpt_single_embedding(input = john_ccv)
tsai_ccv = "蔡英文（排灣語：Tjuku，英語：Tsai Ing-wen；1956年8月31日—），中華民國政治人物、法學家與律師，民主進步黨籍，現任中華民國總統及中華文化總會會長[10][11]。她曾擔任民主進步黨主席、行政院副院長、立法委員、大陸委員會主任委員、國家安全會議諮詢委員等職務。生於臺北市中山區，本籍屏東縣枋山鄉楓港村，是客家人（福佬客）和臺灣原住民族排灣族之後裔。求學期間先後獲得國立臺灣大學法律學系法學士、康乃爾大學法學院法學碩士以及倫敦政治經濟學院法學博士的學位[註 1]，並曾任教於國立政治大學法學院、商學院和東吳大學法學院。1986年，她參與世界貿易組織等國際談判，獲得政府賞識。[14]在李登輝政府時期，她是國安會諮詢委員，為「特殊的國與國關係」理論的主要起草人。2000年陳水扁政府上臺後，她以無黨籍學者身分擔任陸委會主委。2004年，她加入民進黨擔任不分區立法委員。2006年，她擔任蘇貞昌內閣的行政院副院長，直到隔年總辭。2008年中華民國總統選舉民進黨因敗選下野，她在民進黨聲勢低落時當選黨主席，是該黨首位女性黨主席，[16]她帶領該黨轉型並在幾場選戰中勝出。2010年11月，她參與新北市市長選舉，敗給中國國民黨候選人朱立倫。[17]2012年中華民國總統選舉中，她代表民進黨參選，是中華民國首位女性總統候選人，但敗給競選連任的國民黨候選人馬英九，她辭去民進黨主席一職。2014年再度當選民進黨主席，並贏得九合一選舉13席地方縣市首長。[19]2016年1月16日，她代表該黨參加總統選舉，擊敗國民黨候選人朱立倫、親民黨候選人宋楚瑜；同時，該黨在立法院取得過半席次，首度完全執政，為中華民國第三次政黨輪替。同年5月20日，她宣誓就任中華民國總統，是中華民國首位女總統，也是第一位擁有原住民血統的總統，更是華人世界第一位女性總統。[20]同時她也是世界上第一位任命了部長級跨性別人士的國家元首[註 3]。2018年，民進黨在九合一選舉慘敗後，她辭去民進黨主席一職。[21]2019年2月19日，她接受專訪時表態要競選連任，[22]6月亦在初選勝出，正式代表該黨參選。[23]2020年總統選舉，蔡英文以約817萬的得票數順利連任，擊敗國民黨候選人韓國瑜、親民黨候選人宋楚瑜，是中華民國自1996年開放直選至今得票數最高的總統。[24][25]亦成為首位當選連任的東亞女性元首，後再兼任民進黨主席；同時民進黨在立法院取得過半席次，繼續完全執政。[26][27][28]2022年，民進黨在九合一選舉慘敗後，她辭去民進黨主席一職。"
b_tsaic <-  rgpt_single_embedding(input = tsai_ccv)
  
cosine(b,b11) 
cosine(b,b12) 
cosine(b11,b12) 
cosine(b,b_klou) 
cosine(b_klouc,b_klou) 
cosine(b_johnc,b_klouc) 

all_sentences <- cbind(b,b11,b12,b_klou,b_klouc,b_johnc,b_tsaic)
result <- cosine(all_sentences)
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

c <- rgpt_single(prompt_content = '說個冷笑話吧')
c[[1]]$gpt_content

d <- rgpt_single(prompt_content = "寫一封情書"
       , temperature = 0.8, max_tokens = 100)
d[[1]]$gpt_content
