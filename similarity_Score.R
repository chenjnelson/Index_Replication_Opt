#Generate similarity score for ILP formulation

#covariance
similarity_Score = function(price_Mat,shares_Mat,unique_tickers,unique_dates){
  temp = price_Mat[1:nrow(price_Mat)-1,]
  returnsMat = (price_Mat[2:nrow(price_Mat),] - temp)/temp
  covMat = cov(returnsMat,y=NULL,use="pairwise.complete.obs")
  return (covMat)
}

#correlation
similarity_Score2 = function(price_Mat,shares_Mat,unique_tickers,unique_dates){
  temp = price_Mat[1:nrow(price_Mat)-1,]
  returnsMat = (price_Mat[2:nrow(price_Mat),] - temp)/temp
  corMat = cor(returnsMat,y=NULL,use="pairwise.complete.obs")
  return (corMat)
}
