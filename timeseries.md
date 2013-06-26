---
title: rCharts, dimple, and time series
subtitle: Some Early Experiments
author: Timely Portfolio
github: {user: timelyportfolio, repo: rCharts_dimple, branch: "gh-pages"}
framework: bootstrap
mode: selfcontained
ext_widgets: {rCharts: "libraries/dimple"}
highlighter: prettify
hitheme: twitter-bootstrap
---



```r
require(quantmod)
require(rCharts)

xtsMelt <- function(data) {
  require(reshape2)
  
  #translate xts to time series to json with date and data
  #for this behavior will be more generic than the original
  #data will not be transformed, so template.rmd will be changed to reflect
  
  
  #convert to data frame
  data.df <- data.frame(cbind(format(index(data),"%Y-%m-%d"),coredata(data)))
  colnames(data.df)[1] = "date"
  data.melt <- melt(data.df,id.vars=1,stringsAsFactors=FALSE)
  colnames(data.melt) <- c("date","indexname","value")
  #remove periods from indexnames to prevent javascript confusion
  #these . usually come from spaces in the colnames when melted
  data.melt[,"indexname"] <- apply(matrix(data.melt[,"indexname"]),2,gsub,pattern="[.]",replacement="")
  return(data.melt)
  #return(df2json(na.omit(data.melt)))
}


#now get the US bonds from FRED
USbondssymbols <- paste0("DGS",c(1,2,3,5,7,10,20,30))

ust.xts <- xts()
for (i in 1:length( USbondssymbols ) ) {
  ust.xts <- merge( 
    ust.xts,
    getSymbols( 
      USbondssymbols[i], auto.assign = FALSE,src = "FRED"
    )
  )
}

ust.melt <- na.omit( xtsMelt( ust.xts["2012::",] ) )

ust.melt$date <- format(as.Date(ust.melt$date))
ust.melt$value <- as.numeric(ust.melt$value)
ust.melt$indexname <- factor(
  ust.melt$indexname, levels = colnames(ust.xts)
)
ust.melt$maturity <- as.numeric(
  substr(
    ust.melt$indexname, 4, length( ust.melt$indexname ) - 4
  )
)
ust.melt$country <- rep( "US", nrow( ust.melt ))

#simple line chart of 10 year
d1 <- dPlot(
  value ~ date,
  data = subset(ust.melt, maturity == 10),
  type = 'line'
)
d1$xAxis(orderRule = "date")
d1$print('chart1')
```


<div id='chart1' class='rChart dimple'></div>
<script type="text/javascript">
  var opts = {
 "dom": "chart1",
"width":    800,
"height":    400,
"x": "date",
"y": "value",
"type": "line",
"id": "chart1" 
},
    data = [
 {
 "date": "2012-01-02",
"indexname": "DGS10",
"value":   1.97,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-01-03",
"indexname": "DGS10",
"value":      2,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-01-04",
"indexname": "DGS10",
"value":   2.02,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-01-05",
"indexname": "DGS10",
"value":   1.98,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-01-08",
"indexname": "DGS10",
"value":   1.98,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-01-09",
"indexname": "DGS10",
"value":      2,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-01-10",
"indexname": "DGS10",
"value":   1.93,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-01-11",
"indexname": "DGS10",
"value":   1.94,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-01-12",
"indexname": "DGS10",
"value":   1.89,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-01-16",
"indexname": "DGS10",
"value":   1.87,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-01-17",
"indexname": "DGS10",
"value":   1.92,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-01-18",
"indexname": "DGS10",
"value":   2.01,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-01-19",
"indexname": "DGS10",
"value":   2.05,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-01-22",
"indexname": "DGS10",
"value":   2.09,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-01-23",
"indexname": "DGS10",
"value":   2.08,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-01-24",
"indexname": "DGS10",
"value":   2.01,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-01-25",
"indexname": "DGS10",
"value":   1.96,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-01-26",
"indexname": "DGS10",
"value":   1.93,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-01-29",
"indexname": "DGS10",
"value":   1.87,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-01-30",
"indexname": "DGS10",
"value":   1.83,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-01-31",
"indexname": "DGS10",
"value":   1.87,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-02-01",
"indexname": "DGS10",
"value":   1.86,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-02-02",
"indexname": "DGS10",
"value":   1.97,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-02-05",
"indexname": "DGS10",
"value":   1.93,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-02-06",
"indexname": "DGS10",
"value":      2,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-02-07",
"indexname": "DGS10",
"value":   2.01,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-02-08",
"indexname": "DGS10",
"value":   2.04,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-02-09",
"indexname": "DGS10",
"value":   1.96,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-02-12",
"indexname": "DGS10",
"value":   1.99,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-02-13",
"indexname": "DGS10",
"value":   1.92,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-02-14",
"indexname": "DGS10",
"value":   1.93,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-02-15",
"indexname": "DGS10",
"value":   1.99,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-02-16",
"indexname": "DGS10",
"value":   2.01,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-02-20",
"indexname": "DGS10",
"value":   2.05,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-02-21",
"indexname": "DGS10",
"value":   2.01,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-02-22",
"indexname": "DGS10",
"value":   1.99,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-02-23",
"indexname": "DGS10",
"value":   1.98,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-02-26",
"indexname": "DGS10",
"value":   1.92,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-02-27",
"indexname": "DGS10",
"value":   1.94,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-02-28",
"indexname": "DGS10",
"value":   1.98,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-02-29",
"indexname": "DGS10",
"value":   2.03,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-03-01",
"indexname": "DGS10",
"value":   1.99,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-03-04",
"indexname": "DGS10",
"value":      2,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-03-05",
"indexname": "DGS10",
"value":   1.96,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-03-06",
"indexname": "DGS10",
"value":   1.98,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-03-07",
"indexname": "DGS10",
"value":   2.03,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-03-08",
"indexname": "DGS10",
"value":   2.04,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-03-11",
"indexname": "DGS10",
"value":   2.04,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-03-12",
"indexname": "DGS10",
"value":   2.14,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-03-13",
"indexname": "DGS10",
"value":   2.29,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-03-14",
"indexname": "DGS10",
"value":   2.29,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-03-15",
"indexname": "DGS10",
"value":   2.31,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-03-18",
"indexname": "DGS10",
"value":   2.39,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-03-19",
"indexname": "DGS10",
"value":   2.38,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-03-20",
"indexname": "DGS10",
"value":   2.31,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-03-21",
"indexname": "DGS10",
"value":   2.29,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-03-22",
"indexname": "DGS10",
"value":   2.25,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-03-25",
"indexname": "DGS10",
"value":   2.26,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-03-26",
"indexname": "DGS10",
"value":    2.2,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-03-27",
"indexname": "DGS10",
"value":   2.21,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-03-28",
"indexname": "DGS10",
"value":   2.18,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-03-29",
"indexname": "DGS10",
"value":   2.23,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-04-01",
"indexname": "DGS10",
"value":   2.22,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-04-02",
"indexname": "DGS10",
"value":    2.3,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-04-03",
"indexname": "DGS10",
"value":   2.25,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-04-04",
"indexname": "DGS10",
"value":   2.19,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-04-05",
"indexname": "DGS10",
"value":   2.07,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-04-08",
"indexname": "DGS10",
"value":   2.06,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-04-09",
"indexname": "DGS10",
"value":   2.01,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-04-10",
"indexname": "DGS10",
"value":   2.05,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-04-11",
"indexname": "DGS10",
"value":   2.08,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-04-12",
"indexname": "DGS10",
"value":   2.02,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-04-15",
"indexname": "DGS10",
"value":      2,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-04-16",
"indexname": "DGS10",
"value":   2.03,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-04-17",
"indexname": "DGS10",
"value":      2,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-04-18",
"indexname": "DGS10",
"value":   1.98,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-04-19",
"indexname": "DGS10",
"value":   1.99,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-04-22",
"indexname": "DGS10",
"value":   1.96,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-04-23",
"indexname": "DGS10",
"value":      2,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-04-24",
"indexname": "DGS10",
"value":   2.01,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-04-25",
"indexname": "DGS10",
"value":   1.98,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-04-26",
"indexname": "DGS10",
"value":   1.96,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-04-29",
"indexname": "DGS10",
"value":   1.95,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-04-30",
"indexname": "DGS10",
"value":   1.98,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-05-01",
"indexname": "DGS10",
"value":   1.96,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-05-02",
"indexname": "DGS10",
"value":   1.96,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-05-03",
"indexname": "DGS10",
"value":   1.91,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-05-06",
"indexname": "DGS10",
"value":   1.92,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-05-07",
"indexname": "DGS10",
"value":   1.88,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-05-08",
"indexname": "DGS10",
"value":   1.87,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-05-09",
"indexname": "DGS10",
"value":   1.89,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-05-10",
"indexname": "DGS10",
"value":   1.84,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-05-13",
"indexname": "DGS10",
"value":   1.78,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-05-14",
"indexname": "DGS10",
"value":   1.76,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-05-15",
"indexname": "DGS10",
"value":   1.76,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-05-16",
"indexname": "DGS10",
"value":    1.7,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-05-17",
"indexname": "DGS10",
"value":   1.71,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-05-20",
"indexname": "DGS10",
"value":   1.75,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-05-21",
"indexname": "DGS10",
"value":   1.79,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-05-22",
"indexname": "DGS10",
"value":   1.73,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-05-23",
"indexname": "DGS10",
"value":   1.77,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-05-24",
"indexname": "DGS10",
"value":   1.75,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-05-28",
"indexname": "DGS10",
"value":   1.74,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-05-29",
"indexname": "DGS10",
"value":   1.63,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-05-30",
"indexname": "DGS10",
"value":   1.59,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-05-31",
"indexname": "DGS10",
"value":   1.47,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-06-03",
"indexname": "DGS10",
"value":   1.53,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-06-04",
"indexname": "DGS10",
"value":   1.57,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-06-05",
"indexname": "DGS10",
"value":   1.66,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-06-06",
"indexname": "DGS10",
"value":   1.66,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-06-07",
"indexname": "DGS10",
"value":   1.65,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-06-10",
"indexname": "DGS10",
"value":    1.6,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-06-11",
"indexname": "DGS10",
"value":   1.67,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-06-12",
"indexname": "DGS10",
"value":   1.61,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-06-13",
"indexname": "DGS10",
"value":   1.64,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-06-14",
"indexname": "DGS10",
"value":    1.6,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-06-17",
"indexname": "DGS10",
"value":   1.59,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-06-18",
"indexname": "DGS10",
"value":   1.64,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-06-19",
"indexname": "DGS10",
"value":   1.65,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-06-20",
"indexname": "DGS10",
"value":   1.63,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-06-21",
"indexname": "DGS10",
"value":   1.69,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-06-24",
"indexname": "DGS10",
"value":   1.63,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-06-25",
"indexname": "DGS10",
"value":   1.66,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-06-26",
"indexname": "DGS10",
"value":   1.65,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-06-27",
"indexname": "DGS10",
"value":    1.6,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-06-28",
"indexname": "DGS10",
"value":   1.67,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-07-01",
"indexname": "DGS10",
"value":   1.61,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-07-02",
"indexname": "DGS10",
"value":   1.65,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-07-04",
"indexname": "DGS10",
"value":   1.62,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-07-05",
"indexname": "DGS10",
"value":   1.57,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-07-08",
"indexname": "DGS10",
"value":   1.53,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-07-09",
"indexname": "DGS10",
"value":   1.53,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-07-10",
"indexname": "DGS10",
"value":   1.54,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-07-11",
"indexname": "DGS10",
"value":    1.5,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-07-12",
"indexname": "DGS10",
"value":   1.52,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-07-15",
"indexname": "DGS10",
"value":    1.5,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-07-16",
"indexname": "DGS10",
"value":   1.53,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-07-17",
"indexname": "DGS10",
"value":   1.52,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-07-18",
"indexname": "DGS10",
"value":   1.54,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-07-19",
"indexname": "DGS10",
"value":   1.49,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-07-22",
"indexname": "DGS10",
"value":   1.47,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-07-23",
"indexname": "DGS10",
"value":   1.44,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-07-24",
"indexname": "DGS10",
"value":   1.43,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-07-25",
"indexname": "DGS10",
"value":   1.45,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-07-26",
"indexname": "DGS10",
"value":   1.58,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-07-29",
"indexname": "DGS10",
"value":   1.53,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-07-30",
"indexname": "DGS10",
"value":   1.51,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-07-31",
"indexname": "DGS10",
"value":   1.56,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-08-01",
"indexname": "DGS10",
"value":   1.51,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-08-02",
"indexname": "DGS10",
"value":    1.6,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-08-05",
"indexname": "DGS10",
"value":   1.59,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-08-06",
"indexname": "DGS10",
"value":   1.66,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-08-07",
"indexname": "DGS10",
"value":   1.68,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-08-08",
"indexname": "DGS10",
"value":   1.69,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-08-09",
"indexname": "DGS10",
"value":   1.65,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-08-12",
"indexname": "DGS10",
"value":   1.65,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-08-13",
"indexname": "DGS10",
"value":   1.73,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-08-14",
"indexname": "DGS10",
"value":    1.8,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-08-15",
"indexname": "DGS10",
"value":   1.83,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-08-16",
"indexname": "DGS10",
"value":   1.81,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-08-19",
"indexname": "DGS10",
"value":   1.82,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-08-20",
"indexname": "DGS10",
"value":    1.8,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-08-21",
"indexname": "DGS10",
"value":   1.71,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-08-22",
"indexname": "DGS10",
"value":   1.68,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-08-23",
"indexname": "DGS10",
"value":   1.68,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-08-26",
"indexname": "DGS10",
"value":   1.65,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-08-27",
"indexname": "DGS10",
"value":   1.64,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-08-28",
"indexname": "DGS10",
"value":   1.66,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-08-29",
"indexname": "DGS10",
"value":   1.63,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-08-30",
"indexname": "DGS10",
"value":   1.57,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-09-03",
"indexname": "DGS10",
"value":   1.59,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-09-04",
"indexname": "DGS10",
"value":    1.6,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-09-05",
"indexname": "DGS10",
"value":   1.68,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-09-06",
"indexname": "DGS10",
"value":   1.67,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-09-09",
"indexname": "DGS10",
"value":   1.68,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-09-10",
"indexname": "DGS10",
"value":    1.7,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-09-11",
"indexname": "DGS10",
"value":   1.77,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-09-12",
"indexname": "DGS10",
"value":   1.75,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-09-13",
"indexname": "DGS10",
"value":   1.88,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-09-16",
"indexname": "DGS10",
"value":   1.85,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-09-17",
"indexname": "DGS10",
"value":   1.82,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-09-18",
"indexname": "DGS10",
"value":   1.79,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-09-19",
"indexname": "DGS10",
"value":    1.8,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-09-20",
"indexname": "DGS10",
"value":   1.77,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-09-23",
"indexname": "DGS10",
"value":   1.74,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-09-24",
"indexname": "DGS10",
"value":    1.7,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-09-25",
"indexname": "DGS10",
"value":   1.64,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-09-26",
"indexname": "DGS10",
"value":   1.66,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-09-27",
"indexname": "DGS10",
"value":   1.65,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-09-30",
"indexname": "DGS10",
"value":   1.64,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-10-01",
"indexname": "DGS10",
"value":   1.64,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-10-02",
"indexname": "DGS10",
"value":   1.64,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-10-03",
"indexname": "DGS10",
"value":    1.7,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-10-04",
"indexname": "DGS10",
"value":   1.75,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-10-08",
"indexname": "DGS10",
"value":   1.74,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-10-09",
"indexname": "DGS10",
"value":   1.72,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-10-10",
"indexname": "DGS10",
"value":    1.7,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-10-11",
"indexname": "DGS10",
"value":   1.69,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-10-14",
"indexname": "DGS10",
"value":    1.7,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-10-15",
"indexname": "DGS10",
"value":   1.75,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-10-16",
"indexname": "DGS10",
"value":   1.83,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-10-17",
"indexname": "DGS10",
"value":   1.86,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-10-18",
"indexname": "DGS10",
"value":   1.79,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-10-21",
"indexname": "DGS10",
"value":   1.83,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-10-22",
"indexname": "DGS10",
"value":   1.79,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-10-23",
"indexname": "DGS10",
"value":    1.8,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-10-24",
"indexname": "DGS10",
"value":   1.86,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-10-25",
"indexname": "DGS10",
"value":   1.78,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-10-28",
"indexname": "DGS10",
"value":   1.74,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-10-30",
"indexname": "DGS10",
"value":   1.72,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-10-31",
"indexname": "DGS10",
"value":   1.75,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-11-01",
"indexname": "DGS10",
"value":   1.75,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-11-04",
"indexname": "DGS10",
"value":   1.72,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-11-05",
"indexname": "DGS10",
"value":   1.78,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-11-06",
"indexname": "DGS10",
"value":   1.68,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-11-07",
"indexname": "DGS10",
"value":   1.62,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-11-08",
"indexname": "DGS10",
"value":   1.61,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-11-12",
"indexname": "DGS10",
"value":   1.59,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-11-13",
"indexname": "DGS10",
"value":   1.59,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-11-14",
"indexname": "DGS10",
"value":   1.58,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-11-15",
"indexname": "DGS10",
"value":   1.58,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-11-18",
"indexname": "DGS10",
"value":   1.61,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-11-19",
"indexname": "DGS10",
"value":   1.66,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-11-20",
"indexname": "DGS10",
"value":   1.69,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-11-22",
"indexname": "DGS10",
"value":    1.7,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-11-25",
"indexname": "DGS10",
"value":   1.66,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-11-26",
"indexname": "DGS10",
"value":   1.64,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-11-27",
"indexname": "DGS10",
"value":   1.63,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-11-28",
"indexname": "DGS10",
"value":   1.62,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-11-29",
"indexname": "DGS10",
"value":   1.62,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-12-02",
"indexname": "DGS10",
"value":   1.63,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-12-03",
"indexname": "DGS10",
"value":   1.62,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-12-04",
"indexname": "DGS10",
"value":    1.6,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-12-05",
"indexname": "DGS10",
"value":   1.59,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-12-06",
"indexname": "DGS10",
"value":   1.64,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-12-09",
"indexname": "DGS10",
"value":   1.63,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-12-10",
"indexname": "DGS10",
"value":   1.66,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-12-11",
"indexname": "DGS10",
"value":   1.72,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-12-12",
"indexname": "DGS10",
"value":   1.74,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-12-13",
"indexname": "DGS10",
"value":   1.72,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-12-16",
"indexname": "DGS10",
"value":   1.78,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-12-17",
"indexname": "DGS10",
"value":   1.84,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-12-18",
"indexname": "DGS10",
"value":   1.82,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-12-19",
"indexname": "DGS10",
"value":   1.81,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-12-20",
"indexname": "DGS10",
"value":   1.77,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-12-23",
"indexname": "DGS10",
"value":   1.79,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-12-25",
"indexname": "DGS10",
"value":   1.77,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-12-26",
"indexname": "DGS10",
"value":   1.74,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-12-27",
"indexname": "DGS10",
"value":   1.73,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-12-30",
"indexname": "DGS10",
"value":   1.78,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-01-01",
"indexname": "DGS10",
"value":   1.86,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-01-02",
"indexname": "DGS10",
"value":   1.92,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-01-03",
"indexname": "DGS10",
"value":   1.93,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-01-06",
"indexname": "DGS10",
"value":   1.92,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-01-07",
"indexname": "DGS10",
"value":   1.89,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-01-08",
"indexname": "DGS10",
"value":   1.88,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-01-09",
"indexname": "DGS10",
"value":   1.91,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-01-10",
"indexname": "DGS10",
"value":   1.89,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-01-13",
"indexname": "DGS10",
"value":   1.89,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-01-14",
"indexname": "DGS10",
"value":   1.86,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-01-15",
"indexname": "DGS10",
"value":   1.84,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-01-16",
"indexname": "DGS10",
"value":   1.89,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-01-17",
"indexname": "DGS10",
"value":   1.87,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-01-21",
"indexname": "DGS10",
"value":   1.86,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-01-22",
"indexname": "DGS10",
"value":   1.86,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-01-23",
"indexname": "DGS10",
"value":   1.88,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-01-24",
"indexname": "DGS10",
"value":   1.98,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-01-27",
"indexname": "DGS10",
"value":      2,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-01-28",
"indexname": "DGS10",
"value":   2.03,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-01-29",
"indexname": "DGS10",
"value":   2.03,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-01-30",
"indexname": "DGS10",
"value":   2.02,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-01-31",
"indexname": "DGS10",
"value":   2.04,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-02-03",
"indexname": "DGS10",
"value":      2,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-02-04",
"indexname": "DGS10",
"value":   2.04,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-02-05",
"indexname": "DGS10",
"value":      2,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-02-06",
"indexname": "DGS10",
"value":   1.99,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-02-07",
"indexname": "DGS10",
"value":   1.99,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-02-10",
"indexname": "DGS10",
"value":   1.99,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-02-11",
"indexname": "DGS10",
"value":   2.02,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-02-12",
"indexname": "DGS10",
"value":   2.05,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-02-13",
"indexname": "DGS10",
"value":      2,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-02-14",
"indexname": "DGS10",
"value":   2.01,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-02-18",
"indexname": "DGS10",
"value":   2.03,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-02-19",
"indexname": "DGS10",
"value":   2.02,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-02-20",
"indexname": "DGS10",
"value":   1.99,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-02-21",
"indexname": "DGS10",
"value":   1.97,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-02-24",
"indexname": "DGS10",
"value":   1.88,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-02-25",
"indexname": "DGS10",
"value":   1.88,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-02-26",
"indexname": "DGS10",
"value":   1.91,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-02-27",
"indexname": "DGS10",
"value":   1.89,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-02-28",
"indexname": "DGS10",
"value":   1.86,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-03-03",
"indexname": "DGS10",
"value":   1.88,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-03-04",
"indexname": "DGS10",
"value":    1.9,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-03-05",
"indexname": "DGS10",
"value":   1.95,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-03-06",
"indexname": "DGS10",
"value":      2,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-03-07",
"indexname": "DGS10",
"value":   2.06,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-03-10",
"indexname": "DGS10",
"value":   2.07,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-03-11",
"indexname": "DGS10",
"value":   2.03,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-03-12",
"indexname": "DGS10",
"value":   2.04,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-03-13",
"indexname": "DGS10",
"value":   2.04,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-03-14",
"indexname": "DGS10",
"value":   2.01,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-03-17",
"indexname": "DGS10",
"value":   1.96,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-03-18",
"indexname": "DGS10",
"value":   1.92,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-03-19",
"indexname": "DGS10",
"value":   1.96,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-03-20",
"indexname": "DGS10",
"value":   1.95,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-03-21",
"indexname": "DGS10",
"value":   1.93,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-03-24",
"indexname": "DGS10",
"value":   1.93,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-03-25",
"indexname": "DGS10",
"value":   1.92,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-03-26",
"indexname": "DGS10",
"value":   1.87,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-03-27",
"indexname": "DGS10",
"value":   1.87,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-03-31",
"indexname": "DGS10",
"value":   1.86,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-04-01",
"indexname": "DGS10",
"value":   1.88,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-04-02",
"indexname": "DGS10",
"value":   1.83,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-04-03",
"indexname": "DGS10",
"value":   1.78,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-04-04",
"indexname": "DGS10",
"value":   1.72,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-04-07",
"indexname": "DGS10",
"value":   1.76,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-04-08",
"indexname": "DGS10",
"value":   1.78,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-04-09",
"indexname": "DGS10",
"value":   1.84,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-04-10",
"indexname": "DGS10",
"value":   1.82,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-04-11",
"indexname": "DGS10",
"value":   1.75,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-04-14",
"indexname": "DGS10",
"value":   1.72,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-04-15",
"indexname": "DGS10",
"value":   1.75,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-04-16",
"indexname": "DGS10",
"value":   1.73,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-04-17",
"indexname": "DGS10",
"value":   1.72,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-04-18",
"indexname": "DGS10",
"value":   1.73,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-04-21",
"indexname": "DGS10",
"value":   1.72,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-04-22",
"indexname": "DGS10",
"value":   1.74,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-04-23",
"indexname": "DGS10",
"value":   1.73,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-04-24",
"indexname": "DGS10",
"value":   1.74,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-04-25",
"indexname": "DGS10",
"value":    1.7,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-04-28",
"indexname": "DGS10",
"value":    1.7,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-04-29",
"indexname": "DGS10",
"value":    1.7,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-04-30",
"indexname": "DGS10",
"value":   1.66,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-05-01",
"indexname": "DGS10",
"value":   1.66,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-05-02",
"indexname": "DGS10",
"value":   1.78,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-05-05",
"indexname": "DGS10",
"value":    1.8,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-05-06",
"indexname": "DGS10",
"value":   1.82,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-05-07",
"indexname": "DGS10",
"value":   1.81,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-05-08",
"indexname": "DGS10",
"value":   1.81,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-05-09",
"indexname": "DGS10",
"value":    1.9,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-05-12",
"indexname": "DGS10",
"value":   1.92,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-05-13",
"indexname": "DGS10",
"value":   1.96,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-05-14",
"indexname": "DGS10",
"value":   1.94,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-05-15",
"indexname": "DGS10",
"value":   1.87,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-05-16",
"indexname": "DGS10",
"value":   1.95,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-05-19",
"indexname": "DGS10",
"value":   1.97,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-05-20",
"indexname": "DGS10",
"value":   1.94,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-05-21",
"indexname": "DGS10",
"value":   2.03,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-05-22",
"indexname": "DGS10",
"value":   2.02,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-05-23",
"indexname": "DGS10",
"value":   2.01,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-05-27",
"indexname": "DGS10",
"value":   2.15,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-05-28",
"indexname": "DGS10",
"value":   2.13,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-05-29",
"indexname": "DGS10",
"value":   2.13,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-05-30",
"indexname": "DGS10",
"value":   2.16,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-06-02",
"indexname": "DGS10",
"value":   2.13,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-06-03",
"indexname": "DGS10",
"value":   2.14,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-06-04",
"indexname": "DGS10",
"value":    2.1,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-06-05",
"indexname": "DGS10",
"value":   2.08,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-06-06",
"indexname": "DGS10",
"value":   2.17,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-06-09",
"indexname": "DGS10",
"value":   2.22,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-06-10",
"indexname": "DGS10",
"value":    2.2,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-06-11",
"indexname": "DGS10",
"value":   2.25,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-06-12",
"indexname": "DGS10",
"value":   2.19,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-06-13",
"indexname": "DGS10",
"value":   2.14,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-06-16",
"indexname": "DGS10",
"value":   2.19,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-06-17",
"indexname": "DGS10",
"value":    2.2,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-06-18",
"indexname": "DGS10",
"value":   2.33,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-06-19",
"indexname": "DGS10",
"value":   2.41,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-06-20",
"indexname": "DGS10",
"value":   2.52,
"maturity":     10,
"country": "US" 
},
{
 "date": "2013-06-23",
"indexname": "DGS10",
"value":   2.57,
"maturity":     10,
"country": "US" 
} 
],
    xAxis = {
 "type": "addCategoryAxis",
"showPercent": false,
"orderRule": "date" 
},
    yAxis = {
 "type": "addMeasureAxis",
"showPercent": false 
},
    zAxis = [],
    legend = [];
  var svg = dimple.newSvg("#" + opts.id, opts.width, opts.height);

  //data = dimple.filterData(data, "Owner", ["Aperture", "Black Mesa"])
  var myChart = new dimple.chart(svg, data);
  if (opts.bounds) {
    myChart.setBounds(x = opts.bounds.x, y = opts.bounds.y, height = opts.bounds.height, width = opts.bounds.width);//myChart.setBounds(80, 30, 480, 330);
  }
  //dimple allows use of custom CSS with noFormats
  if(opts.noFormats) { myChart.noFormats = opts.noFormats; };
  //for markimekko and addAxis also have third parameter measure
  //so need to evaluate if measure provided
  //x axis
  var x;
  if(xAxis.measure) {
    x = myChart[xAxis.type]("x",opts.x,xAxis.measure);
  } else {
    x = myChart[xAxis.type]("x", opts.x);
  };
  if(!(xAxis.type === "addPctAxis")) x.showPercent = xAxis.showPercent;
  if (xAxis.orderRule) x.addOrderRule(xAxis.orderRule);
  if (xAxis.grouporderRule) x.addGroupOrderRule(xAxis.grouporderRule);  
  if (xAxis.overrideMin) x.overrideMin = xAxis.overrideMin;
  if (xAxis.overrideMax) x.overrideMax = xAxis.overrideMax;
  //y axis
  var y;
  if(yAxis.measure) {
    y = myChart[yAxis.type]("y",opts.y,yAxis.measure);
  } else {
    y = myChart[yAxis.type]("y", opts.y);
  };
  if(!(yAxis.type === "addPctAxis")) y.showPercent = yAxis.showPercent;
  if (yAxis.orderRule) y.addOrderRule(yAxis.orderRule);
  if (yAxis.grouporderRule) y.addGroupOrderRule(yAxis.grouporderRule);
  if (yAxis.overrideMin) y.overrideMin = yAxis.overrideMin;
  if (yAxis.overrideMax) y.overrideMax = yAxis.overrideMax;
  //z for bubbles
    var z;
  if (!(typeof(zAxis) === 'undefined') && zAxis.type){
    if(zAxis.measure) {
      z = myChart[zAxis.type]("z",opts.z,zAxis.measure);
    } else {
      z = myChart[zAxis.type]("z", opts.z);
    };
    if(!(zAxis.type === "addPctAxis")) z.showPercent = zAxis.showPercent;
    if (zAxis.orderRule) z.addOrderRule(zAxis.orderRule);
    if (zAxis.overrideMin) z.overrideMin = zAxis.overrideMin;
    if (zAxis.overrideMax) z.overrideMax = zAxis.overrideMax;
  }
  //here need think I need to evaluate group and if missing do null
  //as the first argument
  //if provided need to use groups from opts
  if(opts.hasOwnProperty("groups")) {
    var s = myChart.addSeries( opts.groups, dimple.plot[opts.type] );
    //series offers an aggregate method that we will also need to check if available
    //options available are avg, count, max, min, sum
    if (!(typeof(opts.aggregate) === 'undefined')) {
      s.aggregate = eval(opts.aggregate);
    }
    if (!(typeof(opts.lineWeight) === 'undefined')) {
      s.lineWeight = eval(opts.lineWeight);
    }
    if (!(typeof(opts.barGap) === 'undefined')) {
      s.barGap = eval(opts.barGap);
    }    
  } else var s = myChart.addSeries( null, dimple.plot[opts.type] );
  //unsure if this is best but if legend is provided (not empty) then evaluate
  if(d3.keys(legend).length > 0) {
    var l =myChart.addLegend();
    d3.keys(legend).forEach(function(d){
      l[d] = legend[d];
    });
  }
  //quick way to get this going but need to make this cleaner
  if(opts.storyboard) {
    myChart.setStoryboard(opts.storyboard);
  };
  myChart.draw();

</script>

<style>
body {
  font: 10px sans-serif;
  margin: 0;
}

path.line {
  fill: none;
  stroke: #666;
  stroke-width: 1.5px;
}

.axis {
  shape-rendering: crispEdges;
}

.x.axis line {
  stroke: #000;
}

.x.axis path {
  display: none;
}
</style>

<script>
//get Dates in d3 js format
data.forEach(function(d) {
  d.date = new Date(d.date);
  d.value = +d.value;
});
data.sort(function(a,b){return d3.ascending(a.date,b.date);})

//remove dimple axis
//hoping x is always drawn first
d3.select(".axis").remove()

//from Bostock example http://bl.ocks.org/mbostock/1166403

// Scales and axes. Note the inverted domain for the y-scale: bigger is up!
var xd3 = d3.time.scale().range([myChart.x, myChart.x + myChart.width]),
    yd3 = d3.scale.linear().range([myChart.y+myChart.height,myChart.y]),
    xAxisd3 = d3.svg.axis().scale(xd3).tickSize(4).tickSubdivide(true),
    yAxis = d3.svg.axis().scale(yd3).ticks(4).orient("right");

xd3.domain([data[0].date, data[data.length - 1].date]);
yd3.domain([0, d3.max(data, function(d) { return d.value; })]).nice();

svg.append("svg:g")
  .attr("class", "x axis")
  .attr("transform", "translate(0," + (+myChart.height+myChart.y) + ")")
  .call(xAxisd3);

/* A line generator, for the dark stroke.
var line = d3.svg.line()
    .interpolate("monotone")
    .x(function(d) { return xd3(d.date); })
    .y(function(d) { return yd3(d.value); });

 Add the y-axis.
  svg.append("svg:g")
      .attr("class", "y axis")
      .attr("transform", "translate(" + myChart.x + "," + (myChart.width + myChart.x) + ")")
      .call(yAxis);

 Add the line path.
svg.append("svg:path")
  .attr("class", "line")
  .attr("d", line(data))
  .style("stroke","gray");
*/
</script>



