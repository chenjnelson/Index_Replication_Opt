# setwd('')
library(ggplot2)
library(linprog)

source('read_Data.R')
source('similarity_Score.R')
source('index_Replication.R')

#number of stocks in your index replication strategy
n = 50

rho = similarity_Score(price_Matrix,shares_Matrix,tickers_uniq,dates_uniq)
rho_2 =similarity_Score2(price_Matrix,shares_Matrix,tickers_uniq,dates_uniq)

#Weights of each fund
fund_1 = constructFund(rho,n,final_shout,final_prices)
fund_2 =  constructFund(rho_2,n,final_shout,final_prices)

#Calculate returns of the holdings
end_prices=matrix(price_Matrix[length(price_Matrix[,1]),])
MonthlyPriceMat2=rbind(t(end_prices),MonthlyPriceMat[1:length(MonthlyPriceMat[,1])-1,])
final_returns=(MonthlyPriceMat-MonthlyPriceMat2)/MonthlyPriceMat2

fund_1_ret = final_returns %*% fund_1
fund_2_ret = final_returns %*% fund_2

#Compare to the index, monthly view
index_data = read.csv('NasdaqMonthly.csv',header = TRUE,stringsAsFactors=FALSE)
returns=index_data[2:length(index_data[,8]),8]
index_ret = matrix(returns,ncol=1)

#Plot
Month  <- seq(from=1,to=12,by=1)
Fund_1 <- (fund_1_ret-index_ret) * 100
Fund_2 <- (fund_2_ret-index_ret) * 100
Index <- (index_ret-index_ret) * 100

df <- data.frame(Month,Fund_1,Fund_2,Index)
df_reshape = reshape2::melt(df,id.var = 'Month', variable.name = 'Strategy'); 


ggplot(df_reshape, aes(x=Month, y = value, col = Strategy)) + geom_line() + ggtitle("Replicated fund tracking w.r.t. index") +  ylab("Difference in Returns (%)")+ 
  scale_x_continuous(limits = c(1,12), breaks=seq(1,12,1))


