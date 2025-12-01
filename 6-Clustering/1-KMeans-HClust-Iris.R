##########################################
#Editor: Kuo-Liang Ou
#National Tsing Hua University ILST
##########################################
# k-means
k_result <- kmeans(iris[,-5], 3) #去除非數值欄位後分三群
k_result$cluster # 回傳 vector 1 to k
k_result$centers # 中心點
k_result$size    # 各群數量
table(iris$Species,k_result$cluster) #confusion matrix

plot(iris[c("Sepal.Length","Sepal.Width")],
     col=k_result$cluster) # color 設定為群代號
points(k_result$centers[,c("Sepal.Length","Sepal.Width")],
       col=1:3, pch=2) #顯示中心點

##########################################
# hierarchical cluster

iris_sample = iris[,1:4]
h_result = hclust(dist(iris_sample),method="complete")  # distance matrix
      # method = measure the distance between clusters
      # see https://www.datacamp.com/tutorial/hierarchical-clustering-R
#h_result = hclust(dist(iris_sample),method="single")
#h_result = hclust(dist(iris_sample),method="average")
#h_result = hclust(dist(iris_sample),method="centroid")
h_result
h_result$height # the value of the criterion associated with the clustering method 
h_result$merge
#method could be: single complete average centroid

plot(h_result,labels=iris$Species)

#raw Rectangles Around Hierarchical Clusters
rect.hclust(h_result,k=3,border="blue") #
rect.hclust(h_result,k=6,border="red")
###








