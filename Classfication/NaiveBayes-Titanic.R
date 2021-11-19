if(!require("e1071")) install.packages("e1071")
library(e1071)
?naiveBayes 

data(“Titanic”)

Titanic_df=as.data.frame(Titanic)


repeating_sequence=rep.int(seq_len(nrow(Titanic_df)), Titanic_df$Freq) 
#This will repeat each combination equal to the frequency of each combination
#Create the dataset by row repetition created
Titanic_dataset=Titanic_df[repeating_sequence,]
Titanic_dataset
#We no longer need the frequency, drop the feature
Titanic_dataset$Freq=NULL

#Fitting the Naive Bayes model
Naive_Bayes_Model=naiveBayes(Survived ~., data=Titanic_dataset)
#What does the model say? Print the model summary
Naive_Bayes_Model
NB_Predictions=predict(Naive_Bayes_Model,Titanic_dataset)
table(NB_Predictions,Titanic_dataset$Survived)
NB_Predictions
