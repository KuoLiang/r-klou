##########################################
#Editor: Kuo-Liang Ou
#National Tsing Hua University ILST
##########################################
# k-means
k_result <- kmeans(iris[,-5], 3)
k_result$cluster
k_result$centers
k_result$size
table(iris$Species,k_result$cluster)

plot(iris[c("Sepal.Length","Sepal.Width")],
     col=kmeans.result$cluster)
points(k_result$centers[,c("Sepal.Length","Sepal.Width")],
       col=1:3, pch=2)

##########################################
# hierarchical cluster

iris_sample = iris[,1:4]
h_result = hclust(dist(iris_sample),method="complete")
h_result
#method = single complete average centroid
plot(h_result,labels=iris$Species)
rect.hclust(cluster_result,k=3,border="blue")
rect.hclust(cluster_result,k=6,border="red")
###








