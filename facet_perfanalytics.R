require(reshape2)
require(rCharts)
require(quantmod)
require(PerformanceAnalytics)

tckrs <- c('VBMFX','VFINX')

#outer lapply to make weekly
#inner lapply to get the symbols from Yahoo! Finance
prices <- lapply(lapply(
  tckrs,
  getSymbols, auto.assign=FALSE, from = '1990-01-01'
),function(x){to.weekly(x)[,6]})

#merge our two symbols in one xts
prices.xts <- na.omit(merge(prices[[1]],prices[[2]]))
#name columns same as tickers
colnames(prices.xts) <- tckrs

#get 1 period returns
returns.xts <- prices.xts/lag(prices.xts,k=1) - 1
#make first 0 rather than NA
returns.xts[1,] <- 0

cumul.xts <- cumprod(1+returns.xts)

#get the rolling 150 week (about 3y) OmegaSharpe measure on the tickers
oSharpe <- rollapply(returns.xts, FUN=OmegaSharpeRatio, width = 150, fill = 0 )

#get the drawdown
drawdown <- Drawdowns(returns.xts)

#melt the prices and rolling OmegaSharpe to combine for plotting
cumul.melt <- melt(
  data.frame(format(index(cumul.xts)), rep("CumulGrowth",NROW(cumul.xts)), cumul.xts),
  id.vars = 1:2
)
oSharpe.melt <- melt(
  data.frame(format(index(oSharpe)),rep("OmegaSharpe",NROW(oSharpe)),oSharpe),
  id.vars = 1:2
)
drawdown.melt <- melt(
  data.frame(format(index(drawdown)),rep("Drawdown",NROW(drawdown)),drawdown),
  id.vars = 1:2
)
colnames(cumul.melt) <- c("date","metric","fund","value")
colnames(oSharpe.melt) <- c("date","metric","fund","value")
colnames(drawdown.melt) <- c("date","metric","fund","value")

oSharpeCumul <- rbind( cumul.melt, oSharpe.melt, drawdown.melt )

#make an interactive d3 plot of the rollilng OmegaSharpe
dSharpe = dPlot(
  value ~ date,
  groups = "fund",
  data = oSharpeCumul,
  type = "line",
  height = 500,
  width = 900
)
dSharpe$xAxis(
  type = "addTimeAxis",
  inputFormat = "%Y-%m-%d",
  outputFormat = "%Y"
)
dSharpe$facet( y = "metric")
dSharpe$templates$script = system.file(
  "libraries/dimple/layouts/chartFacet.html",
  package = "rCharts"
)
dSharpe