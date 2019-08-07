constructFund = function(rho,q,finalShares,final_prices){
  size = ncol(rho)
  
  scores = c(as.vector(t(rho)),rep(0,size))
  
  
  numberOfConstraints = 1+size+(size*size)
  constraint = matrix(0,numberOfConstraints,length(scores))
  
  #sum of ys is equal to q
  constraint[1,(length(scores)-size+1):length(scores)] <- 1
  
  #each row sums to 1
  for (i in 2:(1+size)){
    constraint[i,(((i-2)*size)+1):((i-1)*size)] <- 1
  }
  
  #last... each entry in x is less than the corrasponding y for the column
  start = 2+size
  end = numberOfConstraints
  for (i in start:end){
    index = i-start+1
    if((index + size)%%size==0){
      spot = size
    }else{
      spot = (index + size)%%size
    }
    
    constraint[i,index] = 1
    constraint[i,spot+(size*size)] = -1
  }
  
  answer = c(q,rep(1,size),rep(0,size*size))
  equality = c("=",rep("=",size),rep("<=",size*size))
  
  result = lp("max",scores,constraint,equality,answer,compute.sens=TRUE,binary.vec=1:numberOfConstraints)
  
  x = matrix(result$solution[1:(size*size)],ncol=size,nrow=size,byrow=TRUE)
  
  finalValue = finalShares * final_prices
  weight = ((finalValue) %*% x) / sum((finalValue %*% x),na.rm = TRUE)
  
  return(t(weight))
}


