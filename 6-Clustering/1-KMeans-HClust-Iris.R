##########################################
#Editor: Kuo-Liang Ou
#National Tsing Hua University ILST
##########################################
# ============================================================
# 6-1 分群入門：K-means 與階層式分群（iris 資料）
# ============================================================
# 【分群 (clustering) 和分類有什麼不同？】
#   分類（第 5 單元）：資料有「答案」（品種），讓電腦學會判斷 → 監督式學習
#   分群（這個單元）：資料「沒有答案」，讓電腦自己把相似的資料歸成一群 → 非監督式學習
#   這裡雖然用 iris，但分群時刻意「不給」品種，最後再拿品種來對照，看分得好不好。
#
# 這個範例介紹兩種方法：
#   1. K-means：先指定要分 k 群，反覆調整各群的中心點，直到穩定
#   2. 階層式分群 (hierarchical clustering)：一開始每筆資料各自一群，
#      每次把「最近的兩群」合併，最後畫成樹狀圖 (dendrogram)
#
# 說明：#> 是 R 4.6.1 實際執行的結果。
#       kmeans 的初始中心點是隨機的，每次執行時群的「編號」可能不同（例如 setosa 這次是第 2 群，
#       下次可能是第 1 群），偶爾分群結果也會略有差異。想固定結果，請在前面加上 set.seed(數字)。
# ============================================================

# ------------------------------------------------------------
# 第一部分：K-means
# ------------------------------------------------------------
# k-means
k_result <- kmeans(iris[,-5], 3) #去除非數值欄位後分三群
#  kmeans(資料, 群數)
#  iris[,-5]：去掉第 5 欄 Species。分群只能用數字計算距離，而且不能偷看答案
#  做法：
#    1. 隨機選 3 個點當初始中心
#    2. 每朵花分給「最近的中心」
#    3. 重新計算每群的平均值當新中心
#    4. 重複 2、3 直到中心不再移動
k_result$cluster # 回傳 vector 1 to k
#  每朵花被分到第幾群（150 個數字）
#>   [1] 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
#>  [43] 2 2 2 2 2 2 2 2 3 3 1 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 1 3 3 3 3 3 3
#>  ...（省略）...
k_result$centers # 中心點
#  每群在 4 個特徵上的平均值
#>   Sepal.Length Sepal.Width Petal.Length Petal.Width
#> 1     6.850000    3.073684     5.742105    2.071053
#> 2     5.006000    3.428000     1.462000    0.246000
#> 3     5.901613    2.748387     4.393548    1.433871
#  第 2 群花瓣很短 (1.46)，看起來就是 setosa
k_result$size    # 各群數量
#> [1] 38 50 62
table(iris$Species,k_result$cluster) #confusion matrix
#  把分群結果和真實品種對照（因為群沒有名字，所以這不算真正的混淆矩陣，只是交叉表）
#>               1  2  3
#>   setosa      0 50  0
#>   versicolor  2  0 48
#>   virginica  36  0 14
#  setosa 50 朵全部在第 2 群；versicolor 大多在第 3 群、virginica 大多在第 1 群
#  但有 14 朵 virginica 和 versicolor 混在一起 → 這兩種花的尺寸本來就很接近
#  在沒有答案的情況下，能分到這樣已經很不錯

plot(iris[c("Sepal.Length","Sepal.Width")],
     col=k_result$cluster) # color 設定為群代號
#  用花萼長、寬畫散布圖，依群編號上色（1 黑、2 紅、3 綠）
points(k_result$centers[,c("Sepal.Length","Sepal.Width")],
       col=1:3, pch=2) #顯示中心點
#  points()：在現有的圖上加點；pch = 2 是空心三角形
#  三個三角形就是三群的中心
#  注意：分群用了 4 個特徵，但圖只畫 2 個，所以有些點看起來顏色混在一起是正常的

# ------------------------------------------------------------
# 第二部分：階層式分群
# ------------------------------------------------------------
##########################################
# hierarchical cluster

iris_sample = iris[,1:4]
h_result = hclust(dist(iris_sample),method="complete")  # distance matrix
      # method = measure the distance between clusters
      # see https://www.datacamp.com/tutorial/hierarchical-clustering-R
#  dist()：先算出 150 朵花兩兩之間的距離（歐氏距離）
#  hclust(距離, method = ...)：根據距離做階層式分群
#  method 決定「兩群之間的距離」怎麼算：
#    complete 完全連結：兩群中「最遠」的兩點距離（容易形成大小相近的群）
#    single   單一連結：兩群中「最近」的兩點距離（容易形成長條狀的群）
#    average  平均連結：兩群所有點兩兩距離的平均
#    centroid 中心連結：兩群中心點的距離
#    ward.D2  華德法：合併後群內變異增加最少（實務上很常用）
#h_result = hclust(dist(iris_sample),method="single")
#h_result = hclust(dist(iris_sample),method="average")
#h_result = hclust(dist(iris_sample),method="centroid")
#method could be: single complete average centroid

h_result
#> Cluster method   : complete
#> Distance         : euclidean
#> Number of objects: 150
h_result$height # the value of the criterion associated with the clustering method
#  每次合併時，兩群之間的距離（共 149 次合併，由小到大）
#>   [1] 0.0000000 0.1000000 0.1000000 0.1000000 ...
#>  ...（省略）...
#> [145] 2.2360680 2.4289916 3.2109189 4.0249224 7.0851958
#  第 1 個是 0：有兩朵花的尺寸完全一樣
#  最後幾次合併的距離突然變很大（3.2 → 4.0 → 7.1），表示在那之前分成 2~3 群是比較自然的
h_result$merge
#  每一步合併了誰：負數代表單一一朵花（-102 = 第 102 朵），正數代表之前合併出來的群
#>        [,1] [,2]
#>   [1,] -102 -143      ← 第 1 步：第 102 朵和第 143 朵合併
#>   [2,]   -8  -40
#>  ...
#>  [22,]  -41    3      ← 第 22 步：第 41 朵和「第 3 步產生的群」合併
#>  ...（省略）...

plot(h_result,labels=iris$Species)
#  畫出樹狀圖：最底下是 150 朵花（標上品種名稱），越往上合併的群越大
#  縱軸高度 = 合併時的距離。標籤很多會擠在一起，可以加上 cex = 0.5 縮小字體

#raw Rectangles Around Hierarchical Clusters
rect.hclust(h_result,k=3,border="blue") #
#  在樹狀圖上用藍框圈出「切成 3 群」的結果
rect.hclust(h_result,k=6,border="red")
#  用紅框圈出「切成 6 群」的結果
#  想取得每朵花屬於哪一群，可以用 cutree()：
#    table(iris$Species, cutree(h_result, k = 3))
#>               1  2  3
#>   setosa     50  0  0
#>   versicolor  0 23 27
#>   virginica   0 49  1
#  這次 complete 法把 versicolor 拆散到兩群，效果比 kmeans 差
###









# ============================================================
# 重點整理
# ============================================================
# | 項目         | K-means                       | 階層式分群                      |
# |--------------|-------------------------------|---------------------------------|
# | 函數         | kmeans(資料, k)               | hclust(dist(資料), method)      |
# | 要先決定群數 | 要                            | 不用，畫完樹再決定切幾群        |
# | 結果         | $cluster、$centers、$size     | 樹狀圖、cutree(結果, k)         |
# | 隨機性       | 有（初始中心隨機）            | 沒有，每次結果相同              |
#
# 提醒：分群是用「距離」計算，各特徵的數值範圍差很多時要先標準化：scale(資料)
#
# 練習題
# 1. 在 kmeans 前加 set.seed(1)，執行兩次確認結果相同
# 2. 把 method 改成 "average" 或 "ward.D2"，用 table(iris$Species, cutree(h_result, 3)) 比較效果
# 3. 試試 kmeans(iris[,-5], 2)，分成 2 群時是哪些品種被分在一起？
