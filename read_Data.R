#Package to pull financial data
#library(quantmod)

#View information of QQQ here:
#getSymbols("QQQ", src = 'yahoo')
#head(QQQ)

#You can find all ticker names in QQQ here. Unfortunately, I cannot find historical index data for now, but a better practice
#would be to obtain this data as well as adjusted information whenever you are working with backtesting information
#https://www.invesco.com/portal/site/us/investors/etfs/holdings/?ticker=QQQ

#I also believe the retrieval of 'shares outstanding' is deprecated in quantmod. You can use the csv in the github as an exercise
data = read.csv('NASDAQ100StockInfo.csv',header =TRUE)

#Quick cleaning exercise
data = na.omit(data)
ticker = data$TICKER
price = data$PRC
shares = data$SHROUT
date = apply(as.matrix(data$date),MARGIN = 1,FUN = 'toString')
date = as.Date(date,'%Y%m%d')

# MDLZ spun off during this time period
delete = seq(1,dim(data)[1])[ticker == 'MDLZ']
data = data[-delete,]

# Ticker name changes during this time period
ticker[ticker == 'KFT'] = 'KRFT'
ticker[ticker == 'SXCI'] = 'CTRX'
ticker[ticker == 'HANS'] = 'MNST'

# convert prices to a matrix
dates_uniq = sort(unique((date)))
tickers_uniq = sort(unique(ticker))

price_Matrix = matrix(NA,length(dates_uniq),length(tickers_uniq))
final_shout = matrix(0,1,length(tickers_uniq))
shares_Matrix = matrix(0,length(dates_uniq),length(tickers_uniq))

for(i in 1:length(tickers_uniq)){
  tick = tickers_uniq[i]
  idx = is.element(dates_uniq,date[ticker == tick])
  
  price_Matrix[idx,i] = price[ticker == tick]
  final_shout[1,i] = shares[ticker == tick & date == dates_uniq[length(dates_uniq)]] 
  shares_Matrix[idx,i] = shares[ticker == tick]                    
}
final_prices = price_Matrix[nrow(price_Matrix),]


#Bring in Monthly Data
mdata = read.csv('NASDAQ100Monthly.csv',header = TRUE,stringsAsFactors=FALSE)

# clean up data
mdate = apply(as.matrix(mdata$date),MARGIN = 1,FUN = 'toString')
mdate = as.Date(mdate,'%Y%m%d')

mticker = mdata$TICKER
mprice = mdata$PRC
mshares = mdata$SHROUT
mticker[mticker == 'FOXA'] = 'NWSA' 


unique_mdates = sort(unique((mdate)))
unique_mtickers = sort(unique(mticker))

idx = is.element(unique_mtickers,tickers_uniq)

if(!all(idx)){
  print('Warning: Some tickers seem to be missing')
}

MonthlyPriceMat = matrix(NA,length(unique_mdates),length(tickers_uniq))

for(i in 1:length(tickers_uniq)){
  tic = tickers_uniq[i]
  idx = is.element(unique_mdates,mdate[mticker == tic])
  MonthlyPriceMat[idx,i] = mprice[mticker == tic]
}
MonthlyPriceMat

