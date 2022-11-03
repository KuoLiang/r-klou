install.packages("pROC")
library(pROC)
library(e1071)
result_radial_1<-svm(Species~.,iris,
                     kernel="radial",gamma=10^-1)

result_radial_2<-svm(Species~.,iris,
                     kernel="radial",gamma=10^-2)

result_radial_3<-svm(Species~.,iris,
                     kernel="radial",gamma=10^-3)

#將 Specise 轉為 123代號
pre_1<-as.numeric(predict(result_radial_1,iris))
pre_2<-as.numeric(predict(result_radial_2,iris))
pre_3<-as.numeric(predict(result_radial_3,iris))

#執行 multicalss.roc
a1<-multiclass.roc(iris$Species,pre_1)
a2<-multiclass.roc(iris$Species,pre_2)
a3<-multiclass.roc(iris$Species,pre_3)

#a1[["rocs"]][[1]] setosa vs versicolor
#a1[["rocs"]][[2]] setosa vs virginicar
#a1[["rocs"]][[3]] viersicolor vs virginica
#print.auc.y  : y position for the printing of the AUC.
#add = TRUE, the ROC curve will be added to an existing plot

plot.roc(a1[["rocs"]][[3]],print.auc = T,col="blue",
         print.auc.y = .5,legacy.axes = TRUE,lty=4,
         main="Versicolor & Virginica")
plot.roc(a2[["rocs"]][[3]],print.auc = T,col="red",
         print.auc.y = .4,add=T,legacy.axes = TRUE,lty=3)
plot.roc(a3[["rocs"]][[3]],print.auc = T,col="green",
         print.auc.y = .3,add=T,legacy.axes = TRUE,lty=2)
legend(.2,.3,legend = c("γ=10^-1","γ=10^-2","γ=10^-3")
       ,col = c("blue","red","green"),lty=c(4,3,2))

