data("iris")

max = ceiling(1*nrow(iris))
sample_index = sample(1:nrow(iris),max)
iris_sample = iris[sample_index,1:4]

cluster_result = hclust(dist(iris_sample),method="complete")
#single complete average centroid
plot(cluster_result,labels=iris$Species[sample_index])
rect.hclust(cluster_result,k=3)

###

data(iris)
attributes(iris)
iris2=iris
iris2$Species = NULL
(kmeans.result = kmeans(iris2,3))
kmeans.result
kmeans.result$size
kmeans.result$centers

kmeans.result$cluster
iris$Species
table(iris$Species, kmeans.result$cluster)


plot(iris2[c("Sepal.Length","Sepal.Width")],col=kmeans.result$cluster)
points(kmeans.result$centers[,c("Sepal.Length","Sepal.Width")],col=1:3, pch=9)


===






