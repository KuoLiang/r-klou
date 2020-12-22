query_cast = function(query_result){
  query_df=fetch(query_result, n = -1) 
  mycast=dcast(query_df,
               firstname~Month,
               fun.aggregate = sum,
               value.var = "num",
               fill = NA_real_)
  mymat=as.matrix(mycast[,-1])
  rownames(mymat) = mycast$firstname
  return(mymat)
}