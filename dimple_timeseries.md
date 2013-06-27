---
title: rCharts, dimple, and time series
author: Timely Portfolio
github: {user: timelyportfolio, repo: rCharts_dimple, branch: "gh-pages"}
framework: bootplus
layout: post
mode: selfcontained
ext_widgets: {rCharts: "libraries/dimple"}
highlighter: prettify
hitheme: twitter-bootstrap
lead : >
  dimplejs and rCharts Tutorial with US Treasury Yield Data
---

# rCharts Smiles With dimple

<style>
/*
path.line {
  fill: none;
  stroke: #666;
  stroke-width: 1.5px;
}
*/
.axis {
  shape-rendering: crispEdges;
}

.axis text {
  font: 10px sans-serif;
  margin: 0;
}

.x.axis line {
  stroke: #000;
}

.x.axis path {
  display: none;
}
</style>





Even this early in it release, [dimplejs](http://dimplejs.org) is such a powerful and promising [d3](http://d3js.org) library that we decided to quickly make it available in [rCharts](http://rcharts.io/site).  The first test was to recreate all (48) of the examples provided by [dimplejs](http://dimplejs.org/examples_index.html) with `rCharts`.  Once we [completed those](http://timelyportfolio.github.io/rCharts_dimple/gallery/), we felt fairly satisfied that we had good coverage of the `dimplejs` API (easily one of the best [documented](https://github.com/PMSI-AlignAlytics/dimple/wiki)).  We are aware of a couple missing items, but I really wanted to throw some real financial time series at it to see how well it might work in my real life as a portfolio manager.  If you are not familiar with `rCharts`, you might want to see this [Quickstart](http://ramnathv.github.io/rCharts/).

---
### Get the Data

Since bonds are a hot topic now, I thought some US Treasury Yield data from the St. Louis Federal Reserve (FRED) would make a nice subject.  I will start very basic and build up to a still simple but slightly more complicated plot.  As always, we first need data so we grab the data with `quantmod` `getSymbols()` and then merge it into one big `ust.xts` object.


```r
require(quantmod)
require(rCharts)
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
```

---
### Transform Our Data

Then we will define a little `xtsMelt` function to easily transform our wide `xts` data into long form.


```r
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
```


Now let's use our new `xtsMelt` function on our data.  You might notice that we use `na.omit` to remove the pesky NAs that sometimes haunt FRED data.


```r
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
```


---
### Our First Plot - A Single Line

Getting the data was fairly easy, now let's plot.  I hope you see how easy it is to get an interactive `dimplejs` chart from `R`.  Without my comments, the code would all fit nicely on one line.  We can even use a `r` formula to define our `x` and `y` as shown `value~date`.


```r
#simple line chart of 10 year
d1 <- dPlot(
  value ~ date,  #or x="date", y="value"
  #dimplejs allows filtering but will lessen data to write
  #if we subset in R
  data = subset(ust.melt,maturity==10),  #get all data for 10y maturity
  type = 'line'
)
d1
```

<div id ="chart1"></div>

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
},
{
 "date": "2013-06-24",
"indexname": "DGS10",
"value":    2.6,
"maturity":     10,
"country": "US" 
} 
],
    xAxis = {
 "type": "addCategoryAxis",
"showPercent": false 
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



---
### Fix the x axis

Uh oh, our x axis does not look too pretty.  However, `rCharts` is extensible and modular, so let's quickly jump to a little more advanced concept.  Currently `dimplejs` does not support dates on the x axis as well as I would like.  `dimplejs` is built on `d3`, so let's fix with a little [help](http://bl.ocks.org/mbostock/1166403) from the `d3` master [Mike Bostock](http://bost.ocks.org/mike/).  I built a custom [layout template](http://timelyportfolio.github.io/rCharts_dimple/assets/chart_d3dateaxis.html) to remove the `dimple` x-axis and replace with a `d3` version featuring much better date/time support.  To access it, we can set it with a little hack (I have a little inside information that this will soon become much easier).


```r
d2 <- d1
d2$field(
  'templates',
  modifyList(d2$templates, list(id = "chart2", script = 'http://timelyportfolio.github.io/rCharts_dimple/assets/chart_d3dateaxis.html') )
)
d2
```

<div id = "chart2"></div>

<div id='chart2' class='rChart dimple'></div>
<script type="text/javascript">
  var opts = {
 "dom": "chart2",
"width":    800,
"height":    400,
"x": "date",
"y": "value",
"type": "line",
"id": "chart2" 
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
},
{
 "date": "2013-06-24",
"indexname": "DGS10",
"value":    2.6,
"maturity":     10,
"country": "US" 
} 
],
    xAxis = {
 "type": "addCategoryAxis",
"showPercent": false 
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
<script>
//add this as a way to work around current lack of features for 
//times on x axis in dimple

//get Dates in d3 js format
data.forEach(function(d) {
  d.date = new Date(d.date);
  //d.value = +d.value;
});
//sort since order gets messed up
data.sort(function(a,b){return d3.ascending(a.date,b.date);})

//remove dimple axis
//hoping x is always drawn first
d3.select('#'+opts.id).select(".axis").remove()

//from Bostock example http://bl.ocks.org/mbostock/1166403

// Scales and axes. Note the inverted domain for the y-scale: bigger is up!
var xd3 = d3.time.scale().range([myChart.x, myChart.x + myChart.width]),
    yd3 = d3.scale.linear().range([myChart.y+myChart.height,myChart.y]),
    xAxisd3 = d3.svg.axis().scale(xd3).tickSize(4).tickSubdivide(true),
    yAxis = d3.svg.axis().scale(yd3).ticks(4).orient("right");

xd3.domain([data[0].date, data[data.length - 1].date]);
yd3.domain([0, d3.max(data, function(d) { return d.value; })]).nice();

var svg = d3.select('#'+opts.id).select('svg')
svg.append("g")
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


---
### Line Chart with all Maturities

Sorry for the little advanced topic.  The author of dimplejs says better date handling is on his TO-DO list.

Most portfolio managers/analysts will want more than just the US 10y.  Let's plot all the maturities with just one little `groups` addition in our `dPlot`.  I also anticipate that we will need a legend to identify our maturities by color so we will also add a legend.


```r
#simple line chart of all maturities
d3 <- dPlot(
  value ~ date,  #or x="date", y="value"
  groups = 'maturity',
  data = ust.melt,  #get all maturities so remove subset from above
  type = 'line'
)
d3$legend( x = 60, y = 10, width = 620, height = 20,
  horizontalAlign = "right")
d3$field(
  'templates',
  modifyList(d3$templates, list(id = "chart3", script = 'http://timelyportfolio.github.io/rCharts_dimple/assets/chart_d3dateaxis.html') )
)
d3
```

<div id ="chart3"></div>

<div id='chart3' class='rChart dimple'></div>
<script type="text/javascript">
  var opts = {
 "dom": "chart3",
"width":    800,
"height":    400,
"x": "date",
"y": "value",
"groups": "maturity",
"type": "line",
"id": "chart3" 
},
    data = [
 {
 "date": "2012-01-02",
"indexname": "DGS1",
"value":   0.12,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-01-03",
"indexname": "DGS1",
"value":   0.12,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-01-04",
"indexname": "DGS1",
"value":   0.11,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-01-05",
"indexname": "DGS1",
"value":   0.12,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-01-08",
"indexname": "DGS1",
"value":   0.11,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-01-09",
"indexname": "DGS1",
"value":   0.11,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-01-10",
"indexname": "DGS1",
"value":   0.11,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-01-11",
"indexname": "DGS1",
"value":   0.11,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-01-12",
"indexname": "DGS1",
"value":    0.1,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-01-16",
"indexname": "DGS1",
"value":   0.11,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-01-17",
"indexname": "DGS1",
"value":   0.11,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-01-18",
"indexname": "DGS1",
"value":   0.11,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-01-19",
"indexname": "DGS1",
"value":   0.11,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-01-22",
"indexname": "DGS1",
"value":   0.12,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-01-23",
"indexname": "DGS1",
"value":   0.12,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-01-24",
"indexname": "DGS1",
"value":   0.12,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-01-25",
"indexname": "DGS1",
"value":   0.12,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-01-26",
"indexname": "DGS1",
"value":   0.12,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-01-29",
"indexname": "DGS1",
"value":   0.12,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-01-30",
"indexname": "DGS1",
"value":   0.13,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-01-31",
"indexname": "DGS1",
"value":   0.13,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-02-01",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-02-02",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-02-05",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-02-06",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-02-07",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-02-08",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-02-09",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-02-12",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-02-13",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-02-14",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-02-15",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-02-16",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-02-20",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-02-21",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-02-22",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-02-23",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-02-26",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-02-27",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-02-28",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-02-29",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-03-01",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-03-04",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-03-05",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-03-06",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-03-07",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-03-08",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-03-11",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-03-12",
"indexname": "DGS1",
"value":    0.2,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-03-13",
"indexname": "DGS1",
"value":   0.21,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-03-14",
"indexname": "DGS1",
"value":   0.21,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-03-15",
"indexname": "DGS1",
"value":   0.21,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-03-18",
"indexname": "DGS1",
"value":   0.21,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-03-19",
"indexname": "DGS1",
"value":   0.22,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-03-20",
"indexname": "DGS1",
"value":   0.21,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-03-21",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-03-22",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-03-25",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-03-26",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-03-27",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-03-28",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-03-29",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-04-01",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-04-02",
"indexname": "DGS1",
"value":    0.2,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-04-03",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-04-04",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-04-05",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-04-08",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-04-09",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-04-10",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-04-11",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-04-12",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-04-15",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-04-16",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-04-17",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-04-18",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-04-19",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-04-22",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-04-23",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-04-24",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-04-25",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-04-26",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-04-29",
"indexname": "DGS1",
"value":    0.2,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-04-30",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-05-01",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-05-02",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-05-03",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-05-06",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-05-07",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-05-08",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-05-09",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-05-10",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-05-13",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-05-14",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-05-15",
"indexname": "DGS1",
"value":    0.2,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-05-16",
"indexname": "DGS1",
"value":    0.2,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-05-17",
"indexname": "DGS1",
"value":    0.2,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-05-20",
"indexname": "DGS1",
"value":   0.21,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-05-21",
"indexname": "DGS1",
"value":   0.21,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-05-22",
"indexname": "DGS1",
"value":    0.2,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-05-23",
"indexname": "DGS1",
"value":   0.21,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-05-24",
"indexname": "DGS1",
"value":    0.2,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-05-28",
"indexname": "DGS1",
"value":    0.2,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-05-29",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-05-30",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-05-31",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-06-03",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-06-04",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-06-05",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-06-06",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-06-07",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-06-10",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-06-11",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-06-12",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-06-13",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-06-14",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-06-17",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-06-18",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-06-19",
"indexname": "DGS1",
"value":    0.2,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-06-20",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-06-21",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-06-24",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-06-25",
"indexname": "DGS1",
"value":   0.21,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-06-26",
"indexname": "DGS1",
"value":   0.21,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-06-27",
"indexname": "DGS1",
"value":   0.22,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-06-28",
"indexname": "DGS1",
"value":   0.21,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-07-01",
"indexname": "DGS1",
"value":   0.21,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-07-02",
"indexname": "DGS1",
"value":   0.21,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-07-04",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-07-05",
"indexname": "DGS1",
"value":    0.2,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-07-08",
"indexname": "DGS1",
"value":    0.2,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-07-09",
"indexname": "DGS1",
"value":    0.2,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-07-10",
"indexname": "DGS1",
"value":    0.2,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-07-11",
"indexname": "DGS1",
"value":    0.2,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-07-12",
"indexname": "DGS1",
"value":    0.2,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-07-15",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-07-16",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-07-17",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-07-18",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-07-19",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-07-22",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-07-23",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-07-24",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-07-25",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-07-26",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-07-29",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-07-30",
"indexname": "DGS1",
"value":   0.16,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-07-31",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-08-01",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-08-02",
"indexname": "DGS1",
"value":   0.16,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-08-05",
"indexname": "DGS1",
"value":   0.16,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-08-06",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-08-07",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-08-08",
"indexname": "DGS1",
"value":    0.2,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-08-09",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-08-12",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-08-13",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-08-14",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-08-15",
"indexname": "DGS1",
"value":    0.2,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-08-16",
"indexname": "DGS1",
"value":    0.2,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-08-19",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-08-20",
"indexname": "DGS1",
"value":    0.2,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-08-21",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-08-22",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-08-23",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-08-26",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-08-27",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-08-28",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-08-29",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-08-30",
"indexname": "DGS1",
"value":   0.16,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-09-03",
"indexname": "DGS1",
"value":   0.16,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-09-04",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-09-05",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-09-06",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-09-09",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-09-10",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-09-11",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-09-12",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-09-13",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-09-16",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-09-17",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-09-18",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-09-19",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-09-20",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-09-23",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-09-24",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-09-25",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-09-26",
"indexname": "DGS1",
"value":   0.16,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-09-27",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-09-30",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-10-01",
"indexname": "DGS1",
"value":   0.16,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-10-02",
"indexname": "DGS1",
"value":   0.16,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-10-03",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-10-04",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-10-08",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-10-09",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-10-10",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-10-11",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-10-14",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-10-15",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-10-16",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-10-17",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-10-18",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-10-21",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-10-22",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-10-23",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-10-24",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-10-25",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-10-28",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-10-30",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-10-31",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-11-01",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-11-04",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-11-05",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-11-06",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-11-07",
"indexname": "DGS1",
"value":    0.2,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-11-08",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-11-12",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-11-13",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-11-14",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-11-15",
"indexname": "DGS1",
"value":   0.16,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-11-18",
"indexname": "DGS1",
"value":   0.16,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-11-19",
"indexname": "DGS1",
"value":   0.16,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-11-20",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-11-22",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-11-25",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-11-26",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-11-27",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-11-28",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-11-29",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-12-02",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-12-03",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-12-04",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-12-05",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-12-06",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-12-09",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-12-10",
"indexname": "DGS1",
"value":   0.16,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-12-11",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-12-12",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-12-13",
"indexname": "DGS1",
"value":   0.13,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-12-16",
"indexname": "DGS1",
"value":   0.13,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-12-17",
"indexname": "DGS1",
"value":   0.16,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-12-18",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-12-19",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-12-20",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-12-23",
"indexname": "DGS1",
"value":   0.16,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-12-25",
"indexname": "DGS1",
"value":   0.16,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-12-26",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-12-27",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-12-30",
"indexname": "DGS1",
"value":   0.16,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-01-01",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-01-02",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-01-03",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-01-06",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-01-07",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-01-08",
"indexname": "DGS1",
"value":   0.13,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-01-09",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-01-10",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-01-13",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-01-14",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-01-15",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-01-16",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-01-17",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-01-21",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-01-22",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-01-23",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-01-24",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-01-27",
"indexname": "DGS1",
"value":   0.16,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-01-28",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-01-29",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-01-30",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-01-31",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-02-03",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-02-04",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-02-05",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-02-06",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-02-07",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-02-10",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-02-11",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-02-12",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-02-13",
"indexname": "DGS1",
"value":   0.16,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-02-14",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-02-18",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-02-19",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-02-20",
"indexname": "DGS1",
"value":   0.16,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-02-21",
"indexname": "DGS1",
"value":   0.16,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-02-24",
"indexname": "DGS1",
"value":   0.16,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-02-25",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-02-26",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-02-27",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-02-28",
"indexname": "DGS1",
"value":   0.16,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-03-03",
"indexname": "DGS1",
"value":   0.16,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-03-04",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-03-05",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-03-06",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-03-07",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-03-10",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-03-11",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-03-12",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-03-13",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-03-14",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-03-17",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-03-18",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-03-19",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-03-20",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-03-21",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-03-24",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-03-25",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-03-26",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-03-27",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-03-31",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-04-01",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-04-02",
"indexname": "DGS1",
"value":   0.13,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-04-03",
"indexname": "DGS1",
"value":   0.13,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-04-04",
"indexname": "DGS1",
"value":   0.13,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-04-07",
"indexname": "DGS1",
"value":   0.13,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-04-08",
"indexname": "DGS1",
"value":   0.13,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-04-09",
"indexname": "DGS1",
"value":   0.12,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-04-10",
"indexname": "DGS1",
"value":   0.12,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-04-11",
"indexname": "DGS1",
"value":   0.11,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-04-14",
"indexname": "DGS1",
"value":   0.12,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-04-15",
"indexname": "DGS1",
"value":   0.13,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-04-16",
"indexname": "DGS1",
"value":   0.13,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-04-17",
"indexname": "DGS1",
"value":   0.12,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-04-18",
"indexname": "DGS1",
"value":   0.12,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-04-21",
"indexname": "DGS1",
"value":   0.12,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-04-22",
"indexname": "DGS1",
"value":   0.12,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-04-23",
"indexname": "DGS1",
"value":   0.13,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-04-24",
"indexname": "DGS1",
"value":   0.12,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-04-25",
"indexname": "DGS1",
"value":   0.12,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-04-28",
"indexname": "DGS1",
"value":   0.12,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-04-29",
"indexname": "DGS1",
"value":   0.11,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-04-30",
"indexname": "DGS1",
"value":   0.11,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-05-01",
"indexname": "DGS1",
"value":   0.11,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-05-02",
"indexname": "DGS1",
"value":   0.11,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-05-05",
"indexname": "DGS1",
"value":   0.11,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-05-06",
"indexname": "DGS1",
"value":    0.1,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-05-07",
"indexname": "DGS1",
"value":   0.11,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-05-08",
"indexname": "DGS1",
"value":   0.11,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-05-09",
"indexname": "DGS1",
"value":   0.11,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-05-12",
"indexname": "DGS1",
"value":   0.13,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-05-13",
"indexname": "DGS1",
"value":   0.12,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-05-14",
"indexname": "DGS1",
"value":   0.12,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-05-15",
"indexname": "DGS1",
"value":   0.12,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-05-16",
"indexname": "DGS1",
"value":   0.12,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-05-19",
"indexname": "DGS1",
"value":   0.12,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-05-20",
"indexname": "DGS1",
"value":   0.12,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-05-21",
"indexname": "DGS1",
"value":   0.11,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-05-22",
"indexname": "DGS1",
"value":   0.12,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-05-23",
"indexname": "DGS1",
"value":   0.12,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-05-27",
"indexname": "DGS1",
"value":   0.13,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-05-28",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-05-29",
"indexname": "DGS1",
"value":   0.13,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-05-30",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-06-02",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-06-03",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-06-04",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-06-05",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-06-06",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-06-09",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-06-10",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-06-11",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-06-12",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-06-13",
"indexname": "DGS1",
"value":   0.13,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-06-16",
"indexname": "DGS1",
"value":   0.13,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-06-17",
"indexname": "DGS1",
"value":   0.13,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-06-18",
"indexname": "DGS1",
"value":   0.13,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-06-19",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-06-20",
"indexname": "DGS1",
"value":   0.13,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-06-23",
"indexname": "DGS1",
"value":   0.16,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-06-24",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-01-02",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-01-03",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-01-04",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-01-05",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-01-08",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-01-09",
"indexname": "DGS2",
"value":   0.24,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-01-10",
"indexname": "DGS2",
"value":   0.24,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-01-11",
"indexname": "DGS2",
"value":   0.22,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-01-12",
"indexname": "DGS2",
"value":   0.24,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-01-16",
"indexname": "DGS2",
"value":   0.21,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-01-17",
"indexname": "DGS2",
"value":   0.24,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-01-18",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-01-19",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-01-22",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-01-23",
"indexname": "DGS2",
"value":   0.24,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-01-24",
"indexname": "DGS2",
"value":   0.22,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-01-25",
"indexname": "DGS2",
"value":   0.22,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-01-26",
"indexname": "DGS2",
"value":   0.22,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-01-29",
"indexname": "DGS2",
"value":   0.22,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-01-30",
"indexname": "DGS2",
"value":   0.22,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-01-31",
"indexname": "DGS2",
"value":   0.23,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-02-01",
"indexname": "DGS2",
"value":   0.23,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-02-02",
"indexname": "DGS2",
"value":   0.23,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-02-05",
"indexname": "DGS2",
"value":   0.24,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-02-06",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-02-07",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-02-08",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-02-09",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-02-12",
"indexname": "DGS2",
"value":   0.29,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-02-13",
"indexname": "DGS2",
"value":   0.29,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-02-14",
"indexname": "DGS2",
"value":   0.29,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-02-15",
"indexname": "DGS2",
"value":   0.29,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-02-16",
"indexname": "DGS2",
"value":   0.29,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-02-20",
"indexname": "DGS2",
"value":   0.31,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-02-21",
"indexname": "DGS2",
"value":   0.29,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-02-22",
"indexname": "DGS2",
"value":   0.31,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-02-23",
"indexname": "DGS2",
"value":   0.31,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-02-26",
"indexname": "DGS2",
"value":    0.3,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-02-27",
"indexname": "DGS2",
"value":    0.3,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-02-28",
"indexname": "DGS2",
"value":    0.3,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-02-29",
"indexname": "DGS2",
"value":    0.3,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-03-01",
"indexname": "DGS2",
"value":   0.28,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-03-04",
"indexname": "DGS2",
"value":   0.31,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-03-05",
"indexname": "DGS2",
"value":    0.3,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-03-06",
"indexname": "DGS2",
"value":    0.3,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-03-07",
"indexname": "DGS2",
"value":   0.32,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-03-08",
"indexname": "DGS2",
"value":   0.33,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-03-11",
"indexname": "DGS2",
"value":   0.33,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-03-12",
"indexname": "DGS2",
"value":   0.35,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-03-13",
"indexname": "DGS2",
"value":    0.4,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-03-14",
"indexname": "DGS2",
"value":   0.37,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-03-15",
"indexname": "DGS2",
"value":   0.37,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-03-18",
"indexname": "DGS2",
"value":   0.39,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-03-19",
"indexname": "DGS2",
"value":   0.41,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-03-20",
"indexname": "DGS2",
"value":   0.39,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-03-21",
"indexname": "DGS2",
"value":   0.37,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-03-22",
"indexname": "DGS2",
"value":   0.37,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-03-25",
"indexname": "DGS2",
"value":   0.36,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-03-26",
"indexname": "DGS2",
"value":   0.33,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-03-27",
"indexname": "DGS2",
"value":   0.34,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-03-28",
"indexname": "DGS2",
"value":   0.33,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-03-29",
"indexname": "DGS2",
"value":   0.33,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-04-01",
"indexname": "DGS2",
"value":   0.33,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-04-02",
"indexname": "DGS2",
"value":   0.36,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-04-03",
"indexname": "DGS2",
"value":   0.35,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-04-04",
"indexname": "DGS2",
"value":   0.35,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-04-05",
"indexname": "DGS2",
"value":   0.32,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-04-08",
"indexname": "DGS2",
"value":   0.32,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-04-09",
"indexname": "DGS2",
"value":   0.28,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-04-10",
"indexname": "DGS2",
"value":    0.3,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-04-11",
"indexname": "DGS2",
"value":   0.29,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-04-12",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-04-15",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-04-16",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-04-17",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-04-18",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-04-19",
"indexname": "DGS2",
"value":   0.29,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-04-22",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-04-23",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-04-24",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-04-25",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-04-26",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-04-29",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-04-30",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-05-01",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-05-02",
"indexname": "DGS2",
"value":   0.28,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-05-03",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-05-06",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-05-07",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-05-08",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-05-09",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-05-10",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-05-13",
"indexname": "DGS2",
"value":   0.29,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-05-14",
"indexname": "DGS2",
"value":   0.29,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-05-15",
"indexname": "DGS2",
"value":    0.3,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-05-16",
"indexname": "DGS2",
"value":   0.32,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-05-17",
"indexname": "DGS2",
"value":   0.32,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-05-20",
"indexname": "DGS2",
"value":    0.3,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-05-21",
"indexname": "DGS2",
"value":    0.3,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-05-22",
"indexname": "DGS2",
"value":   0.28,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-05-23",
"indexname": "DGS2",
"value":   0.29,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-05-24",
"indexname": "DGS2",
"value":    0.3,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-05-28",
"indexname": "DGS2",
"value":    0.3,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-05-29",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-05-30",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-05-31",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-06-03",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-06-04",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-06-05",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-06-06",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-06-07",
"indexname": "DGS2",
"value":   0.28,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-06-10",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-06-11",
"indexname": "DGS2",
"value":    0.3,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-06-12",
"indexname": "DGS2",
"value":    0.3,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-06-13",
"indexname": "DGS2",
"value":    0.3,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-06-14",
"indexname": "DGS2",
"value":   0.29,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-06-17",
"indexname": "DGS2",
"value":   0.29,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-06-18",
"indexname": "DGS2",
"value":    0.3,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-06-19",
"indexname": "DGS2",
"value":   0.32,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-06-20",
"indexname": "DGS2",
"value":   0.32,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-06-21",
"indexname": "DGS2",
"value":   0.31,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-06-24",
"indexname": "DGS2",
"value":   0.31,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-06-25",
"indexname": "DGS2",
"value":   0.31,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-06-26",
"indexname": "DGS2",
"value":   0.31,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-06-27",
"indexname": "DGS2",
"value":   0.31,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-06-28",
"indexname": "DGS2",
"value":   0.33,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-07-01",
"indexname": "DGS2",
"value":    0.3,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-07-02",
"indexname": "DGS2",
"value":    0.3,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-07-04",
"indexname": "DGS2",
"value":   0.28,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-07-05",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-07-08",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-07-09",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-07-10",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-07-11",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-07-12",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-07-15",
"indexname": "DGS2",
"value":   0.24,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-07-16",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-07-17",
"indexname": "DGS2",
"value":   0.22,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-07-18",
"indexname": "DGS2",
"value":   0.22,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-07-19",
"indexname": "DGS2",
"value":   0.22,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-07-22",
"indexname": "DGS2",
"value":   0.22,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-07-23",
"indexname": "DGS2",
"value":   0.22,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-07-24",
"indexname": "DGS2",
"value":   0.22,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-07-25",
"indexname": "DGS2",
"value":   0.23,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-07-26",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-07-29",
"indexname": "DGS2",
"value":   0.23,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-07-30",
"indexname": "DGS2",
"value":   0.23,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-07-31",
"indexname": "DGS2",
"value":   0.24,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-08-01",
"indexname": "DGS2",
"value":   0.24,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-08-02",
"indexname": "DGS2",
"value":   0.24,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-08-05",
"indexname": "DGS2",
"value":   0.24,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-08-06",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-08-07",
"indexname": "DGS2",
"value":   0.29,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-08-08",
"indexname": "DGS2",
"value":   0.29,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-08-09",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-08-12",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-08-13",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-08-14",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-08-15",
"indexname": "DGS2",
"value":   0.29,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-08-16",
"indexname": "DGS2",
"value":   0.29,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-08-19",
"indexname": "DGS2",
"value":   0.29,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-08-20",
"indexname": "DGS2",
"value":   0.31,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-08-21",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-08-22",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-08-23",
"indexname": "DGS2",
"value":   0.28,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-08-26",
"indexname": "DGS2",
"value":   0.28,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-08-27",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-08-28",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-08-29",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-08-30",
"indexname": "DGS2",
"value":   0.22,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-09-03",
"indexname": "DGS2",
"value":   0.23,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-09-04",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-09-05",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-09-06",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-09-09",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-09-10",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-09-11",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-09-12",
"indexname": "DGS2",
"value":   0.24,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-09-13",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-09-16",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-09-17",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-09-18",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-09-19",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-09-20",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-09-23",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-09-24",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-09-25",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-09-26",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-09-27",
"indexname": "DGS2",
"value":   0.23,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-09-30",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-10-01",
"indexname": "DGS2",
"value":   0.23,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-10-02",
"indexname": "DGS2",
"value":   0.23,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-10-03",
"indexname": "DGS2",
"value":   0.23,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-10-04",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-10-08",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-10-09",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-10-10",
"indexname": "DGS2",
"value":   0.28,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-10-11",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-10-14",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-10-15",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-10-16",
"indexname": "DGS2",
"value":    0.3,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-10-17",
"indexname": "DGS2",
"value":   0.29,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-10-18",
"indexname": "DGS2",
"value":    0.3,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-10-21",
"indexname": "DGS2",
"value":   0.32,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-10-22",
"indexname": "DGS2",
"value":   0.29,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-10-23",
"indexname": "DGS2",
"value":   0.29,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-10-24",
"indexname": "DGS2",
"value":   0.31,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-10-25",
"indexname": "DGS2",
"value":    0.3,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-10-28",
"indexname": "DGS2",
"value":    0.3,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-10-30",
"indexname": "DGS2",
"value":    0.3,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-10-31",
"indexname": "DGS2",
"value":    0.3,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-11-01",
"indexname": "DGS2",
"value":   0.28,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-11-04",
"indexname": "DGS2",
"value":   0.28,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-11-05",
"indexname": "DGS2",
"value":    0.3,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-11-06",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-11-07",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-11-08",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-11-12",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-11-13",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-11-14",
"indexname": "DGS2",
"value":   0.24,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-11-15",
"indexname": "DGS2",
"value":   0.24,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-11-18",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-11-19",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-11-20",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-11-22",
"indexname": "DGS2",
"value":   0.29,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-11-25",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-11-26",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-11-27",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-11-28",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-11-29",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-12-02",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-12-03",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-12-04",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-12-05",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-12-06",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-12-09",
"indexname": "DGS2",
"value":   0.24,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-12-10",
"indexname": "DGS2",
"value":   0.24,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-12-11",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-12-12",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-12-13",
"indexname": "DGS2",
"value":   0.24,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-12-16",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-12-17",
"indexname": "DGS2",
"value":   0.28,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-12-18",
"indexname": "DGS2",
"value":   0.28,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-12-19",
"indexname": "DGS2",
"value":   0.28,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-12-20",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-12-23",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-12-25",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-12-26",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-12-27",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-12-30",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-01-01",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-01-02",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-01-03",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-01-06",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-01-07",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-01-08",
"indexname": "DGS2",
"value":   0.24,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-01-09",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-01-10",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-01-13",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-01-14",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-01-15",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-01-16",
"indexname": "DGS2",
"value":   0.28,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-01-17",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-01-21",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-01-22",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-01-23",
"indexname": "DGS2",
"value":   0.23,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-01-24",
"indexname": "DGS2",
"value":   0.28,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-01-27",
"indexname": "DGS2",
"value":   0.29,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-01-28",
"indexname": "DGS2",
"value":    0.3,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-01-29",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-01-30",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-01-31",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-02-03",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-02-04",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-02-05",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-02-06",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-02-07",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-02-10",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-02-11",
"indexname": "DGS2",
"value":   0.29,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-02-12",
"indexname": "DGS2",
"value":   0.29,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-02-13",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-02-14",
"indexname": "DGS2",
"value":   0.29,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-02-18",
"indexname": "DGS2",
"value":   0.29,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-02-19",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-02-20",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-02-21",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-02-24",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-02-25",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-02-26",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-02-27",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-02-28",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-03-03",
"indexname": "DGS2",
"value":   0.24,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-03-04",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-03-05",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-03-06",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-03-07",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-03-10",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-03-11",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-03-12",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-03-13",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-03-14",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-03-17",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-03-18",
"indexname": "DGS2",
"value":   0.24,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-03-19",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-03-20",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-03-21",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-03-24",
"indexname": "DGS2",
"value":   0.24,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-03-25",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-03-26",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-03-27",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-03-31",
"indexname": "DGS2",
"value":   0.23,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-04-01",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-04-02",
"indexname": "DGS2",
"value":   0.24,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-04-03",
"indexname": "DGS2",
"value":   0.22,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-04-04",
"indexname": "DGS2",
"value":   0.24,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-04-07",
"indexname": "DGS2",
"value":   0.24,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-04-08",
"indexname": "DGS2",
"value":   0.24,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-04-09",
"indexname": "DGS2",
"value":   0.24,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-04-10",
"indexname": "DGS2",
"value":   0.24,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-04-11",
"indexname": "DGS2",
"value":   0.22,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-04-14",
"indexname": "DGS2",
"value":   0.22,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-04-15",
"indexname": "DGS2",
"value":   0.24,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-04-16",
"indexname": "DGS2",
"value":   0.24,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-04-17",
"indexname": "DGS2",
"value":   0.24,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-04-18",
"indexname": "DGS2",
"value":   0.24,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-04-21",
"indexname": "DGS2",
"value":   0.24,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-04-22",
"indexname": "DGS2",
"value":   0.23,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-04-23",
"indexname": "DGS2",
"value":   0.23,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-04-24",
"indexname": "DGS2",
"value":   0.23,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-04-25",
"indexname": "DGS2",
"value":   0.22,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-04-28",
"indexname": "DGS2",
"value":    0.2,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-04-29",
"indexname": "DGS2",
"value":   0.22,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-04-30",
"indexname": "DGS2",
"value":    0.2,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-05-01",
"indexname": "DGS2",
"value":    0.2,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-05-02",
"indexname": "DGS2",
"value":   0.22,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-05-05",
"indexname": "DGS2",
"value":   0.22,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-05-06",
"indexname": "DGS2",
"value":   0.22,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-05-07",
"indexname": "DGS2",
"value":   0.22,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-05-08",
"indexname": "DGS2",
"value":   0.22,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-05-09",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-05-12",
"indexname": "DGS2",
"value":   0.24,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-05-13",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-05-14",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-05-15",
"indexname": "DGS2",
"value":   0.23,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-05-16",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-05-19",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-05-20",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-05-21",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-05-22",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-05-23",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-05-27",
"indexname": "DGS2",
"value":   0.29,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-05-28",
"indexname": "DGS2",
"value":    0.3,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-05-29",
"indexname": "DGS2",
"value":   0.31,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-05-30",
"indexname": "DGS2",
"value":    0.3,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-06-02",
"indexname": "DGS2",
"value":    0.3,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-06-03",
"indexname": "DGS2",
"value":   0.32,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-06-04",
"indexname": "DGS2",
"value":    0.3,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-06-05",
"indexname": "DGS2",
"value":    0.3,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-06-06",
"indexname": "DGS2",
"value":   0.32,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-06-09",
"indexname": "DGS2",
"value":   0.32,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-06-10",
"indexname": "DGS2",
"value":   0.34,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-06-11",
"indexname": "DGS2",
"value":   0.34,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-06-12",
"indexname": "DGS2",
"value":   0.32,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-06-13",
"indexname": "DGS2",
"value":   0.29,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-06-16",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-06-17",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-06-18",
"indexname": "DGS2",
"value":   0.31,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-06-19",
"indexname": "DGS2",
"value":   0.33,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-06-20",
"indexname": "DGS2",
"value":   0.38,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-06-23",
"indexname": "DGS2",
"value":   0.42,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-06-24",
"indexname": "DGS2",
"value":   0.43,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-01-02",
"indexname": "DGS3",
"value":    0.4,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-01-03",
"indexname": "DGS3",
"value":    0.4,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-01-04",
"indexname": "DGS3",
"value":    0.4,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-01-05",
"indexname": "DGS3",
"value":    0.4,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-01-08",
"indexname": "DGS3",
"value":   0.38,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-01-09",
"indexname": "DGS3",
"value":   0.37,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-01-10",
"indexname": "DGS3",
"value":   0.34,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-01-11",
"indexname": "DGS3",
"value":   0.35,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-01-12",
"indexname": "DGS3",
"value":   0.34,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-01-16",
"indexname": "DGS3",
"value":   0.33,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-01-17",
"indexname": "DGS3",
"value":   0.35,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-01-18",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-01-19",
"indexname": "DGS3",
"value":   0.38,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-01-22",
"indexname": "DGS3",
"value":   0.39,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-01-23",
"indexname": "DGS3",
"value":   0.39,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-01-24",
"indexname": "DGS3",
"value":   0.34,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-01-25",
"indexname": "DGS3",
"value":   0.31,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-01-26",
"indexname": "DGS3",
"value":   0.32,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-01-29",
"indexname": "DGS3",
"value":   0.31,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-01-30",
"indexname": "DGS3",
"value":    0.3,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-01-31",
"indexname": "DGS3",
"value":   0.31,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-02-01",
"indexname": "DGS3",
"value":   0.31,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-02-02",
"indexname": "DGS3",
"value":   0.33,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-02-05",
"indexname": "DGS3",
"value":   0.32,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-02-06",
"indexname": "DGS3",
"value":   0.35,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-02-07",
"indexname": "DGS3",
"value":   0.35,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-02-08",
"indexname": "DGS3",
"value":   0.38,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-02-09",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-02-12",
"indexname": "DGS3",
"value":    0.4,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-02-13",
"indexname": "DGS3",
"value":    0.4,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-02-14",
"indexname": "DGS3",
"value":   0.38,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-02-15",
"indexname": "DGS3",
"value":   0.42,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-02-16",
"indexname": "DGS3",
"value":   0.42,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-02-20",
"indexname": "DGS3",
"value":   0.44,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-02-21",
"indexname": "DGS3",
"value":   0.42,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-02-22",
"indexname": "DGS3",
"value":   0.43,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-02-23",
"indexname": "DGS3",
"value":   0.43,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-02-26",
"indexname": "DGS3",
"value":    0.4,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-02-27",
"indexname": "DGS3",
"value":   0.41,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-02-28",
"indexname": "DGS3",
"value":   0.43,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-02-29",
"indexname": "DGS3",
"value":   0.43,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-03-01",
"indexname": "DGS3",
"value":   0.41,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-03-04",
"indexname": "DGS3",
"value":   0.43,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-03-05",
"indexname": "DGS3",
"value":    0.4,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-03-06",
"indexname": "DGS3",
"value":   0.42,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-03-07",
"indexname": "DGS3",
"value":   0.44,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-03-08",
"indexname": "DGS3",
"value":   0.46,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-03-11",
"indexname": "DGS3",
"value":   0.47,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-03-12",
"indexname": "DGS3",
"value":   0.51,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-03-13",
"indexname": "DGS3",
"value":    0.6,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-03-14",
"indexname": "DGS3",
"value":   0.56,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-03-15",
"indexname": "DGS3",
"value":   0.57,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-03-18",
"indexname": "DGS3",
"value":    0.6,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-03-19",
"indexname": "DGS3",
"value":   0.62,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-03-20",
"indexname": "DGS3",
"value":   0.58,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-03-21",
"indexname": "DGS3",
"value":   0.56,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-03-22",
"indexname": "DGS3",
"value":   0.55,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-03-25",
"indexname": "DGS3",
"value":   0.54,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-03-26",
"indexname": "DGS3",
"value":    0.5,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-03-27",
"indexname": "DGS3",
"value":   0.51,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-03-28",
"indexname": "DGS3",
"value":    0.5,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-03-29",
"indexname": "DGS3",
"value":   0.51,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-04-01",
"indexname": "DGS3",
"value":    0.5,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-04-02",
"indexname": "DGS3",
"value":   0.56,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-04-03",
"indexname": "DGS3",
"value":   0.53,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-04-04",
"indexname": "DGS3",
"value":    0.5,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-04-05",
"indexname": "DGS3",
"value":   0.45,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-04-08",
"indexname": "DGS3",
"value":   0.46,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-04-09",
"indexname": "DGS3",
"value":   0.42,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-04-10",
"indexname": "DGS3",
"value":   0.43,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-04-11",
"indexname": "DGS3",
"value":   0.43,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-04-12",
"indexname": "DGS3",
"value":   0.41,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-04-15",
"indexname": "DGS3",
"value":   0.42,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-04-16",
"indexname": "DGS3",
"value":   0.42,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-04-17",
"indexname": "DGS3",
"value":    0.4,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-04-18",
"indexname": "DGS3",
"value":    0.4,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-04-19",
"indexname": "DGS3",
"value":    0.4,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-04-22",
"indexname": "DGS3",
"value":   0.39,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-04-23",
"indexname": "DGS3",
"value":    0.4,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-04-24",
"indexname": "DGS3",
"value":   0.39,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-04-25",
"indexname": "DGS3",
"value":   0.39,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-04-26",
"indexname": "DGS3",
"value":   0.39,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-04-29",
"indexname": "DGS3",
"value":   0.38,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-04-30",
"indexname": "DGS3",
"value":   0.39,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-05-01",
"indexname": "DGS3",
"value":   0.39,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-05-02",
"indexname": "DGS3",
"value":    0.4,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-05-03",
"indexname": "DGS3",
"value":   0.37,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-05-06",
"indexname": "DGS3",
"value":   0.37,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-05-07",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-05-08",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-05-09",
"indexname": "DGS3",
"value":   0.37,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-05-10",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-05-13",
"indexname": "DGS3",
"value":   0.37,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-05-14",
"indexname": "DGS3",
"value":   0.38,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-05-15",
"indexname": "DGS3",
"value":    0.4,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-05-16",
"indexname": "DGS3",
"value":    0.4,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-05-17",
"indexname": "DGS3",
"value":   0.42,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-05-20",
"indexname": "DGS3",
"value":   0.41,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-05-21",
"indexname": "DGS3",
"value":   0.41,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-05-22",
"indexname": "DGS3",
"value":    0.4,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-05-23",
"indexname": "DGS3",
"value":   0.42,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-05-24",
"indexname": "DGS3",
"value":   0.41,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-05-28",
"indexname": "DGS3",
"value":   0.42,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-05-29",
"indexname": "DGS3",
"value":   0.38,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-05-30",
"indexname": "DGS3",
"value":   0.35,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-05-31",
"indexname": "DGS3",
"value":   0.34,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-06-03",
"indexname": "DGS3",
"value":   0.35,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-06-04",
"indexname": "DGS3",
"value":   0.34,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-06-05",
"indexname": "DGS3",
"value":   0.37,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-06-06",
"indexname": "DGS3",
"value":   0.37,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-06-07",
"indexname": "DGS3",
"value":   0.39,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-06-10",
"indexname": "DGS3",
"value":   0.37,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-06-11",
"indexname": "DGS3",
"value":   0.41,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-06-12",
"indexname": "DGS3",
"value":    0.4,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-06-13",
"indexname": "DGS3",
"value":   0.41,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-06-14",
"indexname": "DGS3",
"value":   0.37,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-06-17",
"indexname": "DGS3",
"value":   0.38,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-06-18",
"indexname": "DGS3",
"value":   0.39,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-06-19",
"indexname": "DGS3",
"value":   0.41,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-06-20",
"indexname": "DGS3",
"value":   0.41,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-06-21",
"indexname": "DGS3",
"value":   0.42,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-06-24",
"indexname": "DGS3",
"value":   0.39,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-06-25",
"indexname": "DGS3",
"value":   0.42,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-06-26",
"indexname": "DGS3",
"value":   0.42,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-06-27",
"indexname": "DGS3",
"value":    0.4,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-06-28",
"indexname": "DGS3",
"value":   0.41,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-07-01",
"indexname": "DGS3",
"value":   0.39,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-07-02",
"indexname": "DGS3",
"value":   0.39,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-07-04",
"indexname": "DGS3",
"value":   0.39,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-07-05",
"indexname": "DGS3",
"value":   0.37,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-07-08",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-07-09",
"indexname": "DGS3",
"value":   0.37,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-07-10",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-07-11",
"indexname": "DGS3",
"value":   0.35,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-07-12",
"indexname": "DGS3",
"value":   0.34,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-07-15",
"indexname": "DGS3",
"value":   0.31,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-07-16",
"indexname": "DGS3",
"value":   0.32,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-07-17",
"indexname": "DGS3",
"value":    0.3,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-07-18",
"indexname": "DGS3",
"value":   0.31,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-07-19",
"indexname": "DGS3",
"value":   0.29,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-07-22",
"indexname": "DGS3",
"value":   0.28,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-07-23",
"indexname": "DGS3",
"value":   0.28,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-07-24",
"indexname": "DGS3",
"value":   0.28,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-07-25",
"indexname": "DGS3",
"value":   0.31,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-07-26",
"indexname": "DGS3",
"value":   0.34,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-07-29",
"indexname": "DGS3",
"value":   0.31,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-07-30",
"indexname": "DGS3",
"value":    0.3,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-07-31",
"indexname": "DGS3",
"value":   0.32,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-08-01",
"indexname": "DGS3",
"value":   0.31,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-08-02",
"indexname": "DGS3",
"value":   0.33,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-08-05",
"indexname": "DGS3",
"value":   0.33,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-08-06",
"indexname": "DGS3",
"value":   0.37,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-08-07",
"indexname": "DGS3",
"value":   0.38,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-08-08",
"indexname": "DGS3",
"value":   0.38,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-08-09",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-08-12",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-08-13",
"indexname": "DGS3",
"value":   0.39,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-08-14",
"indexname": "DGS3",
"value":   0.42,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-08-15",
"indexname": "DGS3",
"value":   0.42,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-08-16",
"indexname": "DGS3",
"value":   0.42,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-08-19",
"indexname": "DGS3",
"value":   0.41,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-08-20",
"indexname": "DGS3",
"value":   0.42,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-08-21",
"indexname": "DGS3",
"value":   0.37,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-08-22",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-08-23",
"indexname": "DGS3",
"value":   0.37,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-08-26",
"indexname": "DGS3",
"value":   0.37,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-08-27",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-08-28",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-08-29",
"indexname": "DGS3",
"value":   0.35,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-08-30",
"indexname": "DGS3",
"value":    0.3,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-09-03",
"indexname": "DGS3",
"value":   0.31,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-09-04",
"indexname": "DGS3",
"value":   0.32,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-09-05",
"indexname": "DGS3",
"value":   0.34,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-09-06",
"indexname": "DGS3",
"value":   0.33,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-09-09",
"indexname": "DGS3",
"value":   0.33,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-09-10",
"indexname": "DGS3",
"value":   0.33,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-09-11",
"indexname": "DGS3",
"value":   0.33,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-09-12",
"indexname": "DGS3",
"value":   0.32,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-09-13",
"indexname": "DGS3",
"value":   0.35,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-09-16",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-09-17",
"indexname": "DGS3",
"value":   0.35,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-09-18",
"indexname": "DGS3",
"value":   0.35,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-09-19",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-09-20",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-09-23",
"indexname": "DGS3",
"value":   0.35,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-09-24",
"indexname": "DGS3",
"value":   0.35,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-09-25",
"indexname": "DGS3",
"value":   0.34,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-09-26",
"indexname": "DGS3",
"value":   0.34,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-09-27",
"indexname": "DGS3",
"value":   0.31,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-09-30",
"indexname": "DGS3",
"value":   0.31,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-10-01",
"indexname": "DGS3",
"value":   0.31,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-10-02",
"indexname": "DGS3",
"value":   0.31,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-10-03",
"indexname": "DGS3",
"value":   0.32,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-10-04",
"indexname": "DGS3",
"value":   0.34,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-10-08",
"indexname": "DGS3",
"value":   0.35,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-10-09",
"indexname": "DGS3",
"value":   0.35,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-10-10",
"indexname": "DGS3",
"value":   0.34,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-10-11",
"indexname": "DGS3",
"value":   0.34,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-10-14",
"indexname": "DGS3",
"value":   0.34,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-10-15",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-10-16",
"indexname": "DGS3",
"value":   0.41,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-10-17",
"indexname": "DGS3",
"value":   0.41,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-10-18",
"indexname": "DGS3",
"value":   0.41,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-10-21",
"indexname": "DGS3",
"value":   0.42,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-10-22",
"indexname": "DGS3",
"value":   0.41,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-10-23",
"indexname": "DGS3",
"value":    0.4,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-10-24",
"indexname": "DGS3",
"value":   0.43,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-10-25",
"indexname": "DGS3",
"value":   0.41,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-10-28",
"indexname": "DGS3",
"value":    0.4,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-10-30",
"indexname": "DGS3",
"value":   0.38,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-10-31",
"indexname": "DGS3",
"value":   0.38,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-11-01",
"indexname": "DGS3",
"value":   0.38,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-11-04",
"indexname": "DGS3",
"value":   0.38,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-11-05",
"indexname": "DGS3",
"value":   0.41,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-11-06",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-11-07",
"indexname": "DGS3",
"value":   0.35,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-11-08",
"indexname": "DGS3",
"value":   0.35,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-11-12",
"indexname": "DGS3",
"value":   0.33,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-11-13",
"indexname": "DGS3",
"value":   0.33,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-11-14",
"indexname": "DGS3",
"value":   0.32,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-11-15",
"indexname": "DGS3",
"value":   0.32,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-11-18",
"indexname": "DGS3",
"value":   0.33,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-11-19",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-11-20",
"indexname": "DGS3",
"value":   0.37,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-11-22",
"indexname": "DGS3",
"value":   0.37,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-11-25",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-11-26",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-11-27",
"indexname": "DGS3",
"value":   0.35,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-11-28",
"indexname": "DGS3",
"value":   0.35,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-11-29",
"indexname": "DGS3",
"value":   0.34,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-12-02",
"indexname": "DGS3",
"value":   0.34,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-12-03",
"indexname": "DGS3",
"value":   0.34,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-12-04",
"indexname": "DGS3",
"value":   0.32,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-12-05",
"indexname": "DGS3",
"value":   0.32,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-12-06",
"indexname": "DGS3",
"value":   0.33,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-12-09",
"indexname": "DGS3",
"value":   0.33,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-12-10",
"indexname": "DGS3",
"value":   0.32,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-12-11",
"indexname": "DGS3",
"value":   0.32,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-12-12",
"indexname": "DGS3",
"value":   0.34,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-12-13",
"indexname": "DGS3",
"value":   0.34,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-12-16",
"indexname": "DGS3",
"value":   0.37,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-12-17",
"indexname": "DGS3",
"value":   0.39,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-12-18",
"indexname": "DGS3",
"value":   0.39,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-12-19",
"indexname": "DGS3",
"value":   0.39,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-12-20",
"indexname": "DGS3",
"value":   0.38,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-12-23",
"indexname": "DGS3",
"value":   0.38,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-12-25",
"indexname": "DGS3",
"value":   0.39,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-12-26",
"indexname": "DGS3",
"value":   0.37,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-12-27",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-12-30",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-01-01",
"indexname": "DGS3",
"value":   0.37,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-01-02",
"indexname": "DGS3",
"value":    0.4,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-01-03",
"indexname": "DGS3",
"value":   0.41,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-01-06",
"indexname": "DGS3",
"value":   0.41,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-01-07",
"indexname": "DGS3",
"value":   0.38,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-01-08",
"indexname": "DGS3",
"value":   0.37,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-01-09",
"indexname": "DGS3",
"value":   0.37,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-01-10",
"indexname": "DGS3",
"value":   0.37,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-01-13",
"indexname": "DGS3",
"value":   0.37,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-01-14",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-01-15",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-01-16",
"indexname": "DGS3",
"value":   0.39,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-01-17",
"indexname": "DGS3",
"value":   0.38,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-01-21",
"indexname": "DGS3",
"value":   0.38,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-01-22",
"indexname": "DGS3",
"value":   0.37,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-01-23",
"indexname": "DGS3",
"value":   0.37,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-01-24",
"indexname": "DGS3",
"value":   0.42,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-01-27",
"indexname": "DGS3",
"value":   0.45,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-01-28",
"indexname": "DGS3",
"value":   0.43,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-01-29",
"indexname": "DGS3",
"value":   0.42,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-01-30",
"indexname": "DGS3",
"value":   0.42,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-01-31",
"indexname": "DGS3",
"value":    0.4,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-02-03",
"indexname": "DGS3",
"value":   0.38,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-02-04",
"indexname": "DGS3",
"value":   0.41,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-02-05",
"indexname": "DGS3",
"value":   0.39,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-02-06",
"indexname": "DGS3",
"value":   0.39,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-02-07",
"indexname": "DGS3",
"value":   0.39,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-02-10",
"indexname": "DGS3",
"value":    0.4,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-02-11",
"indexname": "DGS3",
"value":   0.41,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-02-12",
"indexname": "DGS3",
"value":   0.44,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-02-13",
"indexname": "DGS3",
"value":   0.42,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-02-14",
"indexname": "DGS3",
"value":   0.42,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-02-18",
"indexname": "DGS3",
"value":   0.44,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-02-19",
"indexname": "DGS3",
"value":   0.42,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-02-20",
"indexname": "DGS3",
"value":    0.4,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-02-21",
"indexname": "DGS3",
"value":    0.4,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-02-24",
"indexname": "DGS3",
"value":   0.37,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-02-25",
"indexname": "DGS3",
"value":   0.37,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-02-26",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-02-27",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-02-28",
"indexname": "DGS3",
"value":   0.35,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-03-03",
"indexname": "DGS3",
"value":   0.35,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-03-04",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-03-05",
"indexname": "DGS3",
"value":   0.38,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-03-06",
"indexname": "DGS3",
"value":    0.4,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-03-07",
"indexname": "DGS3",
"value":   0.42,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-03-10",
"indexname": "DGS3",
"value":   0.43,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-03-11",
"indexname": "DGS3",
"value":   0.41,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-03-12",
"indexname": "DGS3",
"value":   0.42,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-03-13",
"indexname": "DGS3",
"value":   0.42,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-03-14",
"indexname": "DGS3",
"value":    0.4,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-03-17",
"indexname": "DGS3",
"value":   0.38,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-03-18",
"indexname": "DGS3",
"value":   0.37,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-03-19",
"indexname": "DGS3",
"value":   0.38,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-03-20",
"indexname": "DGS3",
"value":   0.38,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-03-21",
"indexname": "DGS3",
"value":   0.39,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-03-24",
"indexname": "DGS3",
"value":   0.38,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-03-25",
"indexname": "DGS3",
"value":   0.38,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-03-26",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-03-27",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-03-31",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-04-01",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-04-02",
"indexname": "DGS3",
"value":   0.34,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-04-03",
"indexname": "DGS3",
"value":   0.33,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-04-04",
"indexname": "DGS3",
"value":   0.33,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-04-07",
"indexname": "DGS3",
"value":   0.34,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-04-08",
"indexname": "DGS3",
"value":   0.34,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-04-09",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-04-10",
"indexname": "DGS3",
"value":   0.35,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-04-11",
"indexname": "DGS3",
"value":   0.33,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-04-14",
"indexname": "DGS3",
"value":   0.32,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-04-15",
"indexname": "DGS3",
"value":   0.33,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-04-16",
"indexname": "DGS3",
"value":   0.35,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-04-17",
"indexname": "DGS3",
"value":   0.35,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-04-18",
"indexname": "DGS3",
"value":   0.35,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-04-21",
"indexname": "DGS3",
"value":   0.35,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-04-22",
"indexname": "DGS3",
"value":   0.35,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-04-23",
"indexname": "DGS3",
"value":   0.34,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-04-24",
"indexname": "DGS3",
"value":   0.35,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-04-25",
"indexname": "DGS3",
"value":   0.32,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-04-28",
"indexname": "DGS3",
"value":   0.32,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-04-29",
"indexname": "DGS3",
"value":   0.32,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-04-30",
"indexname": "DGS3",
"value":    0.3,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-05-01",
"indexname": "DGS3",
"value":    0.3,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-05-02",
"indexname": "DGS3",
"value":   0.34,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-05-05",
"indexname": "DGS3",
"value":   0.34,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-05-06",
"indexname": "DGS3",
"value":   0.35,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-05-07",
"indexname": "DGS3",
"value":   0.35,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-05-08",
"indexname": "DGS3",
"value":   0.35,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-05-09",
"indexname": "DGS3",
"value":   0.38,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-05-12",
"indexname": "DGS3",
"value":    0.4,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-05-13",
"indexname": "DGS3",
"value":   0.41,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-05-14",
"indexname": "DGS3",
"value":    0.4,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-05-15",
"indexname": "DGS3",
"value":   0.37,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-05-16",
"indexname": "DGS3",
"value":    0.4,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-05-19",
"indexname": "DGS3",
"value":    0.4,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-05-20",
"indexname": "DGS3",
"value":   0.39,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-05-21",
"indexname": "DGS3",
"value":   0.41,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-05-22",
"indexname": "DGS3",
"value":   0.42,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-05-23",
"indexname": "DGS3",
"value":   0.41,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-05-27",
"indexname": "DGS3",
"value":   0.49,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-05-28",
"indexname": "DGS3",
"value":   0.49,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-05-29",
"indexname": "DGS3",
"value":   0.49,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-05-30",
"indexname": "DGS3",
"value":   0.52,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-06-02",
"indexname": "DGS3",
"value":    0.5,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-06-03",
"indexname": "DGS3",
"value":   0.48,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-06-04",
"indexname": "DGS3",
"value":   0.48,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-06-05",
"indexname": "DGS3",
"value":   0.48,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-06-06",
"indexname": "DGS3",
"value":   0.52,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-06-09",
"indexname": "DGS3",
"value":   0.55,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-06-10",
"indexname": "DGS3",
"value":   0.57,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-06-11",
"indexname": "DGS3",
"value":   0.57,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-06-12",
"indexname": "DGS3",
"value":   0.55,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-06-13",
"indexname": "DGS3",
"value":   0.49,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-06-16",
"indexname": "DGS3",
"value":   0.49,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-06-17",
"indexname": "DGS3",
"value":   0.48,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-06-18",
"indexname": "DGS3",
"value":   0.58,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-06-19",
"indexname": "DGS3",
"value":   0.62,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-06-20",
"indexname": "DGS3",
"value":    0.7,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-06-23",
"indexname": "DGS3",
"value":   0.73,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-06-24",
"indexname": "DGS3",
"value":   0.74,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-01-02",
"indexname": "DGS5",
"value":   0.89,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-01-03",
"indexname": "DGS5",
"value":   0.89,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-01-04",
"indexname": "DGS5",
"value":   0.88,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-01-05",
"indexname": "DGS5",
"value":   0.86,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-01-08",
"indexname": "DGS5",
"value":   0.85,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-01-09",
"indexname": "DGS5",
"value":   0.86,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-01-10",
"indexname": "DGS5",
"value":   0.82,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-01-11",
"indexname": "DGS5",
"value":   0.84,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-01-12",
"indexname": "DGS5",
"value":    0.8,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-01-16",
"indexname": "DGS5",
"value":   0.79,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-01-17",
"indexname": "DGS5",
"value":   0.82,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-01-18",
"indexname": "DGS5",
"value":   0.87,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-01-19",
"indexname": "DGS5",
"value":   0.91,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-01-22",
"indexname": "DGS5",
"value":   0.93,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-01-23",
"indexname": "DGS5",
"value":   0.92,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-01-24",
"indexname": "DGS5",
"value":   0.81,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-01-25",
"indexname": "DGS5",
"value":   0.77,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-01-26",
"indexname": "DGS5",
"value":   0.75,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-01-29",
"indexname": "DGS5",
"value":   0.73,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-01-30",
"indexname": "DGS5",
"value":   0.71,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-01-31",
"indexname": "DGS5",
"value":   0.72,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-02-01",
"indexname": "DGS5",
"value":   0.71,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-02-02",
"indexname": "DGS5",
"value":   0.78,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-02-05",
"indexname": "DGS5",
"value":   0.76,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-02-06",
"indexname": "DGS5",
"value":   0.82,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-02-07",
"indexname": "DGS5",
"value":   0.82,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-02-08",
"indexname": "DGS5",
"value":   0.86,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-02-09",
"indexname": "DGS5",
"value":   0.81,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-02-12",
"indexname": "DGS5",
"value":   0.85,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-02-13",
"indexname": "DGS5",
"value":   0.81,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-02-14",
"indexname": "DGS5",
"value":   0.81,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-02-15",
"indexname": "DGS5",
"value":   0.87,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-02-16",
"indexname": "DGS5",
"value":   0.88,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-02-20",
"indexname": "DGS5",
"value":   0.92,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-02-21",
"indexname": "DGS5",
"value":   0.88,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-02-22",
"indexname": "DGS5",
"value":   0.88,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-02-23",
"indexname": "DGS5",
"value":   0.89,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-02-26",
"indexname": "DGS5",
"value":   0.84,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-02-27",
"indexname": "DGS5",
"value":   0.84,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-02-28",
"indexname": "DGS5",
"value":   0.87,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-02-29",
"indexname": "DGS5",
"value":   0.89,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-03-01",
"indexname": "DGS5",
"value":   0.84,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-03-04",
"indexname": "DGS5",
"value":   0.87,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-03-05",
"indexname": "DGS5",
"value":   0.83,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-03-06",
"indexname": "DGS5",
"value":   0.85,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-03-07",
"indexname": "DGS5",
"value":   0.89,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-03-08",
"indexname": "DGS5",
"value":    0.9,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-03-11",
"indexname": "DGS5",
"value":   0.92,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-03-12",
"indexname": "DGS5",
"value":   0.99,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-03-13",
"indexname": "DGS5",
"value":   1.13,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-03-14",
"indexname": "DGS5",
"value":   1.11,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-03-15",
"indexname": "DGS5",
"value":   1.13,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-03-18",
"indexname": "DGS5",
"value":    1.2,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-03-19",
"indexname": "DGS5",
"value":   1.22,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-03-20",
"indexname": "DGS5",
"value":   1.15,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-03-21",
"indexname": "DGS5",
"value":   1.13,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-03-22",
"indexname": "DGS5",
"value":    1.1,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-03-25",
"indexname": "DGS5",
"value":   1.09,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-03-26",
"indexname": "DGS5",
"value":   1.04,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-03-27",
"indexname": "DGS5",
"value":   1.05,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-03-28",
"indexname": "DGS5",
"value":   1.01,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-03-29",
"indexname": "DGS5",
"value":   1.04,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-04-01",
"indexname": "DGS5",
"value":   1.03,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-04-02",
"indexname": "DGS5",
"value":    1.1,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-04-03",
"indexname": "DGS5",
"value":   1.05,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-04-04",
"indexname": "DGS5",
"value":   1.01,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-04-05",
"indexname": "DGS5",
"value":   0.89,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-04-08",
"indexname": "DGS5",
"value":    0.9,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-04-09",
"indexname": "DGS5",
"value":   0.85,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-04-10",
"indexname": "DGS5",
"value":   0.89,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-04-11",
"indexname": "DGS5",
"value":    0.9,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-04-12",
"indexname": "DGS5",
"value":   0.86,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-04-15",
"indexname": "DGS5",
"value":   0.85,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-04-16",
"indexname": "DGS5",
"value":   0.88,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-04-17",
"indexname": "DGS5",
"value":   0.86,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-04-18",
"indexname": "DGS5",
"value":   0.84,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-04-19",
"indexname": "DGS5",
"value":   0.86,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-04-22",
"indexname": "DGS5",
"value":   0.83,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-04-23",
"indexname": "DGS5",
"value":   0.86,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-04-24",
"indexname": "DGS5",
"value":   0.86,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-04-25",
"indexname": "DGS5",
"value":   0.83,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-04-26",
"indexname": "DGS5",
"value":   0.82,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-04-29",
"indexname": "DGS5",
"value":   0.82,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-04-30",
"indexname": "DGS5",
"value":   0.84,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-05-01",
"indexname": "DGS5",
"value":   0.82,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-05-02",
"indexname": "DGS5",
"value":   0.82,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-05-03",
"indexname": "DGS5",
"value":   0.78,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-05-06",
"indexname": "DGS5",
"value":   0.79,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-05-07",
"indexname": "DGS5",
"value":   0.77,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-05-08",
"indexname": "DGS5",
"value":   0.77,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-05-09",
"indexname": "DGS5",
"value":   0.79,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-05-10",
"indexname": "DGS5",
"value":   0.75,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-05-13",
"indexname": "DGS5",
"value":   0.73,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-05-14",
"indexname": "DGS5",
"value":   0.74,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-05-15",
"indexname": "DGS5",
"value":   0.75,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-05-16",
"indexname": "DGS5",
"value":   0.74,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-05-17",
"indexname": "DGS5",
"value":   0.75,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-05-20",
"indexname": "DGS5",
"value":   0.75,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-05-21",
"indexname": "DGS5",
"value":   0.78,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-05-22",
"indexname": "DGS5",
"value":   0.74,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-05-23",
"indexname": "DGS5",
"value":   0.77,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-05-24",
"indexname": "DGS5",
"value":   0.76,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-05-28",
"indexname": "DGS5",
"value":   0.76,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-05-29",
"indexname": "DGS5",
"value":   0.69,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-05-30",
"indexname": "DGS5",
"value":   0.67,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-05-31",
"indexname": "DGS5",
"value":   0.62,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-06-03",
"indexname": "DGS5",
"value":   0.68,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-06-04",
"indexname": "DGS5",
"value":   0.68,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-06-05",
"indexname": "DGS5",
"value":   0.73,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-06-06",
"indexname": "DGS5",
"value":   0.72,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-06-07",
"indexname": "DGS5",
"value":   0.71,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-06-10",
"indexname": "DGS5",
"value":   0.69,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-06-11",
"indexname": "DGS5",
"value":   0.75,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-06-12",
"indexname": "DGS5",
"value":   0.71,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-06-13",
"indexname": "DGS5",
"value":   0.73,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-06-14",
"indexname": "DGS5",
"value":   0.68,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-06-17",
"indexname": "DGS5",
"value":   0.69,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-06-18",
"indexname": "DGS5",
"value":   0.71,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-06-19",
"indexname": "DGS5",
"value":   0.74,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-06-20",
"indexname": "DGS5",
"value":   0.73,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-06-21",
"indexname": "DGS5",
"value":   0.76,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-06-24",
"indexname": "DGS5",
"value":   0.72,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-06-25",
"indexname": "DGS5",
"value":   0.75,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-06-26",
"indexname": "DGS5",
"value":   0.73,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-06-27",
"indexname": "DGS5",
"value":   0.69,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-06-28",
"indexname": "DGS5",
"value":   0.72,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-07-01",
"indexname": "DGS5",
"value":   0.67,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-07-02",
"indexname": "DGS5",
"value":   0.69,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-07-04",
"indexname": "DGS5",
"value":   0.68,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-07-05",
"indexname": "DGS5",
"value":   0.64,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-07-08",
"indexname": "DGS5",
"value":   0.63,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-07-09",
"indexname": "DGS5",
"value":   0.63,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-07-10",
"indexname": "DGS5",
"value":   0.64,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-07-11",
"indexname": "DGS5",
"value":   0.63,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-07-12",
"indexname": "DGS5",
"value":   0.63,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-07-15",
"indexname": "DGS5",
"value":    0.6,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-07-16",
"indexname": "DGS5",
"value":   0.62,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-07-17",
"indexname": "DGS5",
"value":    0.6,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-07-18",
"indexname": "DGS5",
"value":   0.62,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-07-19",
"indexname": "DGS5",
"value":   0.59,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-07-22",
"indexname": "DGS5",
"value":   0.57,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-07-23",
"indexname": "DGS5",
"value":   0.57,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-07-24",
"indexname": "DGS5",
"value":   0.56,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-07-25",
"indexname": "DGS5",
"value":   0.58,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-07-26",
"indexname": "DGS5",
"value":   0.65,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-07-29",
"indexname": "DGS5",
"value":   0.61,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-07-30",
"indexname": "DGS5",
"value":    0.6,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-07-31",
"indexname": "DGS5",
"value":   0.63,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-08-01",
"indexname": "DGS5",
"value":   0.61,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-08-02",
"indexname": "DGS5",
"value":   0.67,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-08-05",
"indexname": "DGS5",
"value":   0.65,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-08-06",
"indexname": "DGS5",
"value":   0.71,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-08-07",
"indexname": "DGS5",
"value":   0.73,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-08-08",
"indexname": "DGS5",
"value":   0.74,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-08-09",
"indexname": "DGS5",
"value":   0.71,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-08-12",
"indexname": "DGS5",
"value":   0.71,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-08-13",
"indexname": "DGS5",
"value":   0.75,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-08-14",
"indexname": "DGS5",
"value":    0.8,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-08-15",
"indexname": "DGS5",
"value":   0.83,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-08-16",
"indexname": "DGS5",
"value":   0.81,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-08-19",
"indexname": "DGS5",
"value":    0.8,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-08-20",
"indexname": "DGS5",
"value":    0.8,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-08-21",
"indexname": "DGS5",
"value":   0.71,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-08-22",
"indexname": "DGS5",
"value":   0.71,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-08-23",
"indexname": "DGS5",
"value":   0.72,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-08-26",
"indexname": "DGS5",
"value":    0.7,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-08-27",
"indexname": "DGS5",
"value":   0.69,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-08-28",
"indexname": "DGS5",
"value":   0.69,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-08-29",
"indexname": "DGS5",
"value":   0.66,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-08-30",
"indexname": "DGS5",
"value":   0.59,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-09-03",
"indexname": "DGS5",
"value":   0.62,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-09-04",
"indexname": "DGS5",
"value":   0.62,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-09-05",
"indexname": "DGS5",
"value":   0.68,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-09-06",
"indexname": "DGS5",
"value":   0.64,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-09-09",
"indexname": "DGS5",
"value":   0.66,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-09-10",
"indexname": "DGS5",
"value":   0.67,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-09-11",
"indexname": "DGS5",
"value":    0.7,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-09-12",
"indexname": "DGS5",
"value":   0.65,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-09-13",
"indexname": "DGS5",
"value":   0.72,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-09-16",
"indexname": "DGS5",
"value":   0.73,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-09-17",
"indexname": "DGS5",
"value":   0.71,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-09-18",
"indexname": "DGS5",
"value":    0.7,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-09-19",
"indexname": "DGS5",
"value":    0.7,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-09-20",
"indexname": "DGS5",
"value":   0.68,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-09-23",
"indexname": "DGS5",
"value":   0.68,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-09-24",
"indexname": "DGS5",
"value":   0.66,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-09-25",
"indexname": "DGS5",
"value":   0.63,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-09-26",
"indexname": "DGS5",
"value":   0.64,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-09-27",
"indexname": "DGS5",
"value":   0.62,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-09-30",
"indexname": "DGS5",
"value":   0.62,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-10-01",
"indexname": "DGS5",
"value":   0.61,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-10-02",
"indexname": "DGS5",
"value":   0.61,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-10-03",
"indexname": "DGS5",
"value":   0.63,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-10-04",
"indexname": "DGS5",
"value":   0.67,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-10-08",
"indexname": "DGS5",
"value":   0.67,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-10-09",
"indexname": "DGS5",
"value":   0.66,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-10-10",
"indexname": "DGS5",
"value":   0.67,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-10-11",
"indexname": "DGS5",
"value":   0.67,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-10-14",
"indexname": "DGS5",
"value":   0.67,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-10-15",
"indexname": "DGS5",
"value":    0.7,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-10-16",
"indexname": "DGS5",
"value":   0.78,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-10-17",
"indexname": "DGS5",
"value":   0.79,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-10-18",
"indexname": "DGS5",
"value":   0.77,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-10-21",
"indexname": "DGS5",
"value":   0.79,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-10-22",
"indexname": "DGS5",
"value":   0.77,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-10-23",
"indexname": "DGS5",
"value":   0.76,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-10-24",
"indexname": "DGS5",
"value":   0.82,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-10-25",
"indexname": "DGS5",
"value":   0.76,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-10-28",
"indexname": "DGS5",
"value":   0.74,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-10-30",
"indexname": "DGS5",
"value":   0.72,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-10-31",
"indexname": "DGS5",
"value":   0.73,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-11-01",
"indexname": "DGS5",
"value":   0.73,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-11-04",
"indexname": "DGS5",
"value":    0.7,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-11-05",
"indexname": "DGS5",
"value":   0.75,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-11-06",
"indexname": "DGS5",
"value":   0.67,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-11-07",
"indexname": "DGS5",
"value":   0.65,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-11-08",
"indexname": "DGS5",
"value":   0.65,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-11-12",
"indexname": "DGS5",
"value":   0.63,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-11-13",
"indexname": "DGS5",
"value":   0.63,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-11-14",
"indexname": "DGS5",
"value":   0.62,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-11-15",
"indexname": "DGS5",
"value":   0.62,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-11-18",
"indexname": "DGS5",
"value":   0.64,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-11-19",
"indexname": "DGS5",
"value":   0.67,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-11-20",
"indexname": "DGS5",
"value":   0.69,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-11-22",
"indexname": "DGS5",
"value":    0.7,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-11-25",
"indexname": "DGS5",
"value":   0.68,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-11-26",
"indexname": "DGS5",
"value":   0.66,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-11-27",
"indexname": "DGS5",
"value":   0.64,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-11-28",
"indexname": "DGS5",
"value":   0.63,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-11-29",
"indexname": "DGS5",
"value":   0.61,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-12-02",
"indexname": "DGS5",
"value":   0.63,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-12-03",
"indexname": "DGS5",
"value":   0.63,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-12-04",
"indexname": "DGS5",
"value":   0.61,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-12-05",
"indexname": "DGS5",
"value":    0.6,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-12-06",
"indexname": "DGS5",
"value":   0.63,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-12-09",
"indexname": "DGS5",
"value":   0.62,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-12-10",
"indexname": "DGS5",
"value":   0.64,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-12-11",
"indexname": "DGS5",
"value":   0.66,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-12-12",
"indexname": "DGS5",
"value":    0.7,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-12-13",
"indexname": "DGS5",
"value":    0.7,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-12-16",
"indexname": "DGS5",
"value":   0.74,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-12-17",
"indexname": "DGS5",
"value":   0.78,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-12-18",
"indexname": "DGS5",
"value":   0.77,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-12-19",
"indexname": "DGS5",
"value":   0.77,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-12-20",
"indexname": "DGS5",
"value":   0.75,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-12-23",
"indexname": "DGS5",
"value":   0.77,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-12-25",
"indexname": "DGS5",
"value":   0.76,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-12-26",
"indexname": "DGS5",
"value":   0.72,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-12-27",
"indexname": "DGS5",
"value":   0.72,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-12-30",
"indexname": "DGS5",
"value":   0.72,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-01-01",
"indexname": "DGS5",
"value":   0.76,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-01-02",
"indexname": "DGS5",
"value":   0.81,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-01-03",
"indexname": "DGS5",
"value":   0.82,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-01-06",
"indexname": "DGS5",
"value":   0.82,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-01-07",
"indexname": "DGS5",
"value":   0.79,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-01-08",
"indexname": "DGS5",
"value":   0.77,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-01-09",
"indexname": "DGS5",
"value":    0.8,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-01-10",
"indexname": "DGS5",
"value":   0.78,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-01-13",
"indexname": "DGS5",
"value":   0.78,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-01-14",
"indexname": "DGS5",
"value":   0.75,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-01-15",
"indexname": "DGS5",
"value":   0.75,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-01-16",
"indexname": "DGS5",
"value":   0.79,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-01-17",
"indexname": "DGS5",
"value":   0.77,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-01-21",
"indexname": "DGS5",
"value":   0.76,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-01-22",
"indexname": "DGS5",
"value":   0.76,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-01-23",
"indexname": "DGS5",
"value":   0.78,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-01-24",
"indexname": "DGS5",
"value":   0.87,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-01-27",
"indexname": "DGS5",
"value":   0.89,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-01-28",
"indexname": "DGS5",
"value":    0.9,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-01-29",
"indexname": "DGS5",
"value":   0.88,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-01-30",
"indexname": "DGS5",
"value":   0.88,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-01-31",
"indexname": "DGS5",
"value":   0.88,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-02-03",
"indexname": "DGS5",
"value":   0.85,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-02-04",
"indexname": "DGS5",
"value":   0.88,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-02-05",
"indexname": "DGS5",
"value":   0.84,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-02-06",
"indexname": "DGS5",
"value":   0.83,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-02-07",
"indexname": "DGS5",
"value":   0.84,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-02-10",
"indexname": "DGS5",
"value":   0.85,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-02-11",
"indexname": "DGS5",
"value":   0.88,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-02-12",
"indexname": "DGS5",
"value":   0.92,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-02-13",
"indexname": "DGS5",
"value":   0.86,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-02-14",
"indexname": "DGS5",
"value":   0.87,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-02-18",
"indexname": "DGS5",
"value":   0.89,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-02-19",
"indexname": "DGS5",
"value":   0.88,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-02-20",
"indexname": "DGS5",
"value":   0.86,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-02-21",
"indexname": "DGS5",
"value":   0.84,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-02-24",
"indexname": "DGS5",
"value":   0.78,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-02-25",
"indexname": "DGS5",
"value":   0.78,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-02-26",
"indexname": "DGS5",
"value":   0.78,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-02-27",
"indexname": "DGS5",
"value":   0.77,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-02-28",
"indexname": "DGS5",
"value":   0.75,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-03-03",
"indexname": "DGS5",
"value":   0.76,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-03-04",
"indexname": "DGS5",
"value":   0.77,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-03-05",
"indexname": "DGS5",
"value":   0.81,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-03-06",
"indexname": "DGS5",
"value":   0.85,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-03-07",
"indexname": "DGS5",
"value":    0.9,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-03-10",
"indexname": "DGS5",
"value":    0.9,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-03-11",
"indexname": "DGS5",
"value":   0.88,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-03-12",
"indexname": "DGS5",
"value":   0.89,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-03-13",
"indexname": "DGS5",
"value":   0.88,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-03-14",
"indexname": "DGS5",
"value":   0.84,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-03-17",
"indexname": "DGS5",
"value":   0.81,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-03-18",
"indexname": "DGS5",
"value":   0.79,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-03-19",
"indexname": "DGS5",
"value":   0.81,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-03-20",
"indexname": "DGS5",
"value":   0.81,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-03-21",
"indexname": "DGS5",
"value":    0.8,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-03-24",
"indexname": "DGS5",
"value":    0.8,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-03-25",
"indexname": "DGS5",
"value":   0.79,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-03-26",
"indexname": "DGS5",
"value":   0.76,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-03-27",
"indexname": "DGS5",
"value":   0.77,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-03-31",
"indexname": "DGS5",
"value":   0.76,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-04-01",
"indexname": "DGS5",
"value":   0.78,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-04-02",
"indexname": "DGS5",
"value":   0.73,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-04-03",
"indexname": "DGS5",
"value":   0.69,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-04-04",
"indexname": "DGS5",
"value":   0.68,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-04-07",
"indexname": "DGS5",
"value":   0.71,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-04-08",
"indexname": "DGS5",
"value":    0.7,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-04-09",
"indexname": "DGS5",
"value":   0.74,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-04-10",
"indexname": "DGS5",
"value":   0.74,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-04-11",
"indexname": "DGS5",
"value":    0.7,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-04-14",
"indexname": "DGS5",
"value":   0.69,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-04-15",
"indexname": "DGS5",
"value":   0.71,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-04-16",
"indexname": "DGS5",
"value":   0.71,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-04-17",
"indexname": "DGS5",
"value":   0.71,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-04-18",
"indexname": "DGS5",
"value":   0.72,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-04-21",
"indexname": "DGS5",
"value":    0.7,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-04-22",
"indexname": "DGS5",
"value":   0.71,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-04-23",
"indexname": "DGS5",
"value":    0.7,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-04-24",
"indexname": "DGS5",
"value":   0.71,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-04-25",
"indexname": "DGS5",
"value":   0.68,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-04-28",
"indexname": "DGS5",
"value":   0.68,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-04-29",
"indexname": "DGS5",
"value":   0.68,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-04-30",
"indexname": "DGS5",
"value":   0.65,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-05-01",
"indexname": "DGS5",
"value":   0.65,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-05-02",
"indexname": "DGS5",
"value":   0.73,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-05-05",
"indexname": "DGS5",
"value":   0.74,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-05-06",
"indexname": "DGS5",
"value":   0.75,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-05-07",
"indexname": "DGS5",
"value":   0.75,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-05-08",
"indexname": "DGS5",
"value":   0.75,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-05-09",
"indexname": "DGS5",
"value":   0.82,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-05-12",
"indexname": "DGS5",
"value":   0.83,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-05-13",
"indexname": "DGS5",
"value":   0.85,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-05-14",
"indexname": "DGS5",
"value":   0.84,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-05-15",
"indexname": "DGS5",
"value":   0.79,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-05-16",
"indexname": "DGS5",
"value":   0.84,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-05-19",
"indexname": "DGS5",
"value":   0.85,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-05-20",
"indexname": "DGS5",
"value":   0.84,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-05-21",
"indexname": "DGS5",
"value":   0.91,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-05-22",
"indexname": "DGS5",
"value":   0.91,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-05-23",
"indexname": "DGS5",
"value":    0.9,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-05-27",
"indexname": "DGS5",
"value":   1.02,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-05-28",
"indexname": "DGS5",
"value":   1.02,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-05-29",
"indexname": "DGS5",
"value":   1.01,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-05-30",
"indexname": "DGS5",
"value":   1.05,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-06-02",
"indexname": "DGS5",
"value":   1.03,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-06-03",
"indexname": "DGS5",
"value":   1.05,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-06-04",
"indexname": "DGS5",
"value":   1.02,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-06-05",
"indexname": "DGS5",
"value":   1.01,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-06-06",
"indexname": "DGS5",
"value":    1.1,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-06-09",
"indexname": "DGS5",
"value":   1.13,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-06-10",
"indexname": "DGS5",
"value":   1.12,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-06-11",
"indexname": "DGS5",
"value":   1.15,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-06-12",
"indexname": "DGS5",
"value":   1.11,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-06-13",
"indexname": "DGS5",
"value":   1.04,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-06-16",
"indexname": "DGS5",
"value":   1.06,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-06-17",
"indexname": "DGS5",
"value":   1.07,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-06-18",
"indexname": "DGS5",
"value":   1.24,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-06-19",
"indexname": "DGS5",
"value":   1.31,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-06-20",
"indexname": "DGS5",
"value":   1.42,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-06-23",
"indexname": "DGS5",
"value":   1.48,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-06-24",
"indexname": "DGS5",
"value":   1.49,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-01-02",
"indexname": "DGS7",
"value":   1.41,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-01-03",
"indexname": "DGS7",
"value":   1.43,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-01-04",
"indexname": "DGS7",
"value":   1.43,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-01-05",
"indexname": "DGS7",
"value":    1.4,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-01-08",
"indexname": "DGS7",
"value":   1.39,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-01-09",
"indexname": "DGS7",
"value":   1.41,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-01-10",
"indexname": "DGS7",
"value":   1.34,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-01-11",
"indexname": "DGS7",
"value":   1.37,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-01-12",
"indexname": "DGS7",
"value":   1.32,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-01-16",
"indexname": "DGS7",
"value":   1.31,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-01-17",
"indexname": "DGS7",
"value":   1.34,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-01-18",
"indexname": "DGS7",
"value":   1.43,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-01-19",
"indexname": "DGS7",
"value":   1.47,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-01-22",
"indexname": "DGS7",
"value":   1.51,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-01-23",
"indexname": "DGS7",
"value":   1.49,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-01-24",
"indexname": "DGS7",
"value":    1.4,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-01-25",
"indexname": "DGS7",
"value":   1.34,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-01-26",
"indexname": "DGS7",
"value":   1.31,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-01-29",
"indexname": "DGS7",
"value":   1.27,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-01-30",
"indexname": "DGS7",
"value":   1.24,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-01-31",
"indexname": "DGS7",
"value":   1.27,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-02-01",
"indexname": "DGS7",
"value":   1.25,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-02-02",
"indexname": "DGS7",
"value":   1.35,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-02-05",
"indexname": "DGS7",
"value":   1.32,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-02-06",
"indexname": "DGS7",
"value":   1.39,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-02-07",
"indexname": "DGS7",
"value":   1.39,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-02-08",
"indexname": "DGS7",
"value":   1.43,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-02-09",
"indexname": "DGS7",
"value":   1.36,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-02-12",
"indexname": "DGS7",
"value":    1.4,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-02-13",
"indexname": "DGS7",
"value":   1.34,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-02-14",
"indexname": "DGS7",
"value":   1.34,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-02-15",
"indexname": "DGS7",
"value":   1.41,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-02-16",
"indexname": "DGS7",
"value":   1.43,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-02-20",
"indexname": "DGS7",
"value":   1.47,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-02-21",
"indexname": "DGS7",
"value":   1.41,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-02-22",
"indexname": "DGS7",
"value":    1.4,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-02-23",
"indexname": "DGS7",
"value":   1.41,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-02-26",
"indexname": "DGS7",
"value":   1.35,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-02-27",
"indexname": "DGS7",
"value":   1.36,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-02-28",
"indexname": "DGS7",
"value":   1.39,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-02-29",
"indexname": "DGS7",
"value":   1.44,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-03-01",
"indexname": "DGS7",
"value":   1.38,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-03-04",
"indexname": "DGS7",
"value":    1.4,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-03-05",
"indexname": "DGS7",
"value":   1.35,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-03-06",
"indexname": "DGS7",
"value":   1.37,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-03-07",
"indexname": "DGS7",
"value":   1.41,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-03-08",
"indexname": "DGS7",
"value":   1.43,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-03-11",
"indexname": "DGS7",
"value":   1.43,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-03-12",
"indexname": "DGS7",
"value":   1.52,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-03-13",
"indexname": "DGS7",
"value":   1.69,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-03-14",
"indexname": "DGS7",
"value":   1.67,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-03-15",
"indexname": "DGS7",
"value":    1.7,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-03-18",
"indexname": "DGS7",
"value":   1.77,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-03-19",
"indexname": "DGS7",
"value":   1.78,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-03-20",
"indexname": "DGS7",
"value":   1.71,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-03-21",
"indexname": "DGS7",
"value":   1.69,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-03-22",
"indexname": "DGS7",
"value":   1.66,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-03-25",
"indexname": "DGS7",
"value":   1.65,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-03-26",
"indexname": "DGS7",
"value":   1.59,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-03-27",
"indexname": "DGS7",
"value":    1.6,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-03-28",
"indexname": "DGS7",
"value":   1.57,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-03-29",
"indexname": "DGS7",
"value":   1.61,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-04-01",
"indexname": "DGS7",
"value":    1.6,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-04-02",
"indexname": "DGS7",
"value":   1.68,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-04-03",
"indexname": "DGS7",
"value":   1.62,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-04-04",
"indexname": "DGS7",
"value":   1.56,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-04-05",
"indexname": "DGS7",
"value":   1.42,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-04-08",
"indexname": "DGS7",
"value":   1.42,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-04-09",
"indexname": "DGS7",
"value":   1.37,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-04-10",
"indexname": "DGS7",
"value":   1.41,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-04-11",
"indexname": "DGS7",
"value":   1.44,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-04-12",
"indexname": "DGS7",
"value":   1.39,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-04-15",
"indexname": "DGS7",
"value":   1.37,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-04-16",
"indexname": "DGS7",
"value":    1.4,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-04-17",
"indexname": "DGS7",
"value":   1.38,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-04-18",
"indexname": "DGS7",
"value":   1.37,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-04-19",
"indexname": "DGS7",
"value":   1.38,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-04-22",
"indexname": "DGS7",
"value":   1.34,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-04-23",
"indexname": "DGS7",
"value":   1.37,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-04-24",
"indexname": "DGS7",
"value":   1.38,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-04-25",
"indexname": "DGS7",
"value":   1.36,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-04-26",
"indexname": "DGS7",
"value":   1.34,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-04-29",
"indexname": "DGS7",
"value":   1.33,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-04-30",
"indexname": "DGS7",
"value":   1.35,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-05-01",
"indexname": "DGS7",
"value":   1.33,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-05-02",
"indexname": "DGS7",
"value":   1.34,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-05-03",
"indexname": "DGS7",
"value":   1.28,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-05-06",
"indexname": "DGS7",
"value":   1.29,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-05-07",
"indexname": "DGS7",
"value":   1.26,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-05-08",
"indexname": "DGS7",
"value":   1.26,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-05-09",
"indexname": "DGS7",
"value":   1.28,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-05-10",
"indexname": "DGS7",
"value":   1.24,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-05-13",
"indexname": "DGS7",
"value":    1.2,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-05-14",
"indexname": "DGS7",
"value":   1.19,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-05-15",
"indexname": "DGS7",
"value":   1.19,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-05-16",
"indexname": "DGS7",
"value":   1.16,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-05-17",
"indexname": "DGS7",
"value":   1.16,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-05-20",
"indexname": "DGS7",
"value":   1.18,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-05-21",
"indexname": "DGS7",
"value":    1.2,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-05-22",
"indexname": "DGS7",
"value":   1.15,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-05-23",
"indexname": "DGS7",
"value":    1.2,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-05-24",
"indexname": "DGS7",
"value":   1.17,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-05-28",
"indexname": "DGS7",
"value":   1.17,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-05-29",
"indexname": "DGS7",
"value":   1.06,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-05-30",
"indexname": "DGS7",
"value":   1.03,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-05-31",
"indexname": "DGS7",
"value":   0.93,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-06-03",
"indexname": "DGS7",
"value":   1.01,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-06-04",
"indexname": "DGS7",
"value":   1.04,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-06-05",
"indexname": "DGS7",
"value":   1.11,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-06-06",
"indexname": "DGS7",
"value":    1.1,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-06-07",
"indexname": "DGS7",
"value":   1.09,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-06-10",
"indexname": "DGS7",
"value":   1.05,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-06-11",
"indexname": "DGS7",
"value":   1.12,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-06-12",
"indexname": "DGS7",
"value":   1.06,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-06-13",
"indexname": "DGS7",
"value":    1.1,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-06-14",
"indexname": "DGS7",
"value":   1.06,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-06-17",
"indexname": "DGS7",
"value":   1.06,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-06-18",
"indexname": "DGS7",
"value":   1.09,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-06-19",
"indexname": "DGS7",
"value":   1.12,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-06-20",
"indexname": "DGS7",
"value":    1.1,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-06-21",
"indexname": "DGS7",
"value":   1.15,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-06-24",
"indexname": "DGS7",
"value":    1.1,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-06-25",
"indexname": "DGS7",
"value":   1.12,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-06-26",
"indexname": "DGS7",
"value":    1.1,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-06-27",
"indexname": "DGS7",
"value":   1.06,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-06-28",
"indexname": "DGS7",
"value":   1.11,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-07-01",
"indexname": "DGS7",
"value":   1.04,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-07-02",
"indexname": "DGS7",
"value":   1.08,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-07-04",
"indexname": "DGS7",
"value":   1.05,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-07-05",
"indexname": "DGS7",
"value":   1.01,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-07-08",
"indexname": "DGS7",
"value":   0.98,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-07-09",
"indexname": "DGS7",
"value":   0.98,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-07-10",
"indexname": "DGS7",
"value":   0.99,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-07-11",
"indexname": "DGS7",
"value":   0.98,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-07-12",
"indexname": "DGS7",
"value":   0.99,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-07-15",
"indexname": "DGS7",
"value":   0.97,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-07-16",
"indexname": "DGS7",
"value":   0.99,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-07-17",
"indexname": "DGS7",
"value":   0.97,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-07-18",
"indexname": "DGS7",
"value":   0.99,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-07-19",
"indexname": "DGS7",
"value":   0.95,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-07-22",
"indexname": "DGS7",
"value":   0.93,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-07-23",
"indexname": "DGS7",
"value":   0.91,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-07-24",
"indexname": "DGS7",
"value":   0.91,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-07-25",
"indexname": "DGS7",
"value":   0.94,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-07-26",
"indexname": "DGS7",
"value":   1.04,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-07-29",
"indexname": "DGS7",
"value":   0.99,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-07-30",
"indexname": "DGS7",
"value":   0.98,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-07-31",
"indexname": "DGS7",
"value":   1.03,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-08-01",
"indexname": "DGS7",
"value":   0.98,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-08-02",
"indexname": "DGS7",
"value":   1.07,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-08-05",
"indexname": "DGS7",
"value":   1.05,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-08-06",
"indexname": "DGS7",
"value":   1.13,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-08-07",
"indexname": "DGS7",
"value":   1.14,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-08-08",
"indexname": "DGS7",
"value":   1.15,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-08-09",
"indexname": "DGS7",
"value":   1.11,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-08-12",
"indexname": "DGS7",
"value":   1.12,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-08-13",
"indexname": "DGS7",
"value":   1.18,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-08-14",
"indexname": "DGS7",
"value":   1.25,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-08-15",
"indexname": "DGS7",
"value":   1.28,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-08-16",
"indexname": "DGS7",
"value":   1.27,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-08-19",
"indexname": "DGS7",
"value":   1.26,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-08-20",
"indexname": "DGS7",
"value":   1.25,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-08-21",
"indexname": "DGS7",
"value":   1.16,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-08-22",
"indexname": "DGS7",
"value":   1.13,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-08-23",
"indexname": "DGS7",
"value":   1.14,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-08-26",
"indexname": "DGS7",
"value":   1.11,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-08-27",
"indexname": "DGS7",
"value":    1.1,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-08-28",
"indexname": "DGS7",
"value":   1.11,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-08-29",
"indexname": "DGS7",
"value":   1.08,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-08-30",
"indexname": "DGS7",
"value":   1.01,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-09-03",
"indexname": "DGS7",
"value":   1.03,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-09-04",
"indexname": "DGS7",
"value":   1.04,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-09-05",
"indexname": "DGS7",
"value":   1.12,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-09-06",
"indexname": "DGS7",
"value":   1.09,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-09-09",
"indexname": "DGS7",
"value":    1.1,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-09-10",
"indexname": "DGS7",
"value":   1.12,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-09-11",
"indexname": "DGS7",
"value":   1.17,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-09-12",
"indexname": "DGS7",
"value":   1.12,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-09-13",
"indexname": "DGS7",
"value":   1.23,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-09-16",
"indexname": "DGS7",
"value":   1.22,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-09-17",
"indexname": "DGS7",
"value":   1.19,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-09-18",
"indexname": "DGS7",
"value":   1.18,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-09-19",
"indexname": "DGS7",
"value":   1.18,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-09-20",
"indexname": "DGS7",
"value":   1.14,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-09-23",
"indexname": "DGS7",
"value":   1.12,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-09-24",
"indexname": "DGS7",
"value":   1.08,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-09-25",
"indexname": "DGS7",
"value":   1.03,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-09-26",
"indexname": "DGS7",
"value":   1.05,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-09-27",
"indexname": "DGS7",
"value":   1.04,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-09-30",
"indexname": "DGS7",
"value":   1.04,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-10-01",
"indexname": "DGS7",
"value":   1.03,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-10-02",
"indexname": "DGS7",
"value":   1.02,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-10-03",
"indexname": "DGS7",
"value":   1.07,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-10-04",
"indexname": "DGS7",
"value":   1.12,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-10-08",
"indexname": "DGS7",
"value":   1.11,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-10-09",
"indexname": "DGS7",
"value":   1.09,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-10-10",
"indexname": "DGS7",
"value":   1.09,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-10-11",
"indexname": "DGS7",
"value":   1.09,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-10-14",
"indexname": "DGS7",
"value":   1.09,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-10-15",
"indexname": "DGS7",
"value":   1.15,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-10-16",
"indexname": "DGS7",
"value":   1.24,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-10-17",
"indexname": "DGS7",
"value":   1.26,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-10-18",
"indexname": "DGS7",
"value":   1.21,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-10-21",
"indexname": "DGS7",
"value":   1.25,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-10-22",
"indexname": "DGS7",
"value":   1.21,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-10-23",
"indexname": "DGS7",
"value":   1.21,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-10-24",
"indexname": "DGS7",
"value":   1.28,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-10-25",
"indexname": "DGS7",
"value":    1.2,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-10-28",
"indexname": "DGS7",
"value":   1.16,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-10-30",
"indexname": "DGS7",
"value":   1.14,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-10-31",
"indexname": "DGS7",
"value":   1.16,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-11-01",
"indexname": "DGS7",
"value":   1.16,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-11-04",
"indexname": "DGS7",
"value":   1.13,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-11-05",
"indexname": "DGS7",
"value":   1.19,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-11-06",
"indexname": "DGS7",
"value":   1.08,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-11-07",
"indexname": "DGS7",
"value":   1.04,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-11-08",
"indexname": "DGS7",
"value":   1.04,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-11-12",
"indexname": "DGS7",
"value":   1.02,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-11-13",
"indexname": "DGS7",
"value":   1.03,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-11-14",
"indexname": "DGS7",
"value":   1.02,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-11-15",
"indexname": "DGS7",
"value":   1.01,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-11-18",
"indexname": "DGS7",
"value":   1.04,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-11-19",
"indexname": "DGS7",
"value":   1.09,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-11-20",
"indexname": "DGS7",
"value":   1.11,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-11-22",
"indexname": "DGS7",
"value":   1.12,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-11-25",
"indexname": "DGS7",
"value":   1.09,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-11-26",
"indexname": "DGS7",
"value":   1.07,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-11-27",
"indexname": "DGS7",
"value":   1.05,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-11-28",
"indexname": "DGS7",
"value":   1.04,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-11-29",
"indexname": "DGS7",
"value":   1.04,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-12-02",
"indexname": "DGS7",
"value":   1.05,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-12-03",
"indexname": "DGS7",
"value":   1.04,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-12-04",
"indexname": "DGS7",
"value":   1.02,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-12-05",
"indexname": "DGS7",
"value":      1,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-12-06",
"indexname": "DGS7",
"value":   1.04,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-12-09",
"indexname": "DGS7",
"value":   1.04,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-12-10",
"indexname": "DGS7",
"value":   1.06,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-12-11",
"indexname": "DGS7",
"value":   1.11,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-12-12",
"indexname": "DGS7",
"value":   1.15,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-12-13",
"indexname": "DGS7",
"value":   1.15,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-12-16",
"indexname": "DGS7",
"value":    1.2,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-12-17",
"indexname": "DGS7",
"value":   1.25,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-12-18",
"indexname": "DGS7",
"value":   1.24,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-12-19",
"indexname": "DGS7",
"value":   1.24,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-12-20",
"indexname": "DGS7",
"value":    1.2,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-12-23",
"indexname": "DGS7",
"value":   1.22,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-12-25",
"indexname": "DGS7",
"value":    1.2,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-12-26",
"indexname": "DGS7",
"value":   1.15,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-12-27",
"indexname": "DGS7",
"value":   1.15,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-12-30",
"indexname": "DGS7",
"value":   1.18,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-01-01",
"indexname": "DGS7",
"value":   1.25,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-01-02",
"indexname": "DGS7",
"value":   1.31,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-01-03",
"indexname": "DGS7",
"value":   1.32,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-01-06",
"indexname": "DGS7",
"value":   1.31,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-01-07",
"indexname": "DGS7",
"value":   1.28,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-01-08",
"indexname": "DGS7",
"value":   1.27,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-01-09",
"indexname": "DGS7",
"value":    1.3,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-01-10",
"indexname": "DGS7",
"value":   1.28,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-01-13",
"indexname": "DGS7",
"value":   1.27,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-01-14",
"indexname": "DGS7",
"value":   1.24,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-01-15",
"indexname": "DGS7",
"value":   1.23,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-01-16",
"indexname": "DGS7",
"value":   1.29,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-01-17",
"indexname": "DGS7",
"value":   1.26,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-01-21",
"indexname": "DGS7",
"value":   1.25,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-01-22",
"indexname": "DGS7",
"value":   1.24,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-01-23",
"indexname": "DGS7",
"value":   1.26,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-01-24",
"indexname": "DGS7",
"value":   1.36,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-01-27",
"indexname": "DGS7",
"value":   1.38,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-01-28",
"indexname": "DGS7",
"value":    1.4,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-01-29",
"indexname": "DGS7",
"value":   1.39,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-01-30",
"indexname": "DGS7",
"value":   1.38,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-01-31",
"indexname": "DGS7",
"value":    1.4,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-02-03",
"indexname": "DGS7",
"value":   1.36,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-02-04",
"indexname": "DGS7",
"value":   1.39,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-02-05",
"indexname": "DGS7",
"value":   1.35,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-02-06",
"indexname": "DGS7",
"value":   1.34,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-02-07",
"indexname": "DGS7",
"value":   1.34,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-02-10",
"indexname": "DGS7",
"value":   1.35,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-02-11",
"indexname": "DGS7",
"value":   1.38,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-02-12",
"indexname": "DGS7",
"value":   1.43,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-02-13",
"indexname": "DGS7",
"value":   1.37,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-02-14",
"indexname": "DGS7",
"value":   1.38,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-02-18",
"indexname": "DGS7",
"value":   1.41,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-02-19",
"indexname": "DGS7",
"value":   1.38,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-02-20",
"indexname": "DGS7",
"value":   1.36,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-02-21",
"indexname": "DGS7",
"value":   1.34,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-02-24",
"indexname": "DGS7",
"value":   1.25,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-02-25",
"indexname": "DGS7",
"value":   1.25,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-02-26",
"indexname": "DGS7",
"value":   1.28,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-02-27",
"indexname": "DGS7",
"value":   1.26,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-02-28",
"indexname": "DGS7",
"value":   1.23,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-03-03",
"indexname": "DGS7",
"value":   1.25,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-03-04",
"indexname": "DGS7",
"value":   1.27,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-03-05",
"indexname": "DGS7",
"value":   1.31,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-03-06",
"indexname": "DGS7",
"value":   1.36,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-03-07",
"indexname": "DGS7",
"value":   1.43,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-03-10",
"indexname": "DGS7",
"value":   1.43,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-03-11",
"indexname": "DGS7",
"value":    1.4,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-03-12",
"indexname": "DGS7",
"value":   1.41,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-03-13",
"indexname": "DGS7",
"value":    1.4,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-03-14",
"indexname": "DGS7",
"value":   1.35,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-03-17",
"indexname": "DGS7",
"value":   1.31,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-03-18",
"indexname": "DGS7",
"value":   1.28,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-03-19",
"indexname": "DGS7",
"value":   1.32,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-03-20",
"indexname": "DGS7",
"value":    1.3,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-03-21",
"indexname": "DGS7",
"value":   1.29,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-03-24",
"indexname": "DGS7",
"value":   1.28,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-03-25",
"indexname": "DGS7",
"value":   1.27,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-03-26",
"indexname": "DGS7",
"value":   1.22,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-03-27",
"indexname": "DGS7",
"value":   1.24,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-03-31",
"indexname": "DGS7",
"value":   1.23,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-04-01",
"indexname": "DGS7",
"value":   1.26,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-04-02",
"indexname": "DGS7",
"value":    1.2,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-04-03",
"indexname": "DGS7",
"value":   1.15,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-04-04",
"indexname": "DGS7",
"value":   1.12,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-04-07",
"indexname": "DGS7",
"value":   1.15,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-04-08",
"indexname": "DGS7",
"value":   1.16,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-04-09",
"indexname": "DGS7",
"value":   1.21,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-04-10",
"indexname": "DGS7",
"value":    1.2,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-04-11",
"indexname": "DGS7",
"value":   1.14,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-04-14",
"indexname": "DGS7",
"value":   1.12,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-04-15",
"indexname": "DGS7",
"value":   1.15,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-04-16",
"indexname": "DGS7",
"value":   1.13,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-04-17",
"indexname": "DGS7",
"value":   1.13,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-04-18",
"indexname": "DGS7",
"value":   1.14,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-04-21",
"indexname": "DGS7",
"value":   1.13,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-04-22",
"indexname": "DGS7",
"value":   1.14,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-04-23",
"indexname": "DGS7",
"value":   1.13,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-04-24",
"indexname": "DGS7",
"value":   1.15,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-04-25",
"indexname": "DGS7",
"value":    1.1,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-04-28",
"indexname": "DGS7",
"value":    1.1,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-04-29",
"indexname": "DGS7",
"value":   1.11,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-04-30",
"indexname": "DGS7",
"value":   1.07,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-05-01",
"indexname": "DGS7",
"value":   1.07,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-05-02",
"indexname": "DGS7",
"value":   1.17,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-05-05",
"indexname": "DGS7",
"value":   1.19,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-05-06",
"indexname": "DGS7",
"value":   1.21,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-05-07",
"indexname": "DGS7",
"value":    1.2,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-05-08",
"indexname": "DGS7",
"value":    1.2,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-05-09",
"indexname": "DGS7",
"value":   1.28,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-05-12",
"indexname": "DGS7",
"value":    1.3,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-05-13",
"indexname": "DGS7",
"value":   1.33,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-05-14",
"indexname": "DGS7",
"value":   1.32,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-05-15",
"indexname": "DGS7",
"value":   1.25,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-05-16",
"indexname": "DGS7",
"value":   1.32,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-05-19",
"indexname": "DGS7",
"value":   1.33,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-05-20",
"indexname": "DGS7",
"value":   1.31,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-05-21",
"indexname": "DGS7",
"value":    1.4,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-05-22",
"indexname": "DGS7",
"value":    1.4,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-05-23",
"indexname": "DGS7",
"value":   1.39,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-05-27",
"indexname": "DGS7",
"value":   1.53,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-05-28",
"indexname": "DGS7",
"value":   1.51,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-05-29",
"indexname": "DGS7",
"value":   1.51,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-05-30",
"indexname": "DGS7",
"value":   1.55,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-06-02",
"indexname": "DGS7",
"value":   1.53,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-06-03",
"indexname": "DGS7",
"value":   1.55,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-06-04",
"indexname": "DGS7",
"value":   1.52,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-06-05",
"indexname": "DGS7",
"value":   1.49,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-06-06",
"indexname": "DGS7",
"value":   1.59,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-06-09",
"indexname": "DGS7",
"value":   1.62,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-06-10",
"indexname": "DGS7",
"value":   1.61,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-06-11",
"indexname": "DGS7",
"value":   1.64,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-06-12",
"indexname": "DGS7",
"value":    1.6,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-06-13",
"indexname": "DGS7",
"value":   1.53,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-06-16",
"indexname": "DGS7",
"value":   1.57,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-06-17",
"indexname": "DGS7",
"value":   1.58,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-06-18",
"indexname": "DGS7",
"value":   1.76,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-06-19",
"indexname": "DGS7",
"value":   1.84,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-06-20",
"indexname": "DGS7",
"value":   1.95,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-06-23",
"indexname": "DGS7",
"value":   2.02,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-06-24",
"indexname": "DGS7",
"value":   2.03,
"maturity":      7,
"country": "US" 
},
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
},
{
 "date": "2013-06-24",
"indexname": "DGS10",
"value":    2.6,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-01-02",
"indexname": "DGS20",
"value":   2.67,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-01-03",
"indexname": "DGS20",
"value":   2.71,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-01-04",
"indexname": "DGS20",
"value":   2.74,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-01-05",
"indexname": "DGS20",
"value":    2.7,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-01-08",
"indexname": "DGS20",
"value":    2.7,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-01-09",
"indexname": "DGS20",
"value":   2.71,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-01-10",
"indexname": "DGS20",
"value":   2.63,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-01-11",
"indexname": "DGS20",
"value":   2.65,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-01-12",
"indexname": "DGS20",
"value":   2.59,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-01-16",
"indexname": "DGS20",
"value":   2.57,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-01-17",
"indexname": "DGS20",
"value":   2.63,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-01-18",
"indexname": "DGS20",
"value":   2.72,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-01-19",
"indexname": "DGS20",
"value":   2.78,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-01-22",
"indexname": "DGS20",
"value":   2.82,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-01-23",
"indexname": "DGS20",
"value":   2.82,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-01-24",
"indexname": "DGS20",
"value":   2.78,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-01-25",
"indexname": "DGS20",
"value":   2.74,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-01-26",
"indexname": "DGS20",
"value":   2.71,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-01-29",
"indexname": "DGS20",
"value":   2.64,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-01-30",
"indexname": "DGS20",
"value":   2.59,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-01-31",
"indexname": "DGS20",
"value":   2.65,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-02-01",
"indexname": "DGS20",
"value":   2.64,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-02-02",
"indexname": "DGS20",
"value":   2.76,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-02-05",
"indexname": "DGS20",
"value":   2.71,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-02-06",
"indexname": "DGS20",
"value":   2.78,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-02-07",
"indexname": "DGS20",
"value":   2.78,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-02-08",
"indexname": "DGS20",
"value":   2.83,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-02-09",
"indexname": "DGS20",
"value":   2.75,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-02-12",
"indexname": "DGS20",
"value":   2.78,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-02-13",
"indexname": "DGS20",
"value":    2.7,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-02-14",
"indexname": "DGS20",
"value":   2.72,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-02-15",
"indexname": "DGS20",
"value":   2.78,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-02-16",
"indexname": "DGS20",
"value":    2.8,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-02-20",
"indexname": "DGS20",
"value":   2.84,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-02-21",
"indexname": "DGS20",
"value":   2.79,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-02-22",
"indexname": "DGS20",
"value":   2.77,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-02-23",
"indexname": "DGS20",
"value":   2.75,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-02-26",
"indexname": "DGS20",
"value":   2.69,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-02-27",
"indexname": "DGS20",
"value":   2.71,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-02-28",
"indexname": "DGS20",
"value":   2.73,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-02-29",
"indexname": "DGS20",
"value":    2.8,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-03-01",
"indexname": "DGS20",
"value":   2.77,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-03-04",
"indexname": "DGS20",
"value":   2.78,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-03-05",
"indexname": "DGS20",
"value":   2.73,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-03-06",
"indexname": "DGS20",
"value":   2.76,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-03-07",
"indexname": "DGS20",
"value":   2.82,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-03-08",
"indexname": "DGS20",
"value":   2.83,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-03-11",
"indexname": "DGS20",
"value":   2.82,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-03-12",
"indexname": "DGS20",
"value":   2.92,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-03-13",
"indexname": "DGS20",
"value":   3.08,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-03-14",
"indexname": "DGS20",
"value":   3.08,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-03-15",
"indexname": "DGS20",
"value":   3.08,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-03-18",
"indexname": "DGS20",
"value":   3.14,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-03-19",
"indexname": "DGS20",
"value":   3.13,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-03-20",
"indexname": "DGS20",
"value":   3.06,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-03-21",
"indexname": "DGS20",
"value":   3.04,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-03-22",
"indexname": "DGS20",
"value":   2.99,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-03-25",
"indexname": "DGS20",
"value":      3,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-03-26",
"indexname": "DGS20",
"value":   2.96,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-03-27",
"indexname": "DGS20",
"value":   2.97,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-03-28",
"indexname": "DGS20",
"value":   2.93,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-03-29",
"indexname": "DGS20",
"value":      3,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-04-01",
"indexname": "DGS20",
"value":      3,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-04-02",
"indexname": "DGS20",
"value":   3.07,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-04-03",
"indexname": "DGS20",
"value":   3.02,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-04-04",
"indexname": "DGS20",
"value":   2.97,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-04-05",
"indexname": "DGS20",
"value":   2.85,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-04-08",
"indexname": "DGS20",
"value":   2.82,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-04-09",
"indexname": "DGS20",
"value":   2.77,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-04-10",
"indexname": "DGS20",
"value":   2.82,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-04-11",
"indexname": "DGS20",
"value":   2.85,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-04-12",
"indexname": "DGS20",
"value":   2.77,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-04-15",
"indexname": "DGS20",
"value":   2.75,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-04-16",
"indexname": "DGS20",
"value":   2.79,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-04-17",
"indexname": "DGS20",
"value":   2.76,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-04-18",
"indexname": "DGS20",
"value":   2.74,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-04-19",
"indexname": "DGS20",
"value":   2.75,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-04-22",
"indexname": "DGS20",
"value":   2.71,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-04-23",
"indexname": "DGS20",
"value":   2.75,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-04-24",
"indexname": "DGS20",
"value":   2.76,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-04-25",
"indexname": "DGS20",
"value":   2.74,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-04-26",
"indexname": "DGS20",
"value":   2.73,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-04-29",
"indexname": "DGS20",
"value":   2.73,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-04-30",
"indexname": "DGS20",
"value":   2.76,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-05-01",
"indexname": "DGS20",
"value":   2.72,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-05-02",
"indexname": "DGS20",
"value":   2.72,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-05-03",
"indexname": "DGS20",
"value":   2.67,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-05-06",
"indexname": "DGS20",
"value":   2.67,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-05-07",
"indexname": "DGS20",
"value":   2.63,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-05-08",
"indexname": "DGS20",
"value":   2.63,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-05-09",
"indexname": "DGS20",
"value":   2.64,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-05-10",
"indexname": "DGS20",
"value":   2.59,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-05-13",
"indexname": "DGS20",
"value":   2.53,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-05-14",
"indexname": "DGS20",
"value":    2.5,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-05-15",
"indexname": "DGS20",
"value":   2.48,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-05-16",
"indexname": "DGS20",
"value":   2.39,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-05-17",
"indexname": "DGS20",
"value":    2.4,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-05-20",
"indexname": "DGS20",
"value":   2.42,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-05-21",
"indexname": "DGS20",
"value":   2.48,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-05-22",
"indexname": "DGS20",
"value":   2.41,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-05-23",
"indexname": "DGS20",
"value":   2.46,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-05-24",
"indexname": "DGS20",
"value":   2.44,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-05-28",
"indexname": "DGS20",
"value":   2.44,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-05-29",
"indexname": "DGS20",
"value":   2.32,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-05-30",
"indexname": "DGS20",
"value":   2.27,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-05-31",
"indexname": "DGS20",
"value":   2.13,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-06-03",
"indexname": "DGS20",
"value":   2.17,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-06-04",
"indexname": "DGS20",
"value":   2.23,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-06-05",
"indexname": "DGS20",
"value":   2.34,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-06-06",
"indexname": "DGS20",
"value":   2.35,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-06-07",
"indexname": "DGS20",
"value":   2.36,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-06-10",
"indexname": "DGS20",
"value":    2.3,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-06-11",
"indexname": "DGS20",
"value":   2.37,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-06-12",
"indexname": "DGS20",
"value":    2.3,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-06-13",
"indexname": "DGS20",
"value":   2.33,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-06-14",
"indexname": "DGS20",
"value":    2.3,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-06-17",
"indexname": "DGS20",
"value":   2.28,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-06-18",
"indexname": "DGS20",
"value":   2.33,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-06-19",
"indexname": "DGS20",
"value":   2.34,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-06-20",
"indexname": "DGS20",
"value":    2.3,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-06-21",
"indexname": "DGS20",
"value":   2.37,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-06-24",
"indexname": "DGS20",
"value":   2.31,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-06-25",
"indexname": "DGS20",
"value":   2.34,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-06-26",
"indexname": "DGS20",
"value":   2.32,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-06-27",
"indexname": "DGS20",
"value":   2.28,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-06-28",
"indexname": "DGS20",
"value":   2.38,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-07-01",
"indexname": "DGS20",
"value":    2.3,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-07-02",
"indexname": "DGS20",
"value":   2.36,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-07-04",
"indexname": "DGS20",
"value":   2.34,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-07-05",
"indexname": "DGS20",
"value":   2.28,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-07-08",
"indexname": "DGS20",
"value":   2.24,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-07-09",
"indexname": "DGS20",
"value":   2.22,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-07-10",
"indexname": "DGS20",
"value":   2.22,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-07-11",
"indexname": "DGS20",
"value":   2.18,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-07-12",
"indexname": "DGS20",
"value":    2.2,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-07-15",
"indexname": "DGS20",
"value":   2.18,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-07-16",
"indexname": "DGS20",
"value":   2.22,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-07-17",
"indexname": "DGS20",
"value":   2.21,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-07-18",
"indexname": "DGS20",
"value":   2.24,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-07-19",
"indexname": "DGS20",
"value":   2.17,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-07-22",
"indexname": "DGS20",
"value":   2.15,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-07-23",
"indexname": "DGS20",
"value":   2.11,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-07-24",
"indexname": "DGS20",
"value":   2.11,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-07-25",
"indexname": "DGS20",
"value":   2.13,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-07-26",
"indexname": "DGS20",
"value":   2.27,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-07-29",
"indexname": "DGS20",
"value":   2.22,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-07-30",
"indexname": "DGS20",
"value":   2.21,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-07-31",
"indexname": "DGS20",
"value":   2.25,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-08-01",
"indexname": "DGS20",
"value":    2.2,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-08-02",
"indexname": "DGS20",
"value":    2.3,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-08-05",
"indexname": "DGS20",
"value":   2.29,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-08-06",
"indexname": "DGS20",
"value":   2.37,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-08-07",
"indexname": "DGS20",
"value":   2.39,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-08-08",
"indexname": "DGS20",
"value":    2.4,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-08-09",
"indexname": "DGS20",
"value":   2.37,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-08-12",
"indexname": "DGS20",
"value":   2.37,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-08-13",
"indexname": "DGS20",
"value":   2.45,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-08-14",
"indexname": "DGS20",
"value":   2.53,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-08-15",
"indexname": "DGS20",
"value":   2.57,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-08-16",
"indexname": "DGS20",
"value":   2.55,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-08-19",
"indexname": "DGS20",
"value":   2.55,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-08-20",
"indexname": "DGS20",
"value":   2.53,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-08-21",
"indexname": "DGS20",
"value":   2.44,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-08-22",
"indexname": "DGS20",
"value":   2.41,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-08-23",
"indexname": "DGS20",
"value":   2.41,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-08-26",
"indexname": "DGS20",
"value":   2.38,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-08-27",
"indexname": "DGS20",
"value":   2.36,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-08-28",
"indexname": "DGS20",
"value":   2.38,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-08-29",
"indexname": "DGS20",
"value":   2.36,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-08-30",
"indexname": "DGS20",
"value":   2.29,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-09-03",
"indexname": "DGS20",
"value":    2.3,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-09-04",
"indexname": "DGS20",
"value":   2.32,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-09-05",
"indexname": "DGS20",
"value":   2.41,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-09-06",
"indexname": "DGS20",
"value":   2.42,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-09-09",
"indexname": "DGS20",
"value":   2.43,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-09-10",
"indexname": "DGS20",
"value":   2.44,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-09-11",
"indexname": "DGS20",
"value":   2.52,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-09-12",
"indexname": "DGS20",
"value":   2.53,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-09-13",
"indexname": "DGS20",
"value":   2.68,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-09-16",
"indexname": "DGS20",
"value":   2.64,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-09-17",
"indexname": "DGS20",
"value":   2.61,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-09-18",
"indexname": "DGS20",
"value":   2.58,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-09-19",
"indexname": "DGS20",
"value":   2.58,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-09-20",
"indexname": "DGS20",
"value":   2.57,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-09-23",
"indexname": "DGS20",
"value":   2.53,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-09-24",
"indexname": "DGS20",
"value":   2.47,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-09-25",
"indexname": "DGS20",
"value":    2.4,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-09-26",
"indexname": "DGS20",
"value":   2.43,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-09-27",
"indexname": "DGS20",
"value":   2.42,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-09-30",
"indexname": "DGS20",
"value":   2.41,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-10-01",
"indexname": "DGS20",
"value":   2.41,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-10-02",
"indexname": "DGS20",
"value":   2.42,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-10-03",
"indexname": "DGS20",
"value":   2.48,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-10-04",
"indexname": "DGS20",
"value":   2.55,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-10-08",
"indexname": "DGS20",
"value":   2.52,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-10-09",
"indexname": "DGS20",
"value":   2.48,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-10-10",
"indexname": "DGS20",
"value":   2.45,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-10-11",
"indexname": "DGS20",
"value":   2.44,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-10-14",
"indexname": "DGS20",
"value":   2.45,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-10-15",
"indexname": "DGS20",
"value":   2.51,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-10-16",
"indexname": "DGS20",
"value":    2.6,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-10-17",
"indexname": "DGS20",
"value":   2.63,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-10-18",
"indexname": "DGS20",
"value":   2.55,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-10-21",
"indexname": "DGS20",
"value":   2.57,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-10-22",
"indexname": "DGS20",
"value":   2.53,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-10-23",
"indexname": "DGS20",
"value":   2.55,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-10-24",
"indexname": "DGS20",
"value":    2.6,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-10-25",
"indexname": "DGS20",
"value":   2.53,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-10-28",
"indexname": "DGS20",
"value":   2.48,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-10-30",
"indexname": "DGS20",
"value":   2.46,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-10-31",
"indexname": "DGS20",
"value":    2.5,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-11-01",
"indexname": "DGS20",
"value":   2.51,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-11-04",
"indexname": "DGS20",
"value":   2.47,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-11-05",
"indexname": "DGS20",
"value":   2.52,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-11-06",
"indexname": "DGS20",
"value":   2.42,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-11-07",
"indexname": "DGS20",
"value":   2.35,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-11-08",
"indexname": "DGS20",
"value":   2.34,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-11-12",
"indexname": "DGS20",
"value":   2.31,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-11-13",
"indexname": "DGS20",
"value":   2.31,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-11-14",
"indexname": "DGS20",
"value":    2.3,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-11-15",
"indexname": "DGS20",
"value":   2.31,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-11-18",
"indexname": "DGS20",
"value":   2.34,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-11-19",
"indexname": "DGS20",
"value":    2.4,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-11-20",
"indexname": "DGS20",
"value":   2.42,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-11-22",
"indexname": "DGS20",
"value":   2.42,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-11-25",
"indexname": "DGS20",
"value":   2.39,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-11-26",
"indexname": "DGS20",
"value":   2.38,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-11-27",
"indexname": "DGS20",
"value":   2.36,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-11-28",
"indexname": "DGS20",
"value":   2.37,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-11-29",
"indexname": "DGS20",
"value":   2.37,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-12-02",
"indexname": "DGS20",
"value":   2.37,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-12-03",
"indexname": "DGS20",
"value":   2.36,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-12-04",
"indexname": "DGS20",
"value":   2.35,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-12-05",
"indexname": "DGS20",
"value":   2.33,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-12-06",
"indexname": "DGS20",
"value":   2.39,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-12-09",
"indexname": "DGS20",
"value":   2.38,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-12-10",
"indexname": "DGS20",
"value":   2.41,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-12-11",
"indexname": "DGS20",
"value":   2.48,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-12-12",
"indexname": "DGS20",
"value":   2.49,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-12-13",
"indexname": "DGS20",
"value":   2.46,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-12-16",
"indexname": "DGS20",
"value":   2.53,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-12-17",
"indexname": "DGS20",
"value":   2.59,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-12-18",
"indexname": "DGS20",
"value":   2.58,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-12-19",
"indexname": "DGS20",
"value":   2.57,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-12-20",
"indexname": "DGS20",
"value":   2.52,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-12-23",
"indexname": "DGS20",
"value":   2.53,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-12-25",
"indexname": "DGS20",
"value":   2.52,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-12-26",
"indexname": "DGS20",
"value":   2.48,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-12-27",
"indexname": "DGS20",
"value":   2.47,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-12-30",
"indexname": "DGS20",
"value":   2.54,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-01-01",
"indexname": "DGS20",
"value":   2.63,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-01-02",
"indexname": "DGS20",
"value":    2.7,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-01-03",
"indexname": "DGS20",
"value":    2.7,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-01-06",
"indexname": "DGS20",
"value":    2.7,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-01-07",
"indexname": "DGS20",
"value":   2.66,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-01-08",
"indexname": "DGS20",
"value":   2.65,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-01-09",
"indexname": "DGS20",
"value":   2.68,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-01-10",
"indexname": "DGS20",
"value":   2.65,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-01-13",
"indexname": "DGS20",
"value":   2.65,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-01-14",
"indexname": "DGS20",
"value":   2.62,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-01-15",
"indexname": "DGS20",
"value":   2.61,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-01-16",
"indexname": "DGS20",
"value":   2.66,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-01-17",
"indexname": "DGS20",
"value":   2.63,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-01-21",
"indexname": "DGS20",
"value":   2.62,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-01-22",
"indexname": "DGS20",
"value":   2.62,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-01-23",
"indexname": "DGS20",
"value":   2.64,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-01-24",
"indexname": "DGS20",
"value":   2.75,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-01-27",
"indexname": "DGS20",
"value":   2.76,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-01-28",
"indexname": "DGS20",
"value":   2.79,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-01-29",
"indexname": "DGS20",
"value":    2.8,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-01-30",
"indexname": "DGS20",
"value":   2.79,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-01-31",
"indexname": "DGS20",
"value":   2.83,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-02-03",
"indexname": "DGS20",
"value":   2.79,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-02-04",
"indexname": "DGS20",
"value":   2.83,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-02-05",
"indexname": "DGS20",
"value":   2.79,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-02-06",
"indexname": "DGS20",
"value":   2.78,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-02-07",
"indexname": "DGS20",
"value":   2.79,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-02-10",
"indexname": "DGS20",
"value":   2.78,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-02-11",
"indexname": "DGS20",
"value":   2.81,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-02-12",
"indexname": "DGS20",
"value":   2.86,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-02-13",
"indexname": "DGS20",
"value":   2.79,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-02-14",
"indexname": "DGS20",
"value":    2.8,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-02-18",
"indexname": "DGS20",
"value":   2.83,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-02-19",
"indexname": "DGS20",
"value":   2.82,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-02-20",
"indexname": "DGS20",
"value":   2.79,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-02-21",
"indexname": "DGS20",
"value":   2.77,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-02-24",
"indexname": "DGS20",
"value":   2.69,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-02-25",
"indexname": "DGS20",
"value":   2.69,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-02-26",
"indexname": "DGS20",
"value":   2.72,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-02-27",
"indexname": "DGS20",
"value":   2.71,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-02-28",
"indexname": "DGS20",
"value":   2.68,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-03-03",
"indexname": "DGS20",
"value":    2.7,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-03-04",
"indexname": "DGS20",
"value":   2.72,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-03-05",
"indexname": "DGS20",
"value":   2.77,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-03-06",
"indexname": "DGS20",
"value":   2.82,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-03-07",
"indexname": "DGS20",
"value":   2.89,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-03-10",
"indexname": "DGS20",
"value":   2.89,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-03-11",
"indexname": "DGS20",
"value":   2.85,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-03-12",
"indexname": "DGS20",
"value":   2.85,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-03-13",
"indexname": "DGS20",
"value":   2.87,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-03-14",
"indexname": "DGS20",
"value":   2.85,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-03-17",
"indexname": "DGS20",
"value":   2.79,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-03-18",
"indexname": "DGS20",
"value":   2.75,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-03-19",
"indexname": "DGS20",
"value":    2.8,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-03-20",
"indexname": "DGS20",
"value":   2.77,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-03-21",
"indexname": "DGS20",
"value":   2.75,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-03-24",
"indexname": "DGS20",
"value":   2.76,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-03-25",
"indexname": "DGS20",
"value":   2.75,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-03-26",
"indexname": "DGS20",
"value":   2.71,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-03-27",
"indexname": "DGS20",
"value":   2.71,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-03-31",
"indexname": "DGS20",
"value":    2.7,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-04-01",
"indexname": "DGS20",
"value":   2.72,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-04-02",
"indexname": "DGS20",
"value":   2.66,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-04-03",
"indexname": "DGS20",
"value":    2.6,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-04-04",
"indexname": "DGS20",
"value":    2.5,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-04-07",
"indexname": "DGS20",
"value":   2.54,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-04-08",
"indexname": "DGS20",
"value":   2.57,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-04-09",
"indexname": "DGS20",
"value":   2.63,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-04-10",
"indexname": "DGS20",
"value":   2.62,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-04-11",
"indexname": "DGS20",
"value":   2.54,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-04-14",
"indexname": "DGS20",
"value":    2.5,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-04-15",
"indexname": "DGS20",
"value":   2.53,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-04-16",
"indexname": "DGS20",
"value":   2.51,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-04-17",
"indexname": "DGS20",
"value":   2.49,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-04-18",
"indexname": "DGS20",
"value":    2.5,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-04-21",
"indexname": "DGS20",
"value":    2.5,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-04-22",
"indexname": "DGS20",
"value":   2.52,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-04-23",
"indexname": "DGS20",
"value":    2.5,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-04-24",
"indexname": "DGS20",
"value":   2.52,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-04-25",
"indexname": "DGS20",
"value":   2.47,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-04-28",
"indexname": "DGS20",
"value":   2.49,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-04-29",
"indexname": "DGS20",
"value":   2.49,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-04-30",
"indexname": "DGS20",
"value":   2.44,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-05-01",
"indexname": "DGS20",
"value":   2.44,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-05-02",
"indexname": "DGS20",
"value":   2.58,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-05-05",
"indexname": "DGS20",
"value":    2.6,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-05-06",
"indexname": "DGS20",
"value":   2.62,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-05-07",
"indexname": "DGS20",
"value":   2.61,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-05-08",
"indexname": "DGS20",
"value":    2.6,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-05-09",
"indexname": "DGS20",
"value":    2.7,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-05-12",
"indexname": "DGS20",
"value":   2.73,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-05-13",
"indexname": "DGS20",
"value":   2.77,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-05-14",
"indexname": "DGS20",
"value":   2.76,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-05-15",
"indexname": "DGS20",
"value":   2.69,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-05-16",
"indexname": "DGS20",
"value":   2.77,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-05-19",
"indexname": "DGS20",
"value":   2.79,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-05-20",
"indexname": "DGS20",
"value":   2.75,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-05-21",
"indexname": "DGS20",
"value":   2.83,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-05-22",
"indexname": "DGS20",
"value":   2.82,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-05-23",
"indexname": "DGS20",
"value":    2.8,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-05-27",
"indexname": "DGS20",
"value":   2.95,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-05-28",
"indexname": "DGS20",
"value":   2.91,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-05-29",
"indexname": "DGS20",
"value":   2.92,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-05-30",
"indexname": "DGS20",
"value":   2.95,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-06-02",
"indexname": "DGS20",
"value":   2.92,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-06-03",
"indexname": "DGS20",
"value":   2.95,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-06-04",
"indexname": "DGS20",
"value":    2.9,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-06-05",
"indexname": "DGS20",
"value":   2.89,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-06-06",
"indexname": "DGS20",
"value":   2.98,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-06-09",
"indexname": "DGS20",
"value":   3.03,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-06-10",
"indexname": "DGS20",
"value":      3,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-06-11",
"indexname": "DGS20",
"value":   3.04,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-06-12",
"indexname": "DGS20",
"value":   2.99,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-06-13",
"indexname": "DGS20",
"value":   2.95,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-06-16",
"indexname": "DGS20",
"value":   3.01,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-06-17",
"indexname": "DGS20",
"value":      3,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-06-18",
"indexname": "DGS20",
"value":   3.09,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-06-19",
"indexname": "DGS20",
"value":   3.18,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-06-20",
"indexname": "DGS20",
"value":   3.26,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-06-23",
"indexname": "DGS20",
"value":   3.27,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-06-24",
"indexname": "DGS20",
"value":   3.31,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-01-02",
"indexname": "DGS30",
"value":   2.98,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-01-03",
"indexname": "DGS30",
"value":   3.03,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-01-04",
"indexname": "DGS30",
"value":   3.06,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-01-05",
"indexname": "DGS30",
"value":   3.02,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-01-08",
"indexname": "DGS30",
"value":   3.02,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-01-09",
"indexname": "DGS30",
"value":   3.04,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-01-10",
"indexname": "DGS30",
"value":   2.96,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-01-11",
"indexname": "DGS30",
"value":   2.97,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-01-12",
"indexname": "DGS30",
"value":   2.91,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-01-16",
"indexname": "DGS30",
"value":   2.89,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-01-17",
"indexname": "DGS30",
"value":   2.96,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-01-18",
"indexname": "DGS30",
"value":   3.05,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-01-19",
"indexname": "DGS30",
"value":    3.1,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-01-22",
"indexname": "DGS30",
"value":   3.15,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-01-23",
"indexname": "DGS30",
"value":   3.15,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-01-24",
"indexname": "DGS30",
"value":   3.13,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-01-25",
"indexname": "DGS30",
"value":    3.1,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-01-26",
"indexname": "DGS30",
"value":   3.07,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-01-29",
"indexname": "DGS30",
"value":   2.99,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-01-30",
"indexname": "DGS30",
"value":   2.94,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-01-31",
"indexname": "DGS30",
"value":   3.01,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-02-01",
"indexname": "DGS30",
"value":   3.01,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-02-02",
"indexname": "DGS30",
"value":   3.13,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-02-05",
"indexname": "DGS30",
"value":   3.08,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-02-06",
"indexname": "DGS30",
"value":   3.14,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-02-07",
"indexname": "DGS30",
"value":   3.14,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-02-08",
"indexname": "DGS30",
"value":    3.2,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-02-09",
"indexname": "DGS30",
"value":   3.11,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-02-12",
"indexname": "DGS30",
"value":   3.14,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-02-13",
"indexname": "DGS30",
"value":   3.06,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-02-14",
"indexname": "DGS30",
"value":   3.09,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-02-15",
"indexname": "DGS30",
"value":   3.14,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-02-16",
"indexname": "DGS30",
"value":   3.16,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-02-20",
"indexname": "DGS30",
"value":    3.2,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-02-21",
"indexname": "DGS30",
"value":   3.15,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-02-22",
"indexname": "DGS30",
"value":   3.13,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-02-23",
"indexname": "DGS30",
"value":    3.1,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-02-26",
"indexname": "DGS30",
"value":   3.04,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-02-27",
"indexname": "DGS30",
"value":   3.07,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-02-28",
"indexname": "DGS30",
"value":   3.08,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-02-29",
"indexname": "DGS30",
"value":   3.15,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-03-01",
"indexname": "DGS30",
"value":   3.11,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-03-04",
"indexname": "DGS30",
"value":   3.13,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-03-05",
"indexname": "DGS30",
"value":   3.08,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-03-06",
"indexname": "DGS30",
"value":   3.12,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-03-07",
"indexname": "DGS30",
"value":   3.18,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-03-08",
"indexname": "DGS30",
"value":   3.19,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-03-11",
"indexname": "DGS30",
"value":   3.17,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-03-12",
"indexname": "DGS30",
"value":   3.26,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-03-13",
"indexname": "DGS30",
"value":   3.43,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-03-14",
"indexname": "DGS30",
"value":   3.41,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-03-15",
"indexname": "DGS30",
"value":   3.41,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-03-18",
"indexname": "DGS30",
"value":   3.48,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-03-19",
"indexname": "DGS30",
"value":   3.46,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-03-20",
"indexname": "DGS30",
"value":   3.38,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-03-21",
"indexname": "DGS30",
"value":   3.37,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-03-22",
"indexname": "DGS30",
"value":   3.31,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-03-25",
"indexname": "DGS30",
"value":   3.33,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-03-26",
"indexname": "DGS30",
"value":   3.29,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-03-27",
"indexname": "DGS30",
"value":   3.31,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-03-28",
"indexname": "DGS30",
"value":   3.27,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-03-29",
"indexname": "DGS30",
"value":   3.35,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-04-01",
"indexname": "DGS30",
"value":   3.35,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-04-02",
"indexname": "DGS30",
"value":   3.41,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-04-03",
"indexname": "DGS30",
"value":   3.37,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-04-04",
"indexname": "DGS30",
"value":   3.32,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-04-05",
"indexname": "DGS30",
"value":   3.21,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-04-08",
"indexname": "DGS30",
"value":   3.18,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-04-09",
"indexname": "DGS30",
"value":   3.13,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-04-10",
"indexname": "DGS30",
"value":   3.18,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-04-11",
"indexname": "DGS30",
"value":   3.22,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-04-12",
"indexname": "DGS30",
"value":   3.14,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-04-15",
"indexname": "DGS30",
"value":   3.12,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-04-16",
"indexname": "DGS30",
"value":   3.15,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-04-17",
"indexname": "DGS30",
"value":   3.13,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-04-18",
"indexname": "DGS30",
"value":   3.12,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-04-19",
"indexname": "DGS30",
"value":   3.12,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-04-22",
"indexname": "DGS30",
"value":   3.08,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-04-23",
"indexname": "DGS30",
"value":   3.12,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-04-24",
"indexname": "DGS30",
"value":   3.15,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-04-25",
"indexname": "DGS30",
"value":   3.13,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-04-26",
"indexname": "DGS30",
"value":   3.12,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-04-29",
"indexname": "DGS30",
"value":   3.12,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-04-30",
"indexname": "DGS30",
"value":   3.16,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-05-01",
"indexname": "DGS30",
"value":   3.11,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-05-02",
"indexname": "DGS30",
"value":   3.12,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-05-03",
"indexname": "DGS30",
"value":   3.07,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-05-06",
"indexname": "DGS30",
"value":   3.07,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-05-07",
"indexname": "DGS30",
"value":   3.03,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-05-08",
"indexname": "DGS30",
"value":   3.03,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-05-09",
"indexname": "DGS30",
"value":   3.07,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-05-10",
"indexname": "DGS30",
"value":   3.02,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-05-13",
"indexname": "DGS30",
"value":   2.95,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-05-14",
"indexname": "DGS30",
"value":   2.91,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-05-15",
"indexname": "DGS30",
"value":    2.9,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-05-16",
"indexname": "DGS30",
"value":    2.8,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-05-17",
"indexname": "DGS30",
"value":    2.8,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-05-20",
"indexname": "DGS30",
"value":    2.8,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-05-21",
"indexname": "DGS30",
"value":   2.88,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-05-22",
"indexname": "DGS30",
"value":   2.81,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-05-23",
"indexname": "DGS30",
"value":   2.86,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-05-24",
"indexname": "DGS30",
"value":   2.85,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-05-28",
"indexname": "DGS30",
"value":   2.85,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-05-29",
"indexname": "DGS30",
"value":   2.72,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-05-30",
"indexname": "DGS30",
"value":   2.67,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-05-31",
"indexname": "DGS30",
"value":   2.53,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-06-03",
"indexname": "DGS30",
"value":   2.56,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-06-04",
"indexname": "DGS30",
"value":   2.63,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-06-05",
"indexname": "DGS30",
"value":   2.73,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-06-06",
"indexname": "DGS30",
"value":   2.75,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-06-07",
"indexname": "DGS30",
"value":   2.77,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-06-10",
"indexname": "DGS30",
"value":   2.71,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-06-11",
"indexname": "DGS30",
"value":   2.77,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-06-12",
"indexname": "DGS30",
"value":    2.7,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-06-13",
"indexname": "DGS30",
"value":   2.73,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-06-14",
"indexname": "DGS30",
"value":    2.7,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-06-17",
"indexname": "DGS30",
"value":   2.67,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-06-18",
"indexname": "DGS30",
"value":   2.73,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-06-19",
"indexname": "DGS30",
"value":   2.72,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-06-20",
"indexname": "DGS30",
"value":   2.68,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-06-21",
"indexname": "DGS30",
"value":   2.75,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-06-24",
"indexname": "DGS30",
"value":   2.69,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-06-25",
"indexname": "DGS30",
"value":   2.71,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-06-26",
"indexname": "DGS30",
"value":    2.7,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-06-27",
"indexname": "DGS30",
"value":   2.67,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-06-28",
"indexname": "DGS30",
"value":   2.76,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-07-01",
"indexname": "DGS30",
"value":   2.69,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-07-02",
"indexname": "DGS30",
"value":   2.74,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-07-04",
"indexname": "DGS30",
"value":   2.72,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-07-05",
"indexname": "DGS30",
"value":   2.66,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-07-08",
"indexname": "DGS30",
"value":   2.62,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-07-09",
"indexname": "DGS30",
"value":    2.6,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-07-10",
"indexname": "DGS30",
"value":    2.6,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-07-11",
"indexname": "DGS30",
"value":   2.57,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-07-12",
"indexname": "DGS30",
"value":   2.58,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-07-15",
"indexname": "DGS30",
"value":   2.56,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-07-16",
"indexname": "DGS30",
"value":   2.59,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-07-17",
"indexname": "DGS30",
"value":   2.59,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-07-18",
"indexname": "DGS30",
"value":   2.61,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-07-19",
"indexname": "DGS30",
"value":   2.55,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-07-22",
"indexname": "DGS30",
"value":   2.52,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-07-23",
"indexname": "DGS30",
"value":   2.47,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-07-24",
"indexname": "DGS30",
"value":   2.46,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-07-25",
"indexname": "DGS30",
"value":   2.49,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-07-26",
"indexname": "DGS30",
"value":   2.63,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-07-29",
"indexname": "DGS30",
"value":   2.58,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-07-30",
"indexname": "DGS30",
"value":   2.56,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-07-31",
"indexname": "DGS30",
"value":    2.6,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-08-01",
"indexname": "DGS30",
"value":   2.55,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-08-02",
"indexname": "DGS30",
"value":   2.65,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-08-05",
"indexname": "DGS30",
"value":   2.65,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-08-06",
"indexname": "DGS30",
"value":   2.72,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-08-07",
"indexname": "DGS30",
"value":   2.75,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-08-08",
"indexname": "DGS30",
"value":   2.78,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-08-09",
"indexname": "DGS30",
"value":   2.74,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-08-12",
"indexname": "DGS30",
"value":   2.74,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-08-13",
"indexname": "DGS30",
"value":   2.82,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-08-14",
"indexname": "DGS30",
"value":    2.9,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-08-15",
"indexname": "DGS30",
"value":   2.96,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-08-16",
"indexname": "DGS30",
"value":   2.93,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-08-19",
"indexname": "DGS30",
"value":   2.93,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-08-20",
"indexname": "DGS30",
"value":    2.9,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-08-21",
"indexname": "DGS30",
"value":   2.82,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-08-22",
"indexname": "DGS30",
"value":   2.79,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-08-23",
"indexname": "DGS30",
"value":   2.79,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-08-26",
"indexname": "DGS30",
"value":   2.76,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-08-27",
"indexname": "DGS30",
"value":   2.75,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-08-28",
"indexname": "DGS30",
"value":   2.77,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-08-29",
"indexname": "DGS30",
"value":   2.75,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-08-30",
"indexname": "DGS30",
"value":   2.68,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-09-03",
"indexname": "DGS30",
"value":   2.69,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-09-04",
"indexname": "DGS30",
"value":    2.7,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-09-05",
"indexname": "DGS30",
"value":    2.8,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-09-06",
"indexname": "DGS30",
"value":   2.81,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-09-09",
"indexname": "DGS30",
"value":   2.83,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-09-10",
"indexname": "DGS30",
"value":   2.84,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-09-11",
"indexname": "DGS30",
"value":   2.92,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-09-12",
"indexname": "DGS30",
"value":   2.95,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-09-13",
"indexname": "DGS30",
"value":   3.09,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-09-16",
"indexname": "DGS30",
"value":   3.03,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-09-17",
"indexname": "DGS30",
"value":      3,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-09-18",
"indexname": "DGS30",
"value":   2.97,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-09-19",
"indexname": "DGS30",
"value":   2.96,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-09-20",
"indexname": "DGS30",
"value":   2.95,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-09-23",
"indexname": "DGS30",
"value":   2.91,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-09-24",
"indexname": "DGS30",
"value":   2.86,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-09-25",
"indexname": "DGS30",
"value":   2.79,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-09-26",
"indexname": "DGS30",
"value":   2.83,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-09-27",
"indexname": "DGS30",
"value":   2.82,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-09-30",
"indexname": "DGS30",
"value":   2.81,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-10-01",
"indexname": "DGS30",
"value":   2.81,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-10-02",
"indexname": "DGS30",
"value":   2.82,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-10-03",
"indexname": "DGS30",
"value":   2.89,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-10-04",
"indexname": "DGS30",
"value":   2.96,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-10-08",
"indexname": "DGS30",
"value":   2.93,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-10-09",
"indexname": "DGS30",
"value":   2.89,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-10-10",
"indexname": "DGS30",
"value":   2.86,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-10-11",
"indexname": "DGS30",
"value":   2.83,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-10-14",
"indexname": "DGS30",
"value":   2.85,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-10-15",
"indexname": "DGS30",
"value":   2.91,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-10-16",
"indexname": "DGS30",
"value":   2.98,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-10-17",
"indexname": "DGS30",
"value":   3.02,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-10-18",
"indexname": "DGS30",
"value":   2.94,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-10-21",
"indexname": "DGS30",
"value":   2.95,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-10-22",
"indexname": "DGS30",
"value":   2.91,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-10-23",
"indexname": "DGS30",
"value":   2.93,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-10-24",
"indexname": "DGS30",
"value":   2.98,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-10-25",
"indexname": "DGS30",
"value":   2.92,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-10-28",
"indexname": "DGS30",
"value":   2.87,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-10-30",
"indexname": "DGS30",
"value":   2.85,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-10-31",
"indexname": "DGS30",
"value":   2.89,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-11-01",
"indexname": "DGS30",
"value":   2.91,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-11-04",
"indexname": "DGS30",
"value":   2.88,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-11-05",
"indexname": "DGS30",
"value":   2.92,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-11-06",
"indexname": "DGS30",
"value":   2.83,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-11-07",
"indexname": "DGS30",
"value":   2.77,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-11-08",
"indexname": "DGS30",
"value":   2.75,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-11-12",
"indexname": "DGS30",
"value":   2.72,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-11-13",
"indexname": "DGS30",
"value":   2.73,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-11-14",
"indexname": "DGS30",
"value":   2.72,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-11-15",
"indexname": "DGS30",
"value":   2.73,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-11-18",
"indexname": "DGS30",
"value":   2.76,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-11-19",
"indexname": "DGS30",
"value":   2.82,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-11-20",
"indexname": "DGS30",
"value":   2.83,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-11-22",
"indexname": "DGS30",
"value":   2.83,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-11-25",
"indexname": "DGS30",
"value":    2.8,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-11-26",
"indexname": "DGS30",
"value":   2.79,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-11-27",
"indexname": "DGS30",
"value":   2.79,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-11-28",
"indexname": "DGS30",
"value":   2.79,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-11-29",
"indexname": "DGS30",
"value":   2.81,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-12-02",
"indexname": "DGS30",
"value":    2.8,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-12-03",
"indexname": "DGS30",
"value":   2.78,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-12-04",
"indexname": "DGS30",
"value":   2.78,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-12-05",
"indexname": "DGS30",
"value":   2.76,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-12-06",
"indexname": "DGS30",
"value":   2.81,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-12-09",
"indexname": "DGS30",
"value":    2.8,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-12-10",
"indexname": "DGS30",
"value":   2.83,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-12-11",
"indexname": "DGS30",
"value":    2.9,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-12-12",
"indexname": "DGS30",
"value":    2.9,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-12-13",
"indexname": "DGS30",
"value":   2.87,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-12-16",
"indexname": "DGS30",
"value":   2.94,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-12-17",
"indexname": "DGS30",
"value":      3,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-12-18",
"indexname": "DGS30",
"value":   2.99,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-12-19",
"indexname": "DGS30",
"value":   2.98,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-12-20",
"indexname": "DGS30",
"value":   2.93,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-12-23",
"indexname": "DGS30",
"value":   2.94,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-12-25",
"indexname": "DGS30",
"value":   2.94,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-12-26",
"indexname": "DGS30",
"value":   2.89,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-12-27",
"indexname": "DGS30",
"value":   2.88,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-12-30",
"indexname": "DGS30",
"value":   2.95,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-01-01",
"indexname": "DGS30",
"value":   3.04,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-01-02",
"indexname": "DGS30",
"value":   3.12,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-01-03",
"indexname": "DGS30",
"value":    3.1,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-01-06",
"indexname": "DGS30",
"value":    3.1,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-01-07",
"indexname": "DGS30",
"value":   3.06,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-01-08",
"indexname": "DGS30",
"value":   3.06,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-01-09",
"indexname": "DGS30",
"value":   3.08,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-01-10",
"indexname": "DGS30",
"value":   3.05,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-01-13",
"indexname": "DGS30",
"value":   3.05,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-01-14",
"indexname": "DGS30",
"value":   3.02,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-01-15",
"indexname": "DGS30",
"value":   3.01,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-01-16",
"indexname": "DGS30",
"value":   3.06,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-01-17",
"indexname": "DGS30",
"value":   3.03,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-01-21",
"indexname": "DGS30",
"value":   3.02,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-01-22",
"indexname": "DGS30",
"value":   3.02,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-01-23",
"indexname": "DGS30",
"value":   3.04,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-01-24",
"indexname": "DGS30",
"value":   3.14,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-01-27",
"indexname": "DGS30",
"value":   3.15,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-01-28",
"indexname": "DGS30",
"value":   3.18,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-01-29",
"indexname": "DGS30",
"value":   3.19,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-01-30",
"indexname": "DGS30",
"value":   3.17,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-01-31",
"indexname": "DGS30",
"value":   3.21,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-02-03",
"indexname": "DGS30",
"value":   3.17,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-02-04",
"indexname": "DGS30",
"value":   3.21,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-02-05",
"indexname": "DGS30",
"value":   3.18,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-02-06",
"indexname": "DGS30",
"value":   3.17,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-02-07",
"indexname": "DGS30",
"value":   3.17,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-02-10",
"indexname": "DGS30",
"value":   3.16,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-02-11",
"indexname": "DGS30",
"value":   3.19,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-02-12",
"indexname": "DGS30",
"value":   3.23,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-02-13",
"indexname": "DGS30",
"value":   3.17,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-02-14",
"indexname": "DGS30",
"value":   3.18,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-02-18",
"indexname": "DGS30",
"value":   3.21,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-02-19",
"indexname": "DGS30",
"value":    3.2,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-02-20",
"indexname": "DGS30",
"value":   3.17,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-02-21",
"indexname": "DGS30",
"value":   3.15,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-02-24",
"indexname": "DGS30",
"value":   3.08,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-02-25",
"indexname": "DGS30",
"value":   3.08,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-02-26",
"indexname": "DGS30",
"value":   3.11,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-02-27",
"indexname": "DGS30",
"value":    3.1,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-02-28",
"indexname": "DGS30",
"value":   3.06,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-03-03",
"indexname": "DGS30",
"value":   3.08,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-03-04",
"indexname": "DGS30",
"value":    3.1,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-03-05",
"indexname": "DGS30",
"value":   3.15,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-03-06",
"indexname": "DGS30",
"value":    3.2,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-03-07",
"indexname": "DGS30",
"value":   3.25,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-03-10",
"indexname": "DGS30",
"value":   3.26,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-03-11",
"indexname": "DGS30",
"value":   3.22,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-03-12",
"indexname": "DGS30",
"value":   3.22,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-03-13",
"indexname": "DGS30",
"value":   3.25,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-03-14",
"indexname": "DGS30",
"value":   3.22,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-03-17",
"indexname": "DGS30",
"value":   3.18,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-03-18",
"indexname": "DGS30",
"value":   3.13,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-03-19",
"indexname": "DGS30",
"value":   3.19,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-03-20",
"indexname": "DGS30",
"value":   3.15,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-03-21",
"indexname": "DGS30",
"value":   3.13,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-03-24",
"indexname": "DGS30",
"value":   3.14,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-03-25",
"indexname": "DGS30",
"value":   3.13,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-03-26",
"indexname": "DGS30",
"value":   3.09,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-03-27",
"indexname": "DGS30",
"value":    3.1,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-03-31",
"indexname": "DGS30",
"value":   3.08,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-04-01",
"indexname": "DGS30",
"value":    3.1,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-04-02",
"indexname": "DGS30",
"value":   3.05,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-04-03",
"indexname": "DGS30",
"value":   2.99,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-04-04",
"indexname": "DGS30",
"value":   2.87,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-04-07",
"indexname": "DGS30",
"value":   2.91,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-04-08",
"indexname": "DGS30",
"value":   2.94,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-04-09",
"indexname": "DGS30",
"value":   3.01,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-04-10",
"indexname": "DGS30",
"value":   3.01,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-04-11",
"indexname": "DGS30",
"value":   2.92,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-04-14",
"indexname": "DGS30",
"value":   2.88,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-04-15",
"indexname": "DGS30",
"value":   2.91,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-04-16",
"indexname": "DGS30",
"value":   2.89,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-04-17",
"indexname": "DGS30",
"value":   2.87,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-04-18",
"indexname": "DGS30",
"value":   2.88,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-04-21",
"indexname": "DGS30",
"value":   2.88,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-04-22",
"indexname": "DGS30",
"value":    2.9,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-04-23",
"indexname": "DGS30",
"value":   2.89,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-04-24",
"indexname": "DGS30",
"value":   2.91,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-04-25",
"indexname": "DGS30",
"value":   2.87,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-04-28",
"indexname": "DGS30",
"value":   2.88,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-04-29",
"indexname": "DGS30",
"value":   2.88,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-04-30",
"indexname": "DGS30",
"value":   2.83,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-05-01",
"indexname": "DGS30",
"value":   2.82,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-05-02",
"indexname": "DGS30",
"value":   2.96,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-05-05",
"indexname": "DGS30",
"value":   2.98,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-05-06",
"indexname": "DGS30",
"value":      3,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-05-07",
"indexname": "DGS30",
"value":   2.99,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-05-08",
"indexname": "DGS30",
"value":   3.01,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-05-09",
"indexname": "DGS30",
"value":    3.1,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-05-12",
"indexname": "DGS30",
"value":   3.13,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-05-13",
"indexname": "DGS30",
"value":   3.17,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-05-14",
"indexname": "DGS30",
"value":   3.16,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-05-15",
"indexname": "DGS30",
"value":   3.09,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-05-16",
"indexname": "DGS30",
"value":   3.17,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-05-19",
"indexname": "DGS30",
"value":   3.18,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-05-20",
"indexname": "DGS30",
"value":   3.14,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-05-21",
"indexname": "DGS30",
"value":   3.21,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-05-22",
"indexname": "DGS30",
"value":    3.2,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-05-23",
"indexname": "DGS30",
"value":   3.18,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-05-27",
"indexname": "DGS30",
"value":   3.31,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-05-28",
"indexname": "DGS30",
"value":   3.27,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-05-29",
"indexname": "DGS30",
"value":   3.28,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-05-30",
"indexname": "DGS30",
"value":    3.3,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-06-02",
"indexname": "DGS30",
"value":   3.27,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-06-03",
"indexname": "DGS30",
"value":    3.3,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-06-04",
"indexname": "DGS30",
"value":   3.25,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-06-05",
"indexname": "DGS30",
"value":   3.23,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-06-06",
"indexname": "DGS30",
"value":   3.33,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-06-09",
"indexname": "DGS30",
"value":   3.36,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-06-10",
"indexname": "DGS30",
"value":   3.33,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-06-11",
"indexname": "DGS30",
"value":   3.37,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-06-12",
"indexname": "DGS30",
"value":   3.33,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-06-13",
"indexname": "DGS30",
"value":   3.28,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-06-16",
"indexname": "DGS30",
"value":   3.35,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-06-17",
"indexname": "DGS30",
"value":   3.34,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-06-18",
"indexname": "DGS30",
"value":   3.41,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-06-19",
"indexname": "DGS30",
"value":   3.49,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-06-20",
"indexname": "DGS30",
"value":   3.56,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-06-23",
"indexname": "DGS30",
"value":   3.56,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-06-24",
"indexname": "DGS30",
"value":    3.6,
"maturity":     30,
"country": "US" 
} 
],
    xAxis = {
 "type": "addCategoryAxis",
"showPercent": false 
},
    yAxis = {
 "type": "addMeasureAxis",
"showPercent": false 
},
    zAxis = [],
    legend = {
 "x":     60,
"y":     10,
"width":    620,
"height":     20,
"horizontalAlign": "right" 
};
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
<script>
//add this as a way to work around current lack of features for 
//times on x axis in dimple

//get Dates in d3 js format
data.forEach(function(d) {
  d.date = new Date(d.date);
  //d.value = +d.value;
});
//sort since order gets messed up
data.sort(function(a,b){return d3.ascending(a.date,b.date);})

//remove dimple axis
//hoping x is always drawn first
d3.select('#'+opts.id).select(".axis").remove()

//from Bostock example http://bl.ocks.org/mbostock/1166403

// Scales and axes. Note the inverted domain for the y-scale: bigger is up!
var xd3 = d3.time.scale().range([myChart.x, myChart.x + myChart.width]),
    yd3 = d3.scale.linear().range([myChart.y+myChart.height,myChart.y]),
    xAxisd3 = d3.svg.axis().scale(xd3).tickSize(4).tickSubdivide(true),
    yAxis = d3.svg.axis().scale(yd3).ticks(4).orient("right");

xd3.domain([data[0].date, data[data.length - 1].date]);
yd3.domain([0, d3.max(data, function(d) { return d.value; })]).nice();

var svg = d3.select('#'+opts.id).select('svg')
svg.append("g")
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


---
### Line Chart by Maturity by Date

I am still really proud of my chart displayed in this [post](http://timelyportfolio.blogspot.com/2013/05/even-more-jgb-yield-charts-with-r.html).  I bet we can do something like that but better since we will have interactivity.  Will it be hard?  Of course not, we just change our `x` in `dPlot()` and then sort with `d4$xAxis(grouporderRule="date")`.



```r
#simple line chart of all maturities
d4 <- dPlot(
  x = c("maturity","date"),
  y = "value",
  groups = 'maturity',
  data = ust.melt,
  type = 'line'
)
d4$xAxis( grouporderRule = "date" ) #sort by date
d4$legend( x = 60, y = 10, width = 620, height = 20,
  horizontalAlign = "right")
d4
```

<div id ="chart4"></div>

<div id='chart4' class='rChart dimple'></div>
<script type="text/javascript">
  var opts = {
 "dom": "chart4",
"width":    800,
"height":    400,
"x": [ "maturity", "date" ],
"y": "value",
"groups": "maturity",
"type": "line",
"id": "chart4" 
},
    data = [
 {
 "date": "2012-01-02",
"indexname": "DGS1",
"value":   0.12,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-01-03",
"indexname": "DGS1",
"value":   0.12,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-01-04",
"indexname": "DGS1",
"value":   0.11,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-01-05",
"indexname": "DGS1",
"value":   0.12,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-01-08",
"indexname": "DGS1",
"value":   0.11,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-01-09",
"indexname": "DGS1",
"value":   0.11,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-01-10",
"indexname": "DGS1",
"value":   0.11,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-01-11",
"indexname": "DGS1",
"value":   0.11,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-01-12",
"indexname": "DGS1",
"value":    0.1,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-01-16",
"indexname": "DGS1",
"value":   0.11,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-01-17",
"indexname": "DGS1",
"value":   0.11,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-01-18",
"indexname": "DGS1",
"value":   0.11,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-01-19",
"indexname": "DGS1",
"value":   0.11,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-01-22",
"indexname": "DGS1",
"value":   0.12,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-01-23",
"indexname": "DGS1",
"value":   0.12,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-01-24",
"indexname": "DGS1",
"value":   0.12,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-01-25",
"indexname": "DGS1",
"value":   0.12,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-01-26",
"indexname": "DGS1",
"value":   0.12,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-01-29",
"indexname": "DGS1",
"value":   0.12,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-01-30",
"indexname": "DGS1",
"value":   0.13,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-01-31",
"indexname": "DGS1",
"value":   0.13,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-02-01",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-02-02",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-02-05",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-02-06",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-02-07",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-02-08",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-02-09",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-02-12",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-02-13",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-02-14",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-02-15",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-02-16",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-02-20",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-02-21",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-02-22",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-02-23",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-02-26",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-02-27",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-02-28",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-02-29",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-03-01",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-03-04",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-03-05",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-03-06",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-03-07",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-03-08",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-03-11",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-03-12",
"indexname": "DGS1",
"value":    0.2,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-03-13",
"indexname": "DGS1",
"value":   0.21,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-03-14",
"indexname": "DGS1",
"value":   0.21,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-03-15",
"indexname": "DGS1",
"value":   0.21,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-03-18",
"indexname": "DGS1",
"value":   0.21,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-03-19",
"indexname": "DGS1",
"value":   0.22,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-03-20",
"indexname": "DGS1",
"value":   0.21,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-03-21",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-03-22",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-03-25",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-03-26",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-03-27",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-03-28",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-03-29",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-04-01",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-04-02",
"indexname": "DGS1",
"value":    0.2,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-04-03",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-04-04",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-04-05",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-04-08",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-04-09",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-04-10",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-04-11",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-04-12",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-04-15",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-04-16",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-04-17",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-04-18",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-04-19",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-04-22",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-04-23",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-04-24",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-04-25",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-04-26",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-04-29",
"indexname": "DGS1",
"value":    0.2,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-04-30",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-05-01",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-05-02",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-05-03",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-05-06",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-05-07",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-05-08",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-05-09",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-05-10",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-05-13",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-05-14",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-05-15",
"indexname": "DGS1",
"value":    0.2,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-05-16",
"indexname": "DGS1",
"value":    0.2,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-05-17",
"indexname": "DGS1",
"value":    0.2,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-05-20",
"indexname": "DGS1",
"value":   0.21,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-05-21",
"indexname": "DGS1",
"value":   0.21,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-05-22",
"indexname": "DGS1",
"value":    0.2,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-05-23",
"indexname": "DGS1",
"value":   0.21,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-05-24",
"indexname": "DGS1",
"value":    0.2,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-05-28",
"indexname": "DGS1",
"value":    0.2,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-05-29",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-05-30",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-05-31",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-06-03",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-06-04",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-06-05",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-06-06",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-06-07",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-06-10",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-06-11",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-06-12",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-06-13",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-06-14",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-06-17",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-06-18",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-06-19",
"indexname": "DGS1",
"value":    0.2,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-06-20",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-06-21",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-06-24",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-06-25",
"indexname": "DGS1",
"value":   0.21,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-06-26",
"indexname": "DGS1",
"value":   0.21,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-06-27",
"indexname": "DGS1",
"value":   0.22,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-06-28",
"indexname": "DGS1",
"value":   0.21,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-07-01",
"indexname": "DGS1",
"value":   0.21,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-07-02",
"indexname": "DGS1",
"value":   0.21,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-07-04",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-07-05",
"indexname": "DGS1",
"value":    0.2,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-07-08",
"indexname": "DGS1",
"value":    0.2,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-07-09",
"indexname": "DGS1",
"value":    0.2,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-07-10",
"indexname": "DGS1",
"value":    0.2,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-07-11",
"indexname": "DGS1",
"value":    0.2,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-07-12",
"indexname": "DGS1",
"value":    0.2,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-07-15",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-07-16",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-07-17",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-07-18",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-07-19",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-07-22",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-07-23",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-07-24",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-07-25",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-07-26",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-07-29",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-07-30",
"indexname": "DGS1",
"value":   0.16,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-07-31",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-08-01",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-08-02",
"indexname": "DGS1",
"value":   0.16,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-08-05",
"indexname": "DGS1",
"value":   0.16,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-08-06",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-08-07",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-08-08",
"indexname": "DGS1",
"value":    0.2,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-08-09",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-08-12",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-08-13",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-08-14",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-08-15",
"indexname": "DGS1",
"value":    0.2,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-08-16",
"indexname": "DGS1",
"value":    0.2,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-08-19",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-08-20",
"indexname": "DGS1",
"value":    0.2,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-08-21",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-08-22",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-08-23",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-08-26",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-08-27",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-08-28",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-08-29",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-08-30",
"indexname": "DGS1",
"value":   0.16,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-09-03",
"indexname": "DGS1",
"value":   0.16,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-09-04",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-09-05",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-09-06",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-09-09",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-09-10",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-09-11",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-09-12",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-09-13",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-09-16",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-09-17",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-09-18",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-09-19",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-09-20",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-09-23",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-09-24",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-09-25",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-09-26",
"indexname": "DGS1",
"value":   0.16,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-09-27",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-09-30",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-10-01",
"indexname": "DGS1",
"value":   0.16,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-10-02",
"indexname": "DGS1",
"value":   0.16,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-10-03",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-10-04",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-10-08",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-10-09",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-10-10",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-10-11",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-10-14",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-10-15",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-10-16",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-10-17",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-10-18",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-10-21",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-10-22",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-10-23",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-10-24",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-10-25",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-10-28",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-10-30",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-10-31",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-11-01",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-11-04",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-11-05",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-11-06",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-11-07",
"indexname": "DGS1",
"value":    0.2,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-11-08",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-11-12",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-11-13",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-11-14",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-11-15",
"indexname": "DGS1",
"value":   0.16,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-11-18",
"indexname": "DGS1",
"value":   0.16,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-11-19",
"indexname": "DGS1",
"value":   0.16,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-11-20",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-11-22",
"indexname": "DGS1",
"value":   0.19,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-11-25",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-11-26",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-11-27",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-11-28",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-11-29",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-12-02",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-12-03",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-12-04",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-12-05",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-12-06",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-12-09",
"indexname": "DGS1",
"value":   0.18,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-12-10",
"indexname": "DGS1",
"value":   0.16,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-12-11",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-12-12",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-12-13",
"indexname": "DGS1",
"value":   0.13,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-12-16",
"indexname": "DGS1",
"value":   0.13,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-12-17",
"indexname": "DGS1",
"value":   0.16,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-12-18",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-12-19",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-12-20",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-12-23",
"indexname": "DGS1",
"value":   0.16,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-12-25",
"indexname": "DGS1",
"value":   0.16,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-12-26",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-12-27",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-12-30",
"indexname": "DGS1",
"value":   0.16,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-01-01",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-01-02",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-01-03",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-01-06",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-01-07",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-01-08",
"indexname": "DGS1",
"value":   0.13,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-01-09",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-01-10",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-01-13",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-01-14",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-01-15",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-01-16",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-01-17",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-01-21",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-01-22",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-01-23",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-01-24",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-01-27",
"indexname": "DGS1",
"value":   0.16,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-01-28",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-01-29",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-01-30",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-01-31",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-02-03",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-02-04",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-02-05",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-02-06",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-02-07",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-02-10",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-02-11",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-02-12",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-02-13",
"indexname": "DGS1",
"value":   0.16,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-02-14",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-02-18",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-02-19",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-02-20",
"indexname": "DGS1",
"value":   0.16,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-02-21",
"indexname": "DGS1",
"value":   0.16,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-02-24",
"indexname": "DGS1",
"value":   0.16,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-02-25",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-02-26",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-02-27",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-02-28",
"indexname": "DGS1",
"value":   0.16,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-03-03",
"indexname": "DGS1",
"value":   0.16,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-03-04",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-03-05",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-03-06",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-03-07",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-03-10",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-03-11",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-03-12",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-03-13",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-03-14",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-03-17",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-03-18",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-03-19",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-03-20",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-03-21",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-03-24",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-03-25",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-03-26",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-03-27",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-03-31",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-04-01",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-04-02",
"indexname": "DGS1",
"value":   0.13,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-04-03",
"indexname": "DGS1",
"value":   0.13,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-04-04",
"indexname": "DGS1",
"value":   0.13,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-04-07",
"indexname": "DGS1",
"value":   0.13,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-04-08",
"indexname": "DGS1",
"value":   0.13,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-04-09",
"indexname": "DGS1",
"value":   0.12,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-04-10",
"indexname": "DGS1",
"value":   0.12,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-04-11",
"indexname": "DGS1",
"value":   0.11,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-04-14",
"indexname": "DGS1",
"value":   0.12,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-04-15",
"indexname": "DGS1",
"value":   0.13,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-04-16",
"indexname": "DGS1",
"value":   0.13,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-04-17",
"indexname": "DGS1",
"value":   0.12,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-04-18",
"indexname": "DGS1",
"value":   0.12,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-04-21",
"indexname": "DGS1",
"value":   0.12,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-04-22",
"indexname": "DGS1",
"value":   0.12,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-04-23",
"indexname": "DGS1",
"value":   0.13,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-04-24",
"indexname": "DGS1",
"value":   0.12,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-04-25",
"indexname": "DGS1",
"value":   0.12,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-04-28",
"indexname": "DGS1",
"value":   0.12,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-04-29",
"indexname": "DGS1",
"value":   0.11,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-04-30",
"indexname": "DGS1",
"value":   0.11,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-05-01",
"indexname": "DGS1",
"value":   0.11,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-05-02",
"indexname": "DGS1",
"value":   0.11,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-05-05",
"indexname": "DGS1",
"value":   0.11,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-05-06",
"indexname": "DGS1",
"value":    0.1,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-05-07",
"indexname": "DGS1",
"value":   0.11,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-05-08",
"indexname": "DGS1",
"value":   0.11,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-05-09",
"indexname": "DGS1",
"value":   0.11,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-05-12",
"indexname": "DGS1",
"value":   0.13,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-05-13",
"indexname": "DGS1",
"value":   0.12,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-05-14",
"indexname": "DGS1",
"value":   0.12,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-05-15",
"indexname": "DGS1",
"value":   0.12,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-05-16",
"indexname": "DGS1",
"value":   0.12,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-05-19",
"indexname": "DGS1",
"value":   0.12,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-05-20",
"indexname": "DGS1",
"value":   0.12,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-05-21",
"indexname": "DGS1",
"value":   0.11,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-05-22",
"indexname": "DGS1",
"value":   0.12,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-05-23",
"indexname": "DGS1",
"value":   0.12,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-05-27",
"indexname": "DGS1",
"value":   0.13,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-05-28",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-05-29",
"indexname": "DGS1",
"value":   0.13,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-05-30",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-06-02",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-06-03",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-06-04",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-06-05",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-06-06",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-06-09",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-06-10",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-06-11",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-06-12",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-06-13",
"indexname": "DGS1",
"value":   0.13,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-06-16",
"indexname": "DGS1",
"value":   0.13,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-06-17",
"indexname": "DGS1",
"value":   0.13,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-06-18",
"indexname": "DGS1",
"value":   0.13,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-06-19",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-06-20",
"indexname": "DGS1",
"value":   0.13,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-06-23",
"indexname": "DGS1",
"value":   0.16,
"maturity":      1,
"country": "US" 
},
{
 "date": "2013-06-24",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "2012-01-02",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-01-03",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-01-04",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-01-05",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-01-08",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-01-09",
"indexname": "DGS2",
"value":   0.24,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-01-10",
"indexname": "DGS2",
"value":   0.24,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-01-11",
"indexname": "DGS2",
"value":   0.22,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-01-12",
"indexname": "DGS2",
"value":   0.24,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-01-16",
"indexname": "DGS2",
"value":   0.21,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-01-17",
"indexname": "DGS2",
"value":   0.24,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-01-18",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-01-19",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-01-22",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-01-23",
"indexname": "DGS2",
"value":   0.24,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-01-24",
"indexname": "DGS2",
"value":   0.22,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-01-25",
"indexname": "DGS2",
"value":   0.22,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-01-26",
"indexname": "DGS2",
"value":   0.22,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-01-29",
"indexname": "DGS2",
"value":   0.22,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-01-30",
"indexname": "DGS2",
"value":   0.22,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-01-31",
"indexname": "DGS2",
"value":   0.23,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-02-01",
"indexname": "DGS2",
"value":   0.23,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-02-02",
"indexname": "DGS2",
"value":   0.23,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-02-05",
"indexname": "DGS2",
"value":   0.24,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-02-06",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-02-07",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-02-08",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-02-09",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-02-12",
"indexname": "DGS2",
"value":   0.29,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-02-13",
"indexname": "DGS2",
"value":   0.29,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-02-14",
"indexname": "DGS2",
"value":   0.29,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-02-15",
"indexname": "DGS2",
"value":   0.29,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-02-16",
"indexname": "DGS2",
"value":   0.29,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-02-20",
"indexname": "DGS2",
"value":   0.31,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-02-21",
"indexname": "DGS2",
"value":   0.29,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-02-22",
"indexname": "DGS2",
"value":   0.31,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-02-23",
"indexname": "DGS2",
"value":   0.31,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-02-26",
"indexname": "DGS2",
"value":    0.3,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-02-27",
"indexname": "DGS2",
"value":    0.3,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-02-28",
"indexname": "DGS2",
"value":    0.3,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-02-29",
"indexname": "DGS2",
"value":    0.3,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-03-01",
"indexname": "DGS2",
"value":   0.28,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-03-04",
"indexname": "DGS2",
"value":   0.31,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-03-05",
"indexname": "DGS2",
"value":    0.3,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-03-06",
"indexname": "DGS2",
"value":    0.3,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-03-07",
"indexname": "DGS2",
"value":   0.32,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-03-08",
"indexname": "DGS2",
"value":   0.33,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-03-11",
"indexname": "DGS2",
"value":   0.33,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-03-12",
"indexname": "DGS2",
"value":   0.35,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-03-13",
"indexname": "DGS2",
"value":    0.4,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-03-14",
"indexname": "DGS2",
"value":   0.37,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-03-15",
"indexname": "DGS2",
"value":   0.37,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-03-18",
"indexname": "DGS2",
"value":   0.39,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-03-19",
"indexname": "DGS2",
"value":   0.41,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-03-20",
"indexname": "DGS2",
"value":   0.39,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-03-21",
"indexname": "DGS2",
"value":   0.37,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-03-22",
"indexname": "DGS2",
"value":   0.37,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-03-25",
"indexname": "DGS2",
"value":   0.36,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-03-26",
"indexname": "DGS2",
"value":   0.33,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-03-27",
"indexname": "DGS2",
"value":   0.34,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-03-28",
"indexname": "DGS2",
"value":   0.33,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-03-29",
"indexname": "DGS2",
"value":   0.33,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-04-01",
"indexname": "DGS2",
"value":   0.33,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-04-02",
"indexname": "DGS2",
"value":   0.36,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-04-03",
"indexname": "DGS2",
"value":   0.35,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-04-04",
"indexname": "DGS2",
"value":   0.35,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-04-05",
"indexname": "DGS2",
"value":   0.32,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-04-08",
"indexname": "DGS2",
"value":   0.32,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-04-09",
"indexname": "DGS2",
"value":   0.28,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-04-10",
"indexname": "DGS2",
"value":    0.3,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-04-11",
"indexname": "DGS2",
"value":   0.29,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-04-12",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-04-15",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-04-16",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-04-17",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-04-18",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-04-19",
"indexname": "DGS2",
"value":   0.29,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-04-22",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-04-23",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-04-24",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-04-25",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-04-26",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-04-29",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-04-30",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-05-01",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-05-02",
"indexname": "DGS2",
"value":   0.28,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-05-03",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-05-06",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-05-07",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-05-08",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-05-09",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-05-10",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-05-13",
"indexname": "DGS2",
"value":   0.29,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-05-14",
"indexname": "DGS2",
"value":   0.29,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-05-15",
"indexname": "DGS2",
"value":    0.3,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-05-16",
"indexname": "DGS2",
"value":   0.32,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-05-17",
"indexname": "DGS2",
"value":   0.32,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-05-20",
"indexname": "DGS2",
"value":    0.3,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-05-21",
"indexname": "DGS2",
"value":    0.3,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-05-22",
"indexname": "DGS2",
"value":   0.28,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-05-23",
"indexname": "DGS2",
"value":   0.29,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-05-24",
"indexname": "DGS2",
"value":    0.3,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-05-28",
"indexname": "DGS2",
"value":    0.3,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-05-29",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-05-30",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-05-31",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-06-03",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-06-04",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-06-05",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-06-06",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-06-07",
"indexname": "DGS2",
"value":   0.28,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-06-10",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-06-11",
"indexname": "DGS2",
"value":    0.3,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-06-12",
"indexname": "DGS2",
"value":    0.3,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-06-13",
"indexname": "DGS2",
"value":    0.3,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-06-14",
"indexname": "DGS2",
"value":   0.29,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-06-17",
"indexname": "DGS2",
"value":   0.29,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-06-18",
"indexname": "DGS2",
"value":    0.3,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-06-19",
"indexname": "DGS2",
"value":   0.32,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-06-20",
"indexname": "DGS2",
"value":   0.32,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-06-21",
"indexname": "DGS2",
"value":   0.31,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-06-24",
"indexname": "DGS2",
"value":   0.31,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-06-25",
"indexname": "DGS2",
"value":   0.31,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-06-26",
"indexname": "DGS2",
"value":   0.31,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-06-27",
"indexname": "DGS2",
"value":   0.31,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-06-28",
"indexname": "DGS2",
"value":   0.33,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-07-01",
"indexname": "DGS2",
"value":    0.3,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-07-02",
"indexname": "DGS2",
"value":    0.3,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-07-04",
"indexname": "DGS2",
"value":   0.28,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-07-05",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-07-08",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-07-09",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-07-10",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-07-11",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-07-12",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-07-15",
"indexname": "DGS2",
"value":   0.24,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-07-16",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-07-17",
"indexname": "DGS2",
"value":   0.22,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-07-18",
"indexname": "DGS2",
"value":   0.22,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-07-19",
"indexname": "DGS2",
"value":   0.22,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-07-22",
"indexname": "DGS2",
"value":   0.22,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-07-23",
"indexname": "DGS2",
"value":   0.22,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-07-24",
"indexname": "DGS2",
"value":   0.22,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-07-25",
"indexname": "DGS2",
"value":   0.23,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-07-26",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-07-29",
"indexname": "DGS2",
"value":   0.23,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-07-30",
"indexname": "DGS2",
"value":   0.23,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-07-31",
"indexname": "DGS2",
"value":   0.24,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-08-01",
"indexname": "DGS2",
"value":   0.24,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-08-02",
"indexname": "DGS2",
"value":   0.24,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-08-05",
"indexname": "DGS2",
"value":   0.24,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-08-06",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-08-07",
"indexname": "DGS2",
"value":   0.29,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-08-08",
"indexname": "DGS2",
"value":   0.29,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-08-09",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-08-12",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-08-13",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-08-14",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-08-15",
"indexname": "DGS2",
"value":   0.29,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-08-16",
"indexname": "DGS2",
"value":   0.29,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-08-19",
"indexname": "DGS2",
"value":   0.29,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-08-20",
"indexname": "DGS2",
"value":   0.31,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-08-21",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-08-22",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-08-23",
"indexname": "DGS2",
"value":   0.28,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-08-26",
"indexname": "DGS2",
"value":   0.28,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-08-27",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-08-28",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-08-29",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-08-30",
"indexname": "DGS2",
"value":   0.22,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-09-03",
"indexname": "DGS2",
"value":   0.23,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-09-04",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-09-05",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-09-06",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-09-09",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-09-10",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-09-11",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-09-12",
"indexname": "DGS2",
"value":   0.24,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-09-13",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-09-16",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-09-17",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-09-18",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-09-19",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-09-20",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-09-23",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-09-24",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-09-25",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-09-26",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-09-27",
"indexname": "DGS2",
"value":   0.23,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-09-30",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-10-01",
"indexname": "DGS2",
"value":   0.23,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-10-02",
"indexname": "DGS2",
"value":   0.23,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-10-03",
"indexname": "DGS2",
"value":   0.23,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-10-04",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-10-08",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-10-09",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-10-10",
"indexname": "DGS2",
"value":   0.28,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-10-11",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-10-14",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-10-15",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-10-16",
"indexname": "DGS2",
"value":    0.3,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-10-17",
"indexname": "DGS2",
"value":   0.29,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-10-18",
"indexname": "DGS2",
"value":    0.3,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-10-21",
"indexname": "DGS2",
"value":   0.32,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-10-22",
"indexname": "DGS2",
"value":   0.29,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-10-23",
"indexname": "DGS2",
"value":   0.29,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-10-24",
"indexname": "DGS2",
"value":   0.31,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-10-25",
"indexname": "DGS2",
"value":    0.3,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-10-28",
"indexname": "DGS2",
"value":    0.3,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-10-30",
"indexname": "DGS2",
"value":    0.3,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-10-31",
"indexname": "DGS2",
"value":    0.3,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-11-01",
"indexname": "DGS2",
"value":   0.28,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-11-04",
"indexname": "DGS2",
"value":   0.28,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-11-05",
"indexname": "DGS2",
"value":    0.3,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-11-06",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-11-07",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-11-08",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-11-12",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-11-13",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-11-14",
"indexname": "DGS2",
"value":   0.24,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-11-15",
"indexname": "DGS2",
"value":   0.24,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-11-18",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-11-19",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-11-20",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-11-22",
"indexname": "DGS2",
"value":   0.29,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-11-25",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-11-26",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-11-27",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-11-28",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-11-29",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-12-02",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-12-03",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-12-04",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-12-05",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-12-06",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-12-09",
"indexname": "DGS2",
"value":   0.24,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-12-10",
"indexname": "DGS2",
"value":   0.24,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-12-11",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-12-12",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-12-13",
"indexname": "DGS2",
"value":   0.24,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-12-16",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-12-17",
"indexname": "DGS2",
"value":   0.28,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-12-18",
"indexname": "DGS2",
"value":   0.28,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-12-19",
"indexname": "DGS2",
"value":   0.28,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-12-20",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-12-23",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-12-25",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-12-26",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-12-27",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-12-30",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-01-01",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-01-02",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-01-03",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-01-06",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-01-07",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-01-08",
"indexname": "DGS2",
"value":   0.24,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-01-09",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-01-10",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-01-13",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-01-14",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-01-15",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-01-16",
"indexname": "DGS2",
"value":   0.28,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-01-17",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-01-21",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-01-22",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-01-23",
"indexname": "DGS2",
"value":   0.23,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-01-24",
"indexname": "DGS2",
"value":   0.28,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-01-27",
"indexname": "DGS2",
"value":   0.29,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-01-28",
"indexname": "DGS2",
"value":    0.3,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-01-29",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-01-30",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-01-31",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-02-03",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-02-04",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-02-05",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-02-06",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-02-07",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-02-10",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-02-11",
"indexname": "DGS2",
"value":   0.29,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-02-12",
"indexname": "DGS2",
"value":   0.29,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-02-13",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-02-14",
"indexname": "DGS2",
"value":   0.29,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-02-18",
"indexname": "DGS2",
"value":   0.29,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-02-19",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-02-20",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-02-21",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-02-24",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-02-25",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-02-26",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-02-27",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-02-28",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-03-03",
"indexname": "DGS2",
"value":   0.24,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-03-04",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-03-05",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-03-06",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-03-07",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-03-10",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-03-11",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-03-12",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-03-13",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-03-14",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-03-17",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-03-18",
"indexname": "DGS2",
"value":   0.24,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-03-19",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-03-20",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-03-21",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-03-24",
"indexname": "DGS2",
"value":   0.24,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-03-25",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-03-26",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-03-27",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-03-31",
"indexname": "DGS2",
"value":   0.23,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-04-01",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-04-02",
"indexname": "DGS2",
"value":   0.24,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-04-03",
"indexname": "DGS2",
"value":   0.22,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-04-04",
"indexname": "DGS2",
"value":   0.24,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-04-07",
"indexname": "DGS2",
"value":   0.24,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-04-08",
"indexname": "DGS2",
"value":   0.24,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-04-09",
"indexname": "DGS2",
"value":   0.24,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-04-10",
"indexname": "DGS2",
"value":   0.24,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-04-11",
"indexname": "DGS2",
"value":   0.22,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-04-14",
"indexname": "DGS2",
"value":   0.22,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-04-15",
"indexname": "DGS2",
"value":   0.24,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-04-16",
"indexname": "DGS2",
"value":   0.24,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-04-17",
"indexname": "DGS2",
"value":   0.24,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-04-18",
"indexname": "DGS2",
"value":   0.24,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-04-21",
"indexname": "DGS2",
"value":   0.24,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-04-22",
"indexname": "DGS2",
"value":   0.23,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-04-23",
"indexname": "DGS2",
"value":   0.23,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-04-24",
"indexname": "DGS2",
"value":   0.23,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-04-25",
"indexname": "DGS2",
"value":   0.22,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-04-28",
"indexname": "DGS2",
"value":    0.2,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-04-29",
"indexname": "DGS2",
"value":   0.22,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-04-30",
"indexname": "DGS2",
"value":    0.2,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-05-01",
"indexname": "DGS2",
"value":    0.2,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-05-02",
"indexname": "DGS2",
"value":   0.22,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-05-05",
"indexname": "DGS2",
"value":   0.22,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-05-06",
"indexname": "DGS2",
"value":   0.22,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-05-07",
"indexname": "DGS2",
"value":   0.22,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-05-08",
"indexname": "DGS2",
"value":   0.22,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-05-09",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-05-12",
"indexname": "DGS2",
"value":   0.24,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-05-13",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-05-14",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-05-15",
"indexname": "DGS2",
"value":   0.23,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-05-16",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-05-19",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-05-20",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-05-21",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-05-22",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-05-23",
"indexname": "DGS2",
"value":   0.26,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-05-27",
"indexname": "DGS2",
"value":   0.29,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-05-28",
"indexname": "DGS2",
"value":    0.3,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-05-29",
"indexname": "DGS2",
"value":   0.31,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-05-30",
"indexname": "DGS2",
"value":    0.3,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-06-02",
"indexname": "DGS2",
"value":    0.3,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-06-03",
"indexname": "DGS2",
"value":   0.32,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-06-04",
"indexname": "DGS2",
"value":    0.3,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-06-05",
"indexname": "DGS2",
"value":    0.3,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-06-06",
"indexname": "DGS2",
"value":   0.32,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-06-09",
"indexname": "DGS2",
"value":   0.32,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-06-10",
"indexname": "DGS2",
"value":   0.34,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-06-11",
"indexname": "DGS2",
"value":   0.34,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-06-12",
"indexname": "DGS2",
"value":   0.32,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-06-13",
"indexname": "DGS2",
"value":   0.29,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-06-16",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-06-17",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-06-18",
"indexname": "DGS2",
"value":   0.31,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-06-19",
"indexname": "DGS2",
"value":   0.33,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-06-20",
"indexname": "DGS2",
"value":   0.38,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-06-23",
"indexname": "DGS2",
"value":   0.42,
"maturity":      2,
"country": "US" 
},
{
 "date": "2013-06-24",
"indexname": "DGS2",
"value":   0.43,
"maturity":      2,
"country": "US" 
},
{
 "date": "2012-01-02",
"indexname": "DGS3",
"value":    0.4,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-01-03",
"indexname": "DGS3",
"value":    0.4,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-01-04",
"indexname": "DGS3",
"value":    0.4,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-01-05",
"indexname": "DGS3",
"value":    0.4,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-01-08",
"indexname": "DGS3",
"value":   0.38,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-01-09",
"indexname": "DGS3",
"value":   0.37,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-01-10",
"indexname": "DGS3",
"value":   0.34,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-01-11",
"indexname": "DGS3",
"value":   0.35,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-01-12",
"indexname": "DGS3",
"value":   0.34,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-01-16",
"indexname": "DGS3",
"value":   0.33,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-01-17",
"indexname": "DGS3",
"value":   0.35,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-01-18",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-01-19",
"indexname": "DGS3",
"value":   0.38,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-01-22",
"indexname": "DGS3",
"value":   0.39,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-01-23",
"indexname": "DGS3",
"value":   0.39,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-01-24",
"indexname": "DGS3",
"value":   0.34,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-01-25",
"indexname": "DGS3",
"value":   0.31,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-01-26",
"indexname": "DGS3",
"value":   0.32,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-01-29",
"indexname": "DGS3",
"value":   0.31,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-01-30",
"indexname": "DGS3",
"value":    0.3,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-01-31",
"indexname": "DGS3",
"value":   0.31,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-02-01",
"indexname": "DGS3",
"value":   0.31,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-02-02",
"indexname": "DGS3",
"value":   0.33,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-02-05",
"indexname": "DGS3",
"value":   0.32,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-02-06",
"indexname": "DGS3",
"value":   0.35,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-02-07",
"indexname": "DGS3",
"value":   0.35,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-02-08",
"indexname": "DGS3",
"value":   0.38,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-02-09",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-02-12",
"indexname": "DGS3",
"value":    0.4,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-02-13",
"indexname": "DGS3",
"value":    0.4,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-02-14",
"indexname": "DGS3",
"value":   0.38,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-02-15",
"indexname": "DGS3",
"value":   0.42,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-02-16",
"indexname": "DGS3",
"value":   0.42,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-02-20",
"indexname": "DGS3",
"value":   0.44,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-02-21",
"indexname": "DGS3",
"value":   0.42,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-02-22",
"indexname": "DGS3",
"value":   0.43,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-02-23",
"indexname": "DGS3",
"value":   0.43,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-02-26",
"indexname": "DGS3",
"value":    0.4,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-02-27",
"indexname": "DGS3",
"value":   0.41,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-02-28",
"indexname": "DGS3",
"value":   0.43,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-02-29",
"indexname": "DGS3",
"value":   0.43,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-03-01",
"indexname": "DGS3",
"value":   0.41,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-03-04",
"indexname": "DGS3",
"value":   0.43,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-03-05",
"indexname": "DGS3",
"value":    0.4,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-03-06",
"indexname": "DGS3",
"value":   0.42,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-03-07",
"indexname": "DGS3",
"value":   0.44,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-03-08",
"indexname": "DGS3",
"value":   0.46,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-03-11",
"indexname": "DGS3",
"value":   0.47,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-03-12",
"indexname": "DGS3",
"value":   0.51,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-03-13",
"indexname": "DGS3",
"value":    0.6,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-03-14",
"indexname": "DGS3",
"value":   0.56,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-03-15",
"indexname": "DGS3",
"value":   0.57,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-03-18",
"indexname": "DGS3",
"value":    0.6,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-03-19",
"indexname": "DGS3",
"value":   0.62,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-03-20",
"indexname": "DGS3",
"value":   0.58,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-03-21",
"indexname": "DGS3",
"value":   0.56,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-03-22",
"indexname": "DGS3",
"value":   0.55,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-03-25",
"indexname": "DGS3",
"value":   0.54,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-03-26",
"indexname": "DGS3",
"value":    0.5,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-03-27",
"indexname": "DGS3",
"value":   0.51,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-03-28",
"indexname": "DGS3",
"value":    0.5,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-03-29",
"indexname": "DGS3",
"value":   0.51,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-04-01",
"indexname": "DGS3",
"value":    0.5,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-04-02",
"indexname": "DGS3",
"value":   0.56,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-04-03",
"indexname": "DGS3",
"value":   0.53,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-04-04",
"indexname": "DGS3",
"value":    0.5,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-04-05",
"indexname": "DGS3",
"value":   0.45,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-04-08",
"indexname": "DGS3",
"value":   0.46,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-04-09",
"indexname": "DGS3",
"value":   0.42,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-04-10",
"indexname": "DGS3",
"value":   0.43,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-04-11",
"indexname": "DGS3",
"value":   0.43,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-04-12",
"indexname": "DGS3",
"value":   0.41,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-04-15",
"indexname": "DGS3",
"value":   0.42,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-04-16",
"indexname": "DGS3",
"value":   0.42,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-04-17",
"indexname": "DGS3",
"value":    0.4,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-04-18",
"indexname": "DGS3",
"value":    0.4,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-04-19",
"indexname": "DGS3",
"value":    0.4,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-04-22",
"indexname": "DGS3",
"value":   0.39,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-04-23",
"indexname": "DGS3",
"value":    0.4,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-04-24",
"indexname": "DGS3",
"value":   0.39,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-04-25",
"indexname": "DGS3",
"value":   0.39,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-04-26",
"indexname": "DGS3",
"value":   0.39,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-04-29",
"indexname": "DGS3",
"value":   0.38,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-04-30",
"indexname": "DGS3",
"value":   0.39,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-05-01",
"indexname": "DGS3",
"value":   0.39,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-05-02",
"indexname": "DGS3",
"value":    0.4,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-05-03",
"indexname": "DGS3",
"value":   0.37,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-05-06",
"indexname": "DGS3",
"value":   0.37,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-05-07",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-05-08",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-05-09",
"indexname": "DGS3",
"value":   0.37,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-05-10",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-05-13",
"indexname": "DGS3",
"value":   0.37,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-05-14",
"indexname": "DGS3",
"value":   0.38,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-05-15",
"indexname": "DGS3",
"value":    0.4,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-05-16",
"indexname": "DGS3",
"value":    0.4,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-05-17",
"indexname": "DGS3",
"value":   0.42,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-05-20",
"indexname": "DGS3",
"value":   0.41,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-05-21",
"indexname": "DGS3",
"value":   0.41,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-05-22",
"indexname": "DGS3",
"value":    0.4,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-05-23",
"indexname": "DGS3",
"value":   0.42,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-05-24",
"indexname": "DGS3",
"value":   0.41,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-05-28",
"indexname": "DGS3",
"value":   0.42,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-05-29",
"indexname": "DGS3",
"value":   0.38,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-05-30",
"indexname": "DGS3",
"value":   0.35,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-05-31",
"indexname": "DGS3",
"value":   0.34,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-06-03",
"indexname": "DGS3",
"value":   0.35,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-06-04",
"indexname": "DGS3",
"value":   0.34,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-06-05",
"indexname": "DGS3",
"value":   0.37,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-06-06",
"indexname": "DGS3",
"value":   0.37,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-06-07",
"indexname": "DGS3",
"value":   0.39,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-06-10",
"indexname": "DGS3",
"value":   0.37,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-06-11",
"indexname": "DGS3",
"value":   0.41,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-06-12",
"indexname": "DGS3",
"value":    0.4,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-06-13",
"indexname": "DGS3",
"value":   0.41,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-06-14",
"indexname": "DGS3",
"value":   0.37,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-06-17",
"indexname": "DGS3",
"value":   0.38,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-06-18",
"indexname": "DGS3",
"value":   0.39,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-06-19",
"indexname": "DGS3",
"value":   0.41,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-06-20",
"indexname": "DGS3",
"value":   0.41,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-06-21",
"indexname": "DGS3",
"value":   0.42,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-06-24",
"indexname": "DGS3",
"value":   0.39,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-06-25",
"indexname": "DGS3",
"value":   0.42,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-06-26",
"indexname": "DGS3",
"value":   0.42,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-06-27",
"indexname": "DGS3",
"value":    0.4,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-06-28",
"indexname": "DGS3",
"value":   0.41,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-07-01",
"indexname": "DGS3",
"value":   0.39,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-07-02",
"indexname": "DGS3",
"value":   0.39,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-07-04",
"indexname": "DGS3",
"value":   0.39,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-07-05",
"indexname": "DGS3",
"value":   0.37,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-07-08",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-07-09",
"indexname": "DGS3",
"value":   0.37,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-07-10",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-07-11",
"indexname": "DGS3",
"value":   0.35,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-07-12",
"indexname": "DGS3",
"value":   0.34,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-07-15",
"indexname": "DGS3",
"value":   0.31,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-07-16",
"indexname": "DGS3",
"value":   0.32,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-07-17",
"indexname": "DGS3",
"value":    0.3,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-07-18",
"indexname": "DGS3",
"value":   0.31,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-07-19",
"indexname": "DGS3",
"value":   0.29,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-07-22",
"indexname": "DGS3",
"value":   0.28,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-07-23",
"indexname": "DGS3",
"value":   0.28,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-07-24",
"indexname": "DGS3",
"value":   0.28,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-07-25",
"indexname": "DGS3",
"value":   0.31,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-07-26",
"indexname": "DGS3",
"value":   0.34,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-07-29",
"indexname": "DGS3",
"value":   0.31,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-07-30",
"indexname": "DGS3",
"value":    0.3,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-07-31",
"indexname": "DGS3",
"value":   0.32,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-08-01",
"indexname": "DGS3",
"value":   0.31,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-08-02",
"indexname": "DGS3",
"value":   0.33,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-08-05",
"indexname": "DGS3",
"value":   0.33,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-08-06",
"indexname": "DGS3",
"value":   0.37,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-08-07",
"indexname": "DGS3",
"value":   0.38,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-08-08",
"indexname": "DGS3",
"value":   0.38,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-08-09",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-08-12",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-08-13",
"indexname": "DGS3",
"value":   0.39,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-08-14",
"indexname": "DGS3",
"value":   0.42,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-08-15",
"indexname": "DGS3",
"value":   0.42,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-08-16",
"indexname": "DGS3",
"value":   0.42,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-08-19",
"indexname": "DGS3",
"value":   0.41,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-08-20",
"indexname": "DGS3",
"value":   0.42,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-08-21",
"indexname": "DGS3",
"value":   0.37,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-08-22",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-08-23",
"indexname": "DGS3",
"value":   0.37,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-08-26",
"indexname": "DGS3",
"value":   0.37,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-08-27",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-08-28",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-08-29",
"indexname": "DGS3",
"value":   0.35,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-08-30",
"indexname": "DGS3",
"value":    0.3,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-09-03",
"indexname": "DGS3",
"value":   0.31,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-09-04",
"indexname": "DGS3",
"value":   0.32,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-09-05",
"indexname": "DGS3",
"value":   0.34,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-09-06",
"indexname": "DGS3",
"value":   0.33,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-09-09",
"indexname": "DGS3",
"value":   0.33,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-09-10",
"indexname": "DGS3",
"value":   0.33,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-09-11",
"indexname": "DGS3",
"value":   0.33,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-09-12",
"indexname": "DGS3",
"value":   0.32,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-09-13",
"indexname": "DGS3",
"value":   0.35,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-09-16",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-09-17",
"indexname": "DGS3",
"value":   0.35,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-09-18",
"indexname": "DGS3",
"value":   0.35,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-09-19",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-09-20",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-09-23",
"indexname": "DGS3",
"value":   0.35,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-09-24",
"indexname": "DGS3",
"value":   0.35,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-09-25",
"indexname": "DGS3",
"value":   0.34,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-09-26",
"indexname": "DGS3",
"value":   0.34,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-09-27",
"indexname": "DGS3",
"value":   0.31,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-09-30",
"indexname": "DGS3",
"value":   0.31,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-10-01",
"indexname": "DGS3",
"value":   0.31,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-10-02",
"indexname": "DGS3",
"value":   0.31,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-10-03",
"indexname": "DGS3",
"value":   0.32,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-10-04",
"indexname": "DGS3",
"value":   0.34,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-10-08",
"indexname": "DGS3",
"value":   0.35,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-10-09",
"indexname": "DGS3",
"value":   0.35,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-10-10",
"indexname": "DGS3",
"value":   0.34,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-10-11",
"indexname": "DGS3",
"value":   0.34,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-10-14",
"indexname": "DGS3",
"value":   0.34,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-10-15",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-10-16",
"indexname": "DGS3",
"value":   0.41,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-10-17",
"indexname": "DGS3",
"value":   0.41,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-10-18",
"indexname": "DGS3",
"value":   0.41,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-10-21",
"indexname": "DGS3",
"value":   0.42,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-10-22",
"indexname": "DGS3",
"value":   0.41,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-10-23",
"indexname": "DGS3",
"value":    0.4,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-10-24",
"indexname": "DGS3",
"value":   0.43,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-10-25",
"indexname": "DGS3",
"value":   0.41,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-10-28",
"indexname": "DGS3",
"value":    0.4,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-10-30",
"indexname": "DGS3",
"value":   0.38,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-10-31",
"indexname": "DGS3",
"value":   0.38,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-11-01",
"indexname": "DGS3",
"value":   0.38,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-11-04",
"indexname": "DGS3",
"value":   0.38,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-11-05",
"indexname": "DGS3",
"value":   0.41,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-11-06",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-11-07",
"indexname": "DGS3",
"value":   0.35,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-11-08",
"indexname": "DGS3",
"value":   0.35,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-11-12",
"indexname": "DGS3",
"value":   0.33,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-11-13",
"indexname": "DGS3",
"value":   0.33,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-11-14",
"indexname": "DGS3",
"value":   0.32,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-11-15",
"indexname": "DGS3",
"value":   0.32,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-11-18",
"indexname": "DGS3",
"value":   0.33,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-11-19",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-11-20",
"indexname": "DGS3",
"value":   0.37,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-11-22",
"indexname": "DGS3",
"value":   0.37,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-11-25",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-11-26",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-11-27",
"indexname": "DGS3",
"value":   0.35,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-11-28",
"indexname": "DGS3",
"value":   0.35,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-11-29",
"indexname": "DGS3",
"value":   0.34,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-12-02",
"indexname": "DGS3",
"value":   0.34,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-12-03",
"indexname": "DGS3",
"value":   0.34,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-12-04",
"indexname": "DGS3",
"value":   0.32,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-12-05",
"indexname": "DGS3",
"value":   0.32,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-12-06",
"indexname": "DGS3",
"value":   0.33,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-12-09",
"indexname": "DGS3",
"value":   0.33,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-12-10",
"indexname": "DGS3",
"value":   0.32,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-12-11",
"indexname": "DGS3",
"value":   0.32,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-12-12",
"indexname": "DGS3",
"value":   0.34,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-12-13",
"indexname": "DGS3",
"value":   0.34,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-12-16",
"indexname": "DGS3",
"value":   0.37,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-12-17",
"indexname": "DGS3",
"value":   0.39,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-12-18",
"indexname": "DGS3",
"value":   0.39,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-12-19",
"indexname": "DGS3",
"value":   0.39,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-12-20",
"indexname": "DGS3",
"value":   0.38,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-12-23",
"indexname": "DGS3",
"value":   0.38,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-12-25",
"indexname": "DGS3",
"value":   0.39,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-12-26",
"indexname": "DGS3",
"value":   0.37,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-12-27",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-12-30",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-01-01",
"indexname": "DGS3",
"value":   0.37,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-01-02",
"indexname": "DGS3",
"value":    0.4,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-01-03",
"indexname": "DGS3",
"value":   0.41,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-01-06",
"indexname": "DGS3",
"value":   0.41,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-01-07",
"indexname": "DGS3",
"value":   0.38,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-01-08",
"indexname": "DGS3",
"value":   0.37,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-01-09",
"indexname": "DGS3",
"value":   0.37,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-01-10",
"indexname": "DGS3",
"value":   0.37,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-01-13",
"indexname": "DGS3",
"value":   0.37,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-01-14",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-01-15",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-01-16",
"indexname": "DGS3",
"value":   0.39,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-01-17",
"indexname": "DGS3",
"value":   0.38,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-01-21",
"indexname": "DGS3",
"value":   0.38,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-01-22",
"indexname": "DGS3",
"value":   0.37,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-01-23",
"indexname": "DGS3",
"value":   0.37,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-01-24",
"indexname": "DGS3",
"value":   0.42,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-01-27",
"indexname": "DGS3",
"value":   0.45,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-01-28",
"indexname": "DGS3",
"value":   0.43,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-01-29",
"indexname": "DGS3",
"value":   0.42,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-01-30",
"indexname": "DGS3",
"value":   0.42,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-01-31",
"indexname": "DGS3",
"value":    0.4,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-02-03",
"indexname": "DGS3",
"value":   0.38,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-02-04",
"indexname": "DGS3",
"value":   0.41,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-02-05",
"indexname": "DGS3",
"value":   0.39,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-02-06",
"indexname": "DGS3",
"value":   0.39,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-02-07",
"indexname": "DGS3",
"value":   0.39,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-02-10",
"indexname": "DGS3",
"value":    0.4,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-02-11",
"indexname": "DGS3",
"value":   0.41,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-02-12",
"indexname": "DGS3",
"value":   0.44,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-02-13",
"indexname": "DGS3",
"value":   0.42,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-02-14",
"indexname": "DGS3",
"value":   0.42,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-02-18",
"indexname": "DGS3",
"value":   0.44,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-02-19",
"indexname": "DGS3",
"value":   0.42,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-02-20",
"indexname": "DGS3",
"value":    0.4,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-02-21",
"indexname": "DGS3",
"value":    0.4,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-02-24",
"indexname": "DGS3",
"value":   0.37,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-02-25",
"indexname": "DGS3",
"value":   0.37,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-02-26",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-02-27",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-02-28",
"indexname": "DGS3",
"value":   0.35,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-03-03",
"indexname": "DGS3",
"value":   0.35,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-03-04",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-03-05",
"indexname": "DGS3",
"value":   0.38,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-03-06",
"indexname": "DGS3",
"value":    0.4,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-03-07",
"indexname": "DGS3",
"value":   0.42,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-03-10",
"indexname": "DGS3",
"value":   0.43,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-03-11",
"indexname": "DGS3",
"value":   0.41,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-03-12",
"indexname": "DGS3",
"value":   0.42,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-03-13",
"indexname": "DGS3",
"value":   0.42,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-03-14",
"indexname": "DGS3",
"value":    0.4,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-03-17",
"indexname": "DGS3",
"value":   0.38,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-03-18",
"indexname": "DGS3",
"value":   0.37,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-03-19",
"indexname": "DGS3",
"value":   0.38,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-03-20",
"indexname": "DGS3",
"value":   0.38,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-03-21",
"indexname": "DGS3",
"value":   0.39,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-03-24",
"indexname": "DGS3",
"value":   0.38,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-03-25",
"indexname": "DGS3",
"value":   0.38,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-03-26",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-03-27",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-03-31",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-04-01",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-04-02",
"indexname": "DGS3",
"value":   0.34,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-04-03",
"indexname": "DGS3",
"value":   0.33,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-04-04",
"indexname": "DGS3",
"value":   0.33,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-04-07",
"indexname": "DGS3",
"value":   0.34,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-04-08",
"indexname": "DGS3",
"value":   0.34,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-04-09",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-04-10",
"indexname": "DGS3",
"value":   0.35,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-04-11",
"indexname": "DGS3",
"value":   0.33,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-04-14",
"indexname": "DGS3",
"value":   0.32,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-04-15",
"indexname": "DGS3",
"value":   0.33,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-04-16",
"indexname": "DGS3",
"value":   0.35,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-04-17",
"indexname": "DGS3",
"value":   0.35,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-04-18",
"indexname": "DGS3",
"value":   0.35,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-04-21",
"indexname": "DGS3",
"value":   0.35,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-04-22",
"indexname": "DGS3",
"value":   0.35,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-04-23",
"indexname": "DGS3",
"value":   0.34,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-04-24",
"indexname": "DGS3",
"value":   0.35,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-04-25",
"indexname": "DGS3",
"value":   0.32,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-04-28",
"indexname": "DGS3",
"value":   0.32,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-04-29",
"indexname": "DGS3",
"value":   0.32,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-04-30",
"indexname": "DGS3",
"value":    0.3,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-05-01",
"indexname": "DGS3",
"value":    0.3,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-05-02",
"indexname": "DGS3",
"value":   0.34,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-05-05",
"indexname": "DGS3",
"value":   0.34,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-05-06",
"indexname": "DGS3",
"value":   0.35,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-05-07",
"indexname": "DGS3",
"value":   0.35,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-05-08",
"indexname": "DGS3",
"value":   0.35,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-05-09",
"indexname": "DGS3",
"value":   0.38,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-05-12",
"indexname": "DGS3",
"value":    0.4,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-05-13",
"indexname": "DGS3",
"value":   0.41,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-05-14",
"indexname": "DGS3",
"value":    0.4,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-05-15",
"indexname": "DGS3",
"value":   0.37,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-05-16",
"indexname": "DGS3",
"value":    0.4,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-05-19",
"indexname": "DGS3",
"value":    0.4,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-05-20",
"indexname": "DGS3",
"value":   0.39,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-05-21",
"indexname": "DGS3",
"value":   0.41,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-05-22",
"indexname": "DGS3",
"value":   0.42,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-05-23",
"indexname": "DGS3",
"value":   0.41,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-05-27",
"indexname": "DGS3",
"value":   0.49,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-05-28",
"indexname": "DGS3",
"value":   0.49,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-05-29",
"indexname": "DGS3",
"value":   0.49,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-05-30",
"indexname": "DGS3",
"value":   0.52,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-06-02",
"indexname": "DGS3",
"value":    0.5,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-06-03",
"indexname": "DGS3",
"value":   0.48,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-06-04",
"indexname": "DGS3",
"value":   0.48,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-06-05",
"indexname": "DGS3",
"value":   0.48,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-06-06",
"indexname": "DGS3",
"value":   0.52,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-06-09",
"indexname": "DGS3",
"value":   0.55,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-06-10",
"indexname": "DGS3",
"value":   0.57,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-06-11",
"indexname": "DGS3",
"value":   0.57,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-06-12",
"indexname": "DGS3",
"value":   0.55,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-06-13",
"indexname": "DGS3",
"value":   0.49,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-06-16",
"indexname": "DGS3",
"value":   0.49,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-06-17",
"indexname": "DGS3",
"value":   0.48,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-06-18",
"indexname": "DGS3",
"value":   0.58,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-06-19",
"indexname": "DGS3",
"value":   0.62,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-06-20",
"indexname": "DGS3",
"value":    0.7,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-06-23",
"indexname": "DGS3",
"value":   0.73,
"maturity":      3,
"country": "US" 
},
{
 "date": "2013-06-24",
"indexname": "DGS3",
"value":   0.74,
"maturity":      3,
"country": "US" 
},
{
 "date": "2012-01-02",
"indexname": "DGS5",
"value":   0.89,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-01-03",
"indexname": "DGS5",
"value":   0.89,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-01-04",
"indexname": "DGS5",
"value":   0.88,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-01-05",
"indexname": "DGS5",
"value":   0.86,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-01-08",
"indexname": "DGS5",
"value":   0.85,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-01-09",
"indexname": "DGS5",
"value":   0.86,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-01-10",
"indexname": "DGS5",
"value":   0.82,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-01-11",
"indexname": "DGS5",
"value":   0.84,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-01-12",
"indexname": "DGS5",
"value":    0.8,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-01-16",
"indexname": "DGS5",
"value":   0.79,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-01-17",
"indexname": "DGS5",
"value":   0.82,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-01-18",
"indexname": "DGS5",
"value":   0.87,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-01-19",
"indexname": "DGS5",
"value":   0.91,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-01-22",
"indexname": "DGS5",
"value":   0.93,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-01-23",
"indexname": "DGS5",
"value":   0.92,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-01-24",
"indexname": "DGS5",
"value":   0.81,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-01-25",
"indexname": "DGS5",
"value":   0.77,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-01-26",
"indexname": "DGS5",
"value":   0.75,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-01-29",
"indexname": "DGS5",
"value":   0.73,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-01-30",
"indexname": "DGS5",
"value":   0.71,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-01-31",
"indexname": "DGS5",
"value":   0.72,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-02-01",
"indexname": "DGS5",
"value":   0.71,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-02-02",
"indexname": "DGS5",
"value":   0.78,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-02-05",
"indexname": "DGS5",
"value":   0.76,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-02-06",
"indexname": "DGS5",
"value":   0.82,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-02-07",
"indexname": "DGS5",
"value":   0.82,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-02-08",
"indexname": "DGS5",
"value":   0.86,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-02-09",
"indexname": "DGS5",
"value":   0.81,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-02-12",
"indexname": "DGS5",
"value":   0.85,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-02-13",
"indexname": "DGS5",
"value":   0.81,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-02-14",
"indexname": "DGS5",
"value":   0.81,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-02-15",
"indexname": "DGS5",
"value":   0.87,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-02-16",
"indexname": "DGS5",
"value":   0.88,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-02-20",
"indexname": "DGS5",
"value":   0.92,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-02-21",
"indexname": "DGS5",
"value":   0.88,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-02-22",
"indexname": "DGS5",
"value":   0.88,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-02-23",
"indexname": "DGS5",
"value":   0.89,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-02-26",
"indexname": "DGS5",
"value":   0.84,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-02-27",
"indexname": "DGS5",
"value":   0.84,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-02-28",
"indexname": "DGS5",
"value":   0.87,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-02-29",
"indexname": "DGS5",
"value":   0.89,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-03-01",
"indexname": "DGS5",
"value":   0.84,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-03-04",
"indexname": "DGS5",
"value":   0.87,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-03-05",
"indexname": "DGS5",
"value":   0.83,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-03-06",
"indexname": "DGS5",
"value":   0.85,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-03-07",
"indexname": "DGS5",
"value":   0.89,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-03-08",
"indexname": "DGS5",
"value":    0.9,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-03-11",
"indexname": "DGS5",
"value":   0.92,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-03-12",
"indexname": "DGS5",
"value":   0.99,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-03-13",
"indexname": "DGS5",
"value":   1.13,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-03-14",
"indexname": "DGS5",
"value":   1.11,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-03-15",
"indexname": "DGS5",
"value":   1.13,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-03-18",
"indexname": "DGS5",
"value":    1.2,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-03-19",
"indexname": "DGS5",
"value":   1.22,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-03-20",
"indexname": "DGS5",
"value":   1.15,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-03-21",
"indexname": "DGS5",
"value":   1.13,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-03-22",
"indexname": "DGS5",
"value":    1.1,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-03-25",
"indexname": "DGS5",
"value":   1.09,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-03-26",
"indexname": "DGS5",
"value":   1.04,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-03-27",
"indexname": "DGS5",
"value":   1.05,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-03-28",
"indexname": "DGS5",
"value":   1.01,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-03-29",
"indexname": "DGS5",
"value":   1.04,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-04-01",
"indexname": "DGS5",
"value":   1.03,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-04-02",
"indexname": "DGS5",
"value":    1.1,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-04-03",
"indexname": "DGS5",
"value":   1.05,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-04-04",
"indexname": "DGS5",
"value":   1.01,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-04-05",
"indexname": "DGS5",
"value":   0.89,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-04-08",
"indexname": "DGS5",
"value":    0.9,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-04-09",
"indexname": "DGS5",
"value":   0.85,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-04-10",
"indexname": "DGS5",
"value":   0.89,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-04-11",
"indexname": "DGS5",
"value":    0.9,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-04-12",
"indexname": "DGS5",
"value":   0.86,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-04-15",
"indexname": "DGS5",
"value":   0.85,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-04-16",
"indexname": "DGS5",
"value":   0.88,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-04-17",
"indexname": "DGS5",
"value":   0.86,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-04-18",
"indexname": "DGS5",
"value":   0.84,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-04-19",
"indexname": "DGS5",
"value":   0.86,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-04-22",
"indexname": "DGS5",
"value":   0.83,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-04-23",
"indexname": "DGS5",
"value":   0.86,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-04-24",
"indexname": "DGS5",
"value":   0.86,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-04-25",
"indexname": "DGS5",
"value":   0.83,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-04-26",
"indexname": "DGS5",
"value":   0.82,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-04-29",
"indexname": "DGS5",
"value":   0.82,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-04-30",
"indexname": "DGS5",
"value":   0.84,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-05-01",
"indexname": "DGS5",
"value":   0.82,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-05-02",
"indexname": "DGS5",
"value":   0.82,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-05-03",
"indexname": "DGS5",
"value":   0.78,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-05-06",
"indexname": "DGS5",
"value":   0.79,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-05-07",
"indexname": "DGS5",
"value":   0.77,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-05-08",
"indexname": "DGS5",
"value":   0.77,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-05-09",
"indexname": "DGS5",
"value":   0.79,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-05-10",
"indexname": "DGS5",
"value":   0.75,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-05-13",
"indexname": "DGS5",
"value":   0.73,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-05-14",
"indexname": "DGS5",
"value":   0.74,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-05-15",
"indexname": "DGS5",
"value":   0.75,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-05-16",
"indexname": "DGS5",
"value":   0.74,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-05-17",
"indexname": "DGS5",
"value":   0.75,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-05-20",
"indexname": "DGS5",
"value":   0.75,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-05-21",
"indexname": "DGS5",
"value":   0.78,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-05-22",
"indexname": "DGS5",
"value":   0.74,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-05-23",
"indexname": "DGS5",
"value":   0.77,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-05-24",
"indexname": "DGS5",
"value":   0.76,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-05-28",
"indexname": "DGS5",
"value":   0.76,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-05-29",
"indexname": "DGS5",
"value":   0.69,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-05-30",
"indexname": "DGS5",
"value":   0.67,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-05-31",
"indexname": "DGS5",
"value":   0.62,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-06-03",
"indexname": "DGS5",
"value":   0.68,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-06-04",
"indexname": "DGS5",
"value":   0.68,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-06-05",
"indexname": "DGS5",
"value":   0.73,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-06-06",
"indexname": "DGS5",
"value":   0.72,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-06-07",
"indexname": "DGS5",
"value":   0.71,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-06-10",
"indexname": "DGS5",
"value":   0.69,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-06-11",
"indexname": "DGS5",
"value":   0.75,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-06-12",
"indexname": "DGS5",
"value":   0.71,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-06-13",
"indexname": "DGS5",
"value":   0.73,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-06-14",
"indexname": "DGS5",
"value":   0.68,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-06-17",
"indexname": "DGS5",
"value":   0.69,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-06-18",
"indexname": "DGS5",
"value":   0.71,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-06-19",
"indexname": "DGS5",
"value":   0.74,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-06-20",
"indexname": "DGS5",
"value":   0.73,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-06-21",
"indexname": "DGS5",
"value":   0.76,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-06-24",
"indexname": "DGS5",
"value":   0.72,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-06-25",
"indexname": "DGS5",
"value":   0.75,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-06-26",
"indexname": "DGS5",
"value":   0.73,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-06-27",
"indexname": "DGS5",
"value":   0.69,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-06-28",
"indexname": "DGS5",
"value":   0.72,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-07-01",
"indexname": "DGS5",
"value":   0.67,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-07-02",
"indexname": "DGS5",
"value":   0.69,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-07-04",
"indexname": "DGS5",
"value":   0.68,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-07-05",
"indexname": "DGS5",
"value":   0.64,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-07-08",
"indexname": "DGS5",
"value":   0.63,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-07-09",
"indexname": "DGS5",
"value":   0.63,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-07-10",
"indexname": "DGS5",
"value":   0.64,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-07-11",
"indexname": "DGS5",
"value":   0.63,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-07-12",
"indexname": "DGS5",
"value":   0.63,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-07-15",
"indexname": "DGS5",
"value":    0.6,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-07-16",
"indexname": "DGS5",
"value":   0.62,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-07-17",
"indexname": "DGS5",
"value":    0.6,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-07-18",
"indexname": "DGS5",
"value":   0.62,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-07-19",
"indexname": "DGS5",
"value":   0.59,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-07-22",
"indexname": "DGS5",
"value":   0.57,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-07-23",
"indexname": "DGS5",
"value":   0.57,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-07-24",
"indexname": "DGS5",
"value":   0.56,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-07-25",
"indexname": "DGS5",
"value":   0.58,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-07-26",
"indexname": "DGS5",
"value":   0.65,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-07-29",
"indexname": "DGS5",
"value":   0.61,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-07-30",
"indexname": "DGS5",
"value":    0.6,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-07-31",
"indexname": "DGS5",
"value":   0.63,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-08-01",
"indexname": "DGS5",
"value":   0.61,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-08-02",
"indexname": "DGS5",
"value":   0.67,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-08-05",
"indexname": "DGS5",
"value":   0.65,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-08-06",
"indexname": "DGS5",
"value":   0.71,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-08-07",
"indexname": "DGS5",
"value":   0.73,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-08-08",
"indexname": "DGS5",
"value":   0.74,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-08-09",
"indexname": "DGS5",
"value":   0.71,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-08-12",
"indexname": "DGS5",
"value":   0.71,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-08-13",
"indexname": "DGS5",
"value":   0.75,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-08-14",
"indexname": "DGS5",
"value":    0.8,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-08-15",
"indexname": "DGS5",
"value":   0.83,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-08-16",
"indexname": "DGS5",
"value":   0.81,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-08-19",
"indexname": "DGS5",
"value":    0.8,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-08-20",
"indexname": "DGS5",
"value":    0.8,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-08-21",
"indexname": "DGS5",
"value":   0.71,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-08-22",
"indexname": "DGS5",
"value":   0.71,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-08-23",
"indexname": "DGS5",
"value":   0.72,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-08-26",
"indexname": "DGS5",
"value":    0.7,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-08-27",
"indexname": "DGS5",
"value":   0.69,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-08-28",
"indexname": "DGS5",
"value":   0.69,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-08-29",
"indexname": "DGS5",
"value":   0.66,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-08-30",
"indexname": "DGS5",
"value":   0.59,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-09-03",
"indexname": "DGS5",
"value":   0.62,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-09-04",
"indexname": "DGS5",
"value":   0.62,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-09-05",
"indexname": "DGS5",
"value":   0.68,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-09-06",
"indexname": "DGS5",
"value":   0.64,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-09-09",
"indexname": "DGS5",
"value":   0.66,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-09-10",
"indexname": "DGS5",
"value":   0.67,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-09-11",
"indexname": "DGS5",
"value":    0.7,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-09-12",
"indexname": "DGS5",
"value":   0.65,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-09-13",
"indexname": "DGS5",
"value":   0.72,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-09-16",
"indexname": "DGS5",
"value":   0.73,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-09-17",
"indexname": "DGS5",
"value":   0.71,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-09-18",
"indexname": "DGS5",
"value":    0.7,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-09-19",
"indexname": "DGS5",
"value":    0.7,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-09-20",
"indexname": "DGS5",
"value":   0.68,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-09-23",
"indexname": "DGS5",
"value":   0.68,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-09-24",
"indexname": "DGS5",
"value":   0.66,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-09-25",
"indexname": "DGS5",
"value":   0.63,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-09-26",
"indexname": "DGS5",
"value":   0.64,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-09-27",
"indexname": "DGS5",
"value":   0.62,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-09-30",
"indexname": "DGS5",
"value":   0.62,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-10-01",
"indexname": "DGS5",
"value":   0.61,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-10-02",
"indexname": "DGS5",
"value":   0.61,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-10-03",
"indexname": "DGS5",
"value":   0.63,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-10-04",
"indexname": "DGS5",
"value":   0.67,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-10-08",
"indexname": "DGS5",
"value":   0.67,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-10-09",
"indexname": "DGS5",
"value":   0.66,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-10-10",
"indexname": "DGS5",
"value":   0.67,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-10-11",
"indexname": "DGS5",
"value":   0.67,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-10-14",
"indexname": "DGS5",
"value":   0.67,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-10-15",
"indexname": "DGS5",
"value":    0.7,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-10-16",
"indexname": "DGS5",
"value":   0.78,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-10-17",
"indexname": "DGS5",
"value":   0.79,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-10-18",
"indexname": "DGS5",
"value":   0.77,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-10-21",
"indexname": "DGS5",
"value":   0.79,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-10-22",
"indexname": "DGS5",
"value":   0.77,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-10-23",
"indexname": "DGS5",
"value":   0.76,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-10-24",
"indexname": "DGS5",
"value":   0.82,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-10-25",
"indexname": "DGS5",
"value":   0.76,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-10-28",
"indexname": "DGS5",
"value":   0.74,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-10-30",
"indexname": "DGS5",
"value":   0.72,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-10-31",
"indexname": "DGS5",
"value":   0.73,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-11-01",
"indexname": "DGS5",
"value":   0.73,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-11-04",
"indexname": "DGS5",
"value":    0.7,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-11-05",
"indexname": "DGS5",
"value":   0.75,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-11-06",
"indexname": "DGS5",
"value":   0.67,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-11-07",
"indexname": "DGS5",
"value":   0.65,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-11-08",
"indexname": "DGS5",
"value":   0.65,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-11-12",
"indexname": "DGS5",
"value":   0.63,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-11-13",
"indexname": "DGS5",
"value":   0.63,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-11-14",
"indexname": "DGS5",
"value":   0.62,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-11-15",
"indexname": "DGS5",
"value":   0.62,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-11-18",
"indexname": "DGS5",
"value":   0.64,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-11-19",
"indexname": "DGS5",
"value":   0.67,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-11-20",
"indexname": "DGS5",
"value":   0.69,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-11-22",
"indexname": "DGS5",
"value":    0.7,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-11-25",
"indexname": "DGS5",
"value":   0.68,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-11-26",
"indexname": "DGS5",
"value":   0.66,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-11-27",
"indexname": "DGS5",
"value":   0.64,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-11-28",
"indexname": "DGS5",
"value":   0.63,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-11-29",
"indexname": "DGS5",
"value":   0.61,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-12-02",
"indexname": "DGS5",
"value":   0.63,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-12-03",
"indexname": "DGS5",
"value":   0.63,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-12-04",
"indexname": "DGS5",
"value":   0.61,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-12-05",
"indexname": "DGS5",
"value":    0.6,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-12-06",
"indexname": "DGS5",
"value":   0.63,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-12-09",
"indexname": "DGS5",
"value":   0.62,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-12-10",
"indexname": "DGS5",
"value":   0.64,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-12-11",
"indexname": "DGS5",
"value":   0.66,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-12-12",
"indexname": "DGS5",
"value":    0.7,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-12-13",
"indexname": "DGS5",
"value":    0.7,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-12-16",
"indexname": "DGS5",
"value":   0.74,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-12-17",
"indexname": "DGS5",
"value":   0.78,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-12-18",
"indexname": "DGS5",
"value":   0.77,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-12-19",
"indexname": "DGS5",
"value":   0.77,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-12-20",
"indexname": "DGS5",
"value":   0.75,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-12-23",
"indexname": "DGS5",
"value":   0.77,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-12-25",
"indexname": "DGS5",
"value":   0.76,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-12-26",
"indexname": "DGS5",
"value":   0.72,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-12-27",
"indexname": "DGS5",
"value":   0.72,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-12-30",
"indexname": "DGS5",
"value":   0.72,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-01-01",
"indexname": "DGS5",
"value":   0.76,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-01-02",
"indexname": "DGS5",
"value":   0.81,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-01-03",
"indexname": "DGS5",
"value":   0.82,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-01-06",
"indexname": "DGS5",
"value":   0.82,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-01-07",
"indexname": "DGS5",
"value":   0.79,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-01-08",
"indexname": "DGS5",
"value":   0.77,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-01-09",
"indexname": "DGS5",
"value":    0.8,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-01-10",
"indexname": "DGS5",
"value":   0.78,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-01-13",
"indexname": "DGS5",
"value":   0.78,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-01-14",
"indexname": "DGS5",
"value":   0.75,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-01-15",
"indexname": "DGS5",
"value":   0.75,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-01-16",
"indexname": "DGS5",
"value":   0.79,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-01-17",
"indexname": "DGS5",
"value":   0.77,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-01-21",
"indexname": "DGS5",
"value":   0.76,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-01-22",
"indexname": "DGS5",
"value":   0.76,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-01-23",
"indexname": "DGS5",
"value":   0.78,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-01-24",
"indexname": "DGS5",
"value":   0.87,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-01-27",
"indexname": "DGS5",
"value":   0.89,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-01-28",
"indexname": "DGS5",
"value":    0.9,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-01-29",
"indexname": "DGS5",
"value":   0.88,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-01-30",
"indexname": "DGS5",
"value":   0.88,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-01-31",
"indexname": "DGS5",
"value":   0.88,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-02-03",
"indexname": "DGS5",
"value":   0.85,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-02-04",
"indexname": "DGS5",
"value":   0.88,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-02-05",
"indexname": "DGS5",
"value":   0.84,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-02-06",
"indexname": "DGS5",
"value":   0.83,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-02-07",
"indexname": "DGS5",
"value":   0.84,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-02-10",
"indexname": "DGS5",
"value":   0.85,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-02-11",
"indexname": "DGS5",
"value":   0.88,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-02-12",
"indexname": "DGS5",
"value":   0.92,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-02-13",
"indexname": "DGS5",
"value":   0.86,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-02-14",
"indexname": "DGS5",
"value":   0.87,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-02-18",
"indexname": "DGS5",
"value":   0.89,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-02-19",
"indexname": "DGS5",
"value":   0.88,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-02-20",
"indexname": "DGS5",
"value":   0.86,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-02-21",
"indexname": "DGS5",
"value":   0.84,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-02-24",
"indexname": "DGS5",
"value":   0.78,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-02-25",
"indexname": "DGS5",
"value":   0.78,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-02-26",
"indexname": "DGS5",
"value":   0.78,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-02-27",
"indexname": "DGS5",
"value":   0.77,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-02-28",
"indexname": "DGS5",
"value":   0.75,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-03-03",
"indexname": "DGS5",
"value":   0.76,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-03-04",
"indexname": "DGS5",
"value":   0.77,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-03-05",
"indexname": "DGS5",
"value":   0.81,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-03-06",
"indexname": "DGS5",
"value":   0.85,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-03-07",
"indexname": "DGS5",
"value":    0.9,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-03-10",
"indexname": "DGS5",
"value":    0.9,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-03-11",
"indexname": "DGS5",
"value":   0.88,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-03-12",
"indexname": "DGS5",
"value":   0.89,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-03-13",
"indexname": "DGS5",
"value":   0.88,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-03-14",
"indexname": "DGS5",
"value":   0.84,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-03-17",
"indexname": "DGS5",
"value":   0.81,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-03-18",
"indexname": "DGS5",
"value":   0.79,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-03-19",
"indexname": "DGS5",
"value":   0.81,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-03-20",
"indexname": "DGS5",
"value":   0.81,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-03-21",
"indexname": "DGS5",
"value":    0.8,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-03-24",
"indexname": "DGS5",
"value":    0.8,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-03-25",
"indexname": "DGS5",
"value":   0.79,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-03-26",
"indexname": "DGS5",
"value":   0.76,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-03-27",
"indexname": "DGS5",
"value":   0.77,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-03-31",
"indexname": "DGS5",
"value":   0.76,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-04-01",
"indexname": "DGS5",
"value":   0.78,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-04-02",
"indexname": "DGS5",
"value":   0.73,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-04-03",
"indexname": "DGS5",
"value":   0.69,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-04-04",
"indexname": "DGS5",
"value":   0.68,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-04-07",
"indexname": "DGS5",
"value":   0.71,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-04-08",
"indexname": "DGS5",
"value":    0.7,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-04-09",
"indexname": "DGS5",
"value":   0.74,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-04-10",
"indexname": "DGS5",
"value":   0.74,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-04-11",
"indexname": "DGS5",
"value":    0.7,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-04-14",
"indexname": "DGS5",
"value":   0.69,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-04-15",
"indexname": "DGS5",
"value":   0.71,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-04-16",
"indexname": "DGS5",
"value":   0.71,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-04-17",
"indexname": "DGS5",
"value":   0.71,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-04-18",
"indexname": "DGS5",
"value":   0.72,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-04-21",
"indexname": "DGS5",
"value":    0.7,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-04-22",
"indexname": "DGS5",
"value":   0.71,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-04-23",
"indexname": "DGS5",
"value":    0.7,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-04-24",
"indexname": "DGS5",
"value":   0.71,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-04-25",
"indexname": "DGS5",
"value":   0.68,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-04-28",
"indexname": "DGS5",
"value":   0.68,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-04-29",
"indexname": "DGS5",
"value":   0.68,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-04-30",
"indexname": "DGS5",
"value":   0.65,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-05-01",
"indexname": "DGS5",
"value":   0.65,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-05-02",
"indexname": "DGS5",
"value":   0.73,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-05-05",
"indexname": "DGS5",
"value":   0.74,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-05-06",
"indexname": "DGS5",
"value":   0.75,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-05-07",
"indexname": "DGS5",
"value":   0.75,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-05-08",
"indexname": "DGS5",
"value":   0.75,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-05-09",
"indexname": "DGS5",
"value":   0.82,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-05-12",
"indexname": "DGS5",
"value":   0.83,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-05-13",
"indexname": "DGS5",
"value":   0.85,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-05-14",
"indexname": "DGS5",
"value":   0.84,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-05-15",
"indexname": "DGS5",
"value":   0.79,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-05-16",
"indexname": "DGS5",
"value":   0.84,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-05-19",
"indexname": "DGS5",
"value":   0.85,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-05-20",
"indexname": "DGS5",
"value":   0.84,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-05-21",
"indexname": "DGS5",
"value":   0.91,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-05-22",
"indexname": "DGS5",
"value":   0.91,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-05-23",
"indexname": "DGS5",
"value":    0.9,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-05-27",
"indexname": "DGS5",
"value":   1.02,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-05-28",
"indexname": "DGS5",
"value":   1.02,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-05-29",
"indexname": "DGS5",
"value":   1.01,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-05-30",
"indexname": "DGS5",
"value":   1.05,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-06-02",
"indexname": "DGS5",
"value":   1.03,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-06-03",
"indexname": "DGS5",
"value":   1.05,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-06-04",
"indexname": "DGS5",
"value":   1.02,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-06-05",
"indexname": "DGS5",
"value":   1.01,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-06-06",
"indexname": "DGS5",
"value":    1.1,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-06-09",
"indexname": "DGS5",
"value":   1.13,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-06-10",
"indexname": "DGS5",
"value":   1.12,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-06-11",
"indexname": "DGS5",
"value":   1.15,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-06-12",
"indexname": "DGS5",
"value":   1.11,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-06-13",
"indexname": "DGS5",
"value":   1.04,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-06-16",
"indexname": "DGS5",
"value":   1.06,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-06-17",
"indexname": "DGS5",
"value":   1.07,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-06-18",
"indexname": "DGS5",
"value":   1.24,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-06-19",
"indexname": "DGS5",
"value":   1.31,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-06-20",
"indexname": "DGS5",
"value":   1.42,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-06-23",
"indexname": "DGS5",
"value":   1.48,
"maturity":      5,
"country": "US" 
},
{
 "date": "2013-06-24",
"indexname": "DGS5",
"value":   1.49,
"maturity":      5,
"country": "US" 
},
{
 "date": "2012-01-02",
"indexname": "DGS7",
"value":   1.41,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-01-03",
"indexname": "DGS7",
"value":   1.43,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-01-04",
"indexname": "DGS7",
"value":   1.43,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-01-05",
"indexname": "DGS7",
"value":    1.4,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-01-08",
"indexname": "DGS7",
"value":   1.39,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-01-09",
"indexname": "DGS7",
"value":   1.41,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-01-10",
"indexname": "DGS7",
"value":   1.34,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-01-11",
"indexname": "DGS7",
"value":   1.37,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-01-12",
"indexname": "DGS7",
"value":   1.32,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-01-16",
"indexname": "DGS7",
"value":   1.31,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-01-17",
"indexname": "DGS7",
"value":   1.34,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-01-18",
"indexname": "DGS7",
"value":   1.43,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-01-19",
"indexname": "DGS7",
"value":   1.47,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-01-22",
"indexname": "DGS7",
"value":   1.51,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-01-23",
"indexname": "DGS7",
"value":   1.49,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-01-24",
"indexname": "DGS7",
"value":    1.4,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-01-25",
"indexname": "DGS7",
"value":   1.34,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-01-26",
"indexname": "DGS7",
"value":   1.31,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-01-29",
"indexname": "DGS7",
"value":   1.27,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-01-30",
"indexname": "DGS7",
"value":   1.24,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-01-31",
"indexname": "DGS7",
"value":   1.27,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-02-01",
"indexname": "DGS7",
"value":   1.25,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-02-02",
"indexname": "DGS7",
"value":   1.35,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-02-05",
"indexname": "DGS7",
"value":   1.32,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-02-06",
"indexname": "DGS7",
"value":   1.39,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-02-07",
"indexname": "DGS7",
"value":   1.39,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-02-08",
"indexname": "DGS7",
"value":   1.43,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-02-09",
"indexname": "DGS7",
"value":   1.36,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-02-12",
"indexname": "DGS7",
"value":    1.4,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-02-13",
"indexname": "DGS7",
"value":   1.34,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-02-14",
"indexname": "DGS7",
"value":   1.34,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-02-15",
"indexname": "DGS7",
"value":   1.41,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-02-16",
"indexname": "DGS7",
"value":   1.43,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-02-20",
"indexname": "DGS7",
"value":   1.47,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-02-21",
"indexname": "DGS7",
"value":   1.41,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-02-22",
"indexname": "DGS7",
"value":    1.4,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-02-23",
"indexname": "DGS7",
"value":   1.41,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-02-26",
"indexname": "DGS7",
"value":   1.35,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-02-27",
"indexname": "DGS7",
"value":   1.36,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-02-28",
"indexname": "DGS7",
"value":   1.39,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-02-29",
"indexname": "DGS7",
"value":   1.44,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-03-01",
"indexname": "DGS7",
"value":   1.38,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-03-04",
"indexname": "DGS7",
"value":    1.4,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-03-05",
"indexname": "DGS7",
"value":   1.35,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-03-06",
"indexname": "DGS7",
"value":   1.37,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-03-07",
"indexname": "DGS7",
"value":   1.41,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-03-08",
"indexname": "DGS7",
"value":   1.43,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-03-11",
"indexname": "DGS7",
"value":   1.43,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-03-12",
"indexname": "DGS7",
"value":   1.52,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-03-13",
"indexname": "DGS7",
"value":   1.69,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-03-14",
"indexname": "DGS7",
"value":   1.67,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-03-15",
"indexname": "DGS7",
"value":    1.7,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-03-18",
"indexname": "DGS7",
"value":   1.77,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-03-19",
"indexname": "DGS7",
"value":   1.78,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-03-20",
"indexname": "DGS7",
"value":   1.71,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-03-21",
"indexname": "DGS7",
"value":   1.69,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-03-22",
"indexname": "DGS7",
"value":   1.66,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-03-25",
"indexname": "DGS7",
"value":   1.65,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-03-26",
"indexname": "DGS7",
"value":   1.59,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-03-27",
"indexname": "DGS7",
"value":    1.6,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-03-28",
"indexname": "DGS7",
"value":   1.57,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-03-29",
"indexname": "DGS7",
"value":   1.61,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-04-01",
"indexname": "DGS7",
"value":    1.6,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-04-02",
"indexname": "DGS7",
"value":   1.68,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-04-03",
"indexname": "DGS7",
"value":   1.62,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-04-04",
"indexname": "DGS7",
"value":   1.56,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-04-05",
"indexname": "DGS7",
"value":   1.42,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-04-08",
"indexname": "DGS7",
"value":   1.42,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-04-09",
"indexname": "DGS7",
"value":   1.37,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-04-10",
"indexname": "DGS7",
"value":   1.41,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-04-11",
"indexname": "DGS7",
"value":   1.44,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-04-12",
"indexname": "DGS7",
"value":   1.39,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-04-15",
"indexname": "DGS7",
"value":   1.37,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-04-16",
"indexname": "DGS7",
"value":    1.4,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-04-17",
"indexname": "DGS7",
"value":   1.38,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-04-18",
"indexname": "DGS7",
"value":   1.37,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-04-19",
"indexname": "DGS7",
"value":   1.38,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-04-22",
"indexname": "DGS7",
"value":   1.34,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-04-23",
"indexname": "DGS7",
"value":   1.37,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-04-24",
"indexname": "DGS7",
"value":   1.38,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-04-25",
"indexname": "DGS7",
"value":   1.36,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-04-26",
"indexname": "DGS7",
"value":   1.34,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-04-29",
"indexname": "DGS7",
"value":   1.33,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-04-30",
"indexname": "DGS7",
"value":   1.35,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-05-01",
"indexname": "DGS7",
"value":   1.33,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-05-02",
"indexname": "DGS7",
"value":   1.34,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-05-03",
"indexname": "DGS7",
"value":   1.28,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-05-06",
"indexname": "DGS7",
"value":   1.29,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-05-07",
"indexname": "DGS7",
"value":   1.26,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-05-08",
"indexname": "DGS7",
"value":   1.26,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-05-09",
"indexname": "DGS7",
"value":   1.28,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-05-10",
"indexname": "DGS7",
"value":   1.24,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-05-13",
"indexname": "DGS7",
"value":    1.2,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-05-14",
"indexname": "DGS7",
"value":   1.19,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-05-15",
"indexname": "DGS7",
"value":   1.19,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-05-16",
"indexname": "DGS7",
"value":   1.16,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-05-17",
"indexname": "DGS7",
"value":   1.16,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-05-20",
"indexname": "DGS7",
"value":   1.18,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-05-21",
"indexname": "DGS7",
"value":    1.2,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-05-22",
"indexname": "DGS7",
"value":   1.15,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-05-23",
"indexname": "DGS7",
"value":    1.2,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-05-24",
"indexname": "DGS7",
"value":   1.17,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-05-28",
"indexname": "DGS7",
"value":   1.17,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-05-29",
"indexname": "DGS7",
"value":   1.06,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-05-30",
"indexname": "DGS7",
"value":   1.03,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-05-31",
"indexname": "DGS7",
"value":   0.93,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-06-03",
"indexname": "DGS7",
"value":   1.01,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-06-04",
"indexname": "DGS7",
"value":   1.04,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-06-05",
"indexname": "DGS7",
"value":   1.11,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-06-06",
"indexname": "DGS7",
"value":    1.1,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-06-07",
"indexname": "DGS7",
"value":   1.09,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-06-10",
"indexname": "DGS7",
"value":   1.05,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-06-11",
"indexname": "DGS7",
"value":   1.12,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-06-12",
"indexname": "DGS7",
"value":   1.06,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-06-13",
"indexname": "DGS7",
"value":    1.1,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-06-14",
"indexname": "DGS7",
"value":   1.06,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-06-17",
"indexname": "DGS7",
"value":   1.06,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-06-18",
"indexname": "DGS7",
"value":   1.09,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-06-19",
"indexname": "DGS7",
"value":   1.12,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-06-20",
"indexname": "DGS7",
"value":    1.1,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-06-21",
"indexname": "DGS7",
"value":   1.15,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-06-24",
"indexname": "DGS7",
"value":    1.1,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-06-25",
"indexname": "DGS7",
"value":   1.12,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-06-26",
"indexname": "DGS7",
"value":    1.1,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-06-27",
"indexname": "DGS7",
"value":   1.06,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-06-28",
"indexname": "DGS7",
"value":   1.11,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-07-01",
"indexname": "DGS7",
"value":   1.04,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-07-02",
"indexname": "DGS7",
"value":   1.08,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-07-04",
"indexname": "DGS7",
"value":   1.05,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-07-05",
"indexname": "DGS7",
"value":   1.01,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-07-08",
"indexname": "DGS7",
"value":   0.98,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-07-09",
"indexname": "DGS7",
"value":   0.98,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-07-10",
"indexname": "DGS7",
"value":   0.99,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-07-11",
"indexname": "DGS7",
"value":   0.98,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-07-12",
"indexname": "DGS7",
"value":   0.99,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-07-15",
"indexname": "DGS7",
"value":   0.97,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-07-16",
"indexname": "DGS7",
"value":   0.99,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-07-17",
"indexname": "DGS7",
"value":   0.97,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-07-18",
"indexname": "DGS7",
"value":   0.99,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-07-19",
"indexname": "DGS7",
"value":   0.95,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-07-22",
"indexname": "DGS7",
"value":   0.93,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-07-23",
"indexname": "DGS7",
"value":   0.91,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-07-24",
"indexname": "DGS7",
"value":   0.91,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-07-25",
"indexname": "DGS7",
"value":   0.94,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-07-26",
"indexname": "DGS7",
"value":   1.04,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-07-29",
"indexname": "DGS7",
"value":   0.99,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-07-30",
"indexname": "DGS7",
"value":   0.98,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-07-31",
"indexname": "DGS7",
"value":   1.03,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-08-01",
"indexname": "DGS7",
"value":   0.98,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-08-02",
"indexname": "DGS7",
"value":   1.07,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-08-05",
"indexname": "DGS7",
"value":   1.05,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-08-06",
"indexname": "DGS7",
"value":   1.13,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-08-07",
"indexname": "DGS7",
"value":   1.14,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-08-08",
"indexname": "DGS7",
"value":   1.15,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-08-09",
"indexname": "DGS7",
"value":   1.11,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-08-12",
"indexname": "DGS7",
"value":   1.12,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-08-13",
"indexname": "DGS7",
"value":   1.18,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-08-14",
"indexname": "DGS7",
"value":   1.25,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-08-15",
"indexname": "DGS7",
"value":   1.28,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-08-16",
"indexname": "DGS7",
"value":   1.27,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-08-19",
"indexname": "DGS7",
"value":   1.26,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-08-20",
"indexname": "DGS7",
"value":   1.25,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-08-21",
"indexname": "DGS7",
"value":   1.16,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-08-22",
"indexname": "DGS7",
"value":   1.13,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-08-23",
"indexname": "DGS7",
"value":   1.14,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-08-26",
"indexname": "DGS7",
"value":   1.11,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-08-27",
"indexname": "DGS7",
"value":    1.1,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-08-28",
"indexname": "DGS7",
"value":   1.11,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-08-29",
"indexname": "DGS7",
"value":   1.08,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-08-30",
"indexname": "DGS7",
"value":   1.01,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-09-03",
"indexname": "DGS7",
"value":   1.03,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-09-04",
"indexname": "DGS7",
"value":   1.04,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-09-05",
"indexname": "DGS7",
"value":   1.12,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-09-06",
"indexname": "DGS7",
"value":   1.09,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-09-09",
"indexname": "DGS7",
"value":    1.1,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-09-10",
"indexname": "DGS7",
"value":   1.12,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-09-11",
"indexname": "DGS7",
"value":   1.17,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-09-12",
"indexname": "DGS7",
"value":   1.12,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-09-13",
"indexname": "DGS7",
"value":   1.23,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-09-16",
"indexname": "DGS7",
"value":   1.22,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-09-17",
"indexname": "DGS7",
"value":   1.19,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-09-18",
"indexname": "DGS7",
"value":   1.18,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-09-19",
"indexname": "DGS7",
"value":   1.18,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-09-20",
"indexname": "DGS7",
"value":   1.14,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-09-23",
"indexname": "DGS7",
"value":   1.12,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-09-24",
"indexname": "DGS7",
"value":   1.08,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-09-25",
"indexname": "DGS7",
"value":   1.03,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-09-26",
"indexname": "DGS7",
"value":   1.05,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-09-27",
"indexname": "DGS7",
"value":   1.04,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-09-30",
"indexname": "DGS7",
"value":   1.04,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-10-01",
"indexname": "DGS7",
"value":   1.03,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-10-02",
"indexname": "DGS7",
"value":   1.02,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-10-03",
"indexname": "DGS7",
"value":   1.07,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-10-04",
"indexname": "DGS7",
"value":   1.12,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-10-08",
"indexname": "DGS7",
"value":   1.11,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-10-09",
"indexname": "DGS7",
"value":   1.09,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-10-10",
"indexname": "DGS7",
"value":   1.09,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-10-11",
"indexname": "DGS7",
"value":   1.09,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-10-14",
"indexname": "DGS7",
"value":   1.09,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-10-15",
"indexname": "DGS7",
"value":   1.15,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-10-16",
"indexname": "DGS7",
"value":   1.24,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-10-17",
"indexname": "DGS7",
"value":   1.26,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-10-18",
"indexname": "DGS7",
"value":   1.21,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-10-21",
"indexname": "DGS7",
"value":   1.25,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-10-22",
"indexname": "DGS7",
"value":   1.21,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-10-23",
"indexname": "DGS7",
"value":   1.21,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-10-24",
"indexname": "DGS7",
"value":   1.28,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-10-25",
"indexname": "DGS7",
"value":    1.2,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-10-28",
"indexname": "DGS7",
"value":   1.16,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-10-30",
"indexname": "DGS7",
"value":   1.14,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-10-31",
"indexname": "DGS7",
"value":   1.16,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-11-01",
"indexname": "DGS7",
"value":   1.16,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-11-04",
"indexname": "DGS7",
"value":   1.13,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-11-05",
"indexname": "DGS7",
"value":   1.19,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-11-06",
"indexname": "DGS7",
"value":   1.08,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-11-07",
"indexname": "DGS7",
"value":   1.04,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-11-08",
"indexname": "DGS7",
"value":   1.04,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-11-12",
"indexname": "DGS7",
"value":   1.02,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-11-13",
"indexname": "DGS7",
"value":   1.03,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-11-14",
"indexname": "DGS7",
"value":   1.02,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-11-15",
"indexname": "DGS7",
"value":   1.01,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-11-18",
"indexname": "DGS7",
"value":   1.04,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-11-19",
"indexname": "DGS7",
"value":   1.09,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-11-20",
"indexname": "DGS7",
"value":   1.11,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-11-22",
"indexname": "DGS7",
"value":   1.12,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-11-25",
"indexname": "DGS7",
"value":   1.09,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-11-26",
"indexname": "DGS7",
"value":   1.07,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-11-27",
"indexname": "DGS7",
"value":   1.05,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-11-28",
"indexname": "DGS7",
"value":   1.04,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-11-29",
"indexname": "DGS7",
"value":   1.04,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-12-02",
"indexname": "DGS7",
"value":   1.05,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-12-03",
"indexname": "DGS7",
"value":   1.04,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-12-04",
"indexname": "DGS7",
"value":   1.02,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-12-05",
"indexname": "DGS7",
"value":      1,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-12-06",
"indexname": "DGS7",
"value":   1.04,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-12-09",
"indexname": "DGS7",
"value":   1.04,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-12-10",
"indexname": "DGS7",
"value":   1.06,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-12-11",
"indexname": "DGS7",
"value":   1.11,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-12-12",
"indexname": "DGS7",
"value":   1.15,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-12-13",
"indexname": "DGS7",
"value":   1.15,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-12-16",
"indexname": "DGS7",
"value":    1.2,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-12-17",
"indexname": "DGS7",
"value":   1.25,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-12-18",
"indexname": "DGS7",
"value":   1.24,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-12-19",
"indexname": "DGS7",
"value":   1.24,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-12-20",
"indexname": "DGS7",
"value":    1.2,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-12-23",
"indexname": "DGS7",
"value":   1.22,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-12-25",
"indexname": "DGS7",
"value":    1.2,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-12-26",
"indexname": "DGS7",
"value":   1.15,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-12-27",
"indexname": "DGS7",
"value":   1.15,
"maturity":      7,
"country": "US" 
},
{
 "date": "2012-12-30",
"indexname": "DGS7",
"value":   1.18,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-01-01",
"indexname": "DGS7",
"value":   1.25,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-01-02",
"indexname": "DGS7",
"value":   1.31,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-01-03",
"indexname": "DGS7",
"value":   1.32,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-01-06",
"indexname": "DGS7",
"value":   1.31,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-01-07",
"indexname": "DGS7",
"value":   1.28,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-01-08",
"indexname": "DGS7",
"value":   1.27,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-01-09",
"indexname": "DGS7",
"value":    1.3,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-01-10",
"indexname": "DGS7",
"value":   1.28,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-01-13",
"indexname": "DGS7",
"value":   1.27,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-01-14",
"indexname": "DGS7",
"value":   1.24,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-01-15",
"indexname": "DGS7",
"value":   1.23,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-01-16",
"indexname": "DGS7",
"value":   1.29,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-01-17",
"indexname": "DGS7",
"value":   1.26,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-01-21",
"indexname": "DGS7",
"value":   1.25,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-01-22",
"indexname": "DGS7",
"value":   1.24,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-01-23",
"indexname": "DGS7",
"value":   1.26,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-01-24",
"indexname": "DGS7",
"value":   1.36,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-01-27",
"indexname": "DGS7",
"value":   1.38,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-01-28",
"indexname": "DGS7",
"value":    1.4,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-01-29",
"indexname": "DGS7",
"value":   1.39,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-01-30",
"indexname": "DGS7",
"value":   1.38,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-01-31",
"indexname": "DGS7",
"value":    1.4,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-02-03",
"indexname": "DGS7",
"value":   1.36,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-02-04",
"indexname": "DGS7",
"value":   1.39,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-02-05",
"indexname": "DGS7",
"value":   1.35,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-02-06",
"indexname": "DGS7",
"value":   1.34,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-02-07",
"indexname": "DGS7",
"value":   1.34,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-02-10",
"indexname": "DGS7",
"value":   1.35,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-02-11",
"indexname": "DGS7",
"value":   1.38,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-02-12",
"indexname": "DGS7",
"value":   1.43,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-02-13",
"indexname": "DGS7",
"value":   1.37,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-02-14",
"indexname": "DGS7",
"value":   1.38,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-02-18",
"indexname": "DGS7",
"value":   1.41,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-02-19",
"indexname": "DGS7",
"value":   1.38,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-02-20",
"indexname": "DGS7",
"value":   1.36,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-02-21",
"indexname": "DGS7",
"value":   1.34,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-02-24",
"indexname": "DGS7",
"value":   1.25,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-02-25",
"indexname": "DGS7",
"value":   1.25,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-02-26",
"indexname": "DGS7",
"value":   1.28,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-02-27",
"indexname": "DGS7",
"value":   1.26,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-02-28",
"indexname": "DGS7",
"value":   1.23,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-03-03",
"indexname": "DGS7",
"value":   1.25,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-03-04",
"indexname": "DGS7",
"value":   1.27,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-03-05",
"indexname": "DGS7",
"value":   1.31,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-03-06",
"indexname": "DGS7",
"value":   1.36,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-03-07",
"indexname": "DGS7",
"value":   1.43,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-03-10",
"indexname": "DGS7",
"value":   1.43,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-03-11",
"indexname": "DGS7",
"value":    1.4,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-03-12",
"indexname": "DGS7",
"value":   1.41,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-03-13",
"indexname": "DGS7",
"value":    1.4,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-03-14",
"indexname": "DGS7",
"value":   1.35,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-03-17",
"indexname": "DGS7",
"value":   1.31,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-03-18",
"indexname": "DGS7",
"value":   1.28,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-03-19",
"indexname": "DGS7",
"value":   1.32,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-03-20",
"indexname": "DGS7",
"value":    1.3,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-03-21",
"indexname": "DGS7",
"value":   1.29,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-03-24",
"indexname": "DGS7",
"value":   1.28,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-03-25",
"indexname": "DGS7",
"value":   1.27,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-03-26",
"indexname": "DGS7",
"value":   1.22,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-03-27",
"indexname": "DGS7",
"value":   1.24,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-03-31",
"indexname": "DGS7",
"value":   1.23,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-04-01",
"indexname": "DGS7",
"value":   1.26,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-04-02",
"indexname": "DGS7",
"value":    1.2,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-04-03",
"indexname": "DGS7",
"value":   1.15,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-04-04",
"indexname": "DGS7",
"value":   1.12,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-04-07",
"indexname": "DGS7",
"value":   1.15,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-04-08",
"indexname": "DGS7",
"value":   1.16,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-04-09",
"indexname": "DGS7",
"value":   1.21,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-04-10",
"indexname": "DGS7",
"value":    1.2,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-04-11",
"indexname": "DGS7",
"value":   1.14,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-04-14",
"indexname": "DGS7",
"value":   1.12,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-04-15",
"indexname": "DGS7",
"value":   1.15,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-04-16",
"indexname": "DGS7",
"value":   1.13,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-04-17",
"indexname": "DGS7",
"value":   1.13,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-04-18",
"indexname": "DGS7",
"value":   1.14,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-04-21",
"indexname": "DGS7",
"value":   1.13,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-04-22",
"indexname": "DGS7",
"value":   1.14,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-04-23",
"indexname": "DGS7",
"value":   1.13,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-04-24",
"indexname": "DGS7",
"value":   1.15,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-04-25",
"indexname": "DGS7",
"value":    1.1,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-04-28",
"indexname": "DGS7",
"value":    1.1,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-04-29",
"indexname": "DGS7",
"value":   1.11,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-04-30",
"indexname": "DGS7",
"value":   1.07,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-05-01",
"indexname": "DGS7",
"value":   1.07,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-05-02",
"indexname": "DGS7",
"value":   1.17,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-05-05",
"indexname": "DGS7",
"value":   1.19,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-05-06",
"indexname": "DGS7",
"value":   1.21,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-05-07",
"indexname": "DGS7",
"value":    1.2,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-05-08",
"indexname": "DGS7",
"value":    1.2,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-05-09",
"indexname": "DGS7",
"value":   1.28,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-05-12",
"indexname": "DGS7",
"value":    1.3,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-05-13",
"indexname": "DGS7",
"value":   1.33,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-05-14",
"indexname": "DGS7",
"value":   1.32,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-05-15",
"indexname": "DGS7",
"value":   1.25,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-05-16",
"indexname": "DGS7",
"value":   1.32,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-05-19",
"indexname": "DGS7",
"value":   1.33,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-05-20",
"indexname": "DGS7",
"value":   1.31,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-05-21",
"indexname": "DGS7",
"value":    1.4,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-05-22",
"indexname": "DGS7",
"value":    1.4,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-05-23",
"indexname": "DGS7",
"value":   1.39,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-05-27",
"indexname": "DGS7",
"value":   1.53,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-05-28",
"indexname": "DGS7",
"value":   1.51,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-05-29",
"indexname": "DGS7",
"value":   1.51,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-05-30",
"indexname": "DGS7",
"value":   1.55,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-06-02",
"indexname": "DGS7",
"value":   1.53,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-06-03",
"indexname": "DGS7",
"value":   1.55,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-06-04",
"indexname": "DGS7",
"value":   1.52,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-06-05",
"indexname": "DGS7",
"value":   1.49,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-06-06",
"indexname": "DGS7",
"value":   1.59,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-06-09",
"indexname": "DGS7",
"value":   1.62,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-06-10",
"indexname": "DGS7",
"value":   1.61,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-06-11",
"indexname": "DGS7",
"value":   1.64,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-06-12",
"indexname": "DGS7",
"value":    1.6,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-06-13",
"indexname": "DGS7",
"value":   1.53,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-06-16",
"indexname": "DGS7",
"value":   1.57,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-06-17",
"indexname": "DGS7",
"value":   1.58,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-06-18",
"indexname": "DGS7",
"value":   1.76,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-06-19",
"indexname": "DGS7",
"value":   1.84,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-06-20",
"indexname": "DGS7",
"value":   1.95,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-06-23",
"indexname": "DGS7",
"value":   2.02,
"maturity":      7,
"country": "US" 
},
{
 "date": "2013-06-24",
"indexname": "DGS7",
"value":   2.03,
"maturity":      7,
"country": "US" 
},
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
},
{
 "date": "2013-06-24",
"indexname": "DGS10",
"value":    2.6,
"maturity":     10,
"country": "US" 
},
{
 "date": "2012-01-02",
"indexname": "DGS20",
"value":   2.67,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-01-03",
"indexname": "DGS20",
"value":   2.71,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-01-04",
"indexname": "DGS20",
"value":   2.74,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-01-05",
"indexname": "DGS20",
"value":    2.7,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-01-08",
"indexname": "DGS20",
"value":    2.7,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-01-09",
"indexname": "DGS20",
"value":   2.71,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-01-10",
"indexname": "DGS20",
"value":   2.63,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-01-11",
"indexname": "DGS20",
"value":   2.65,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-01-12",
"indexname": "DGS20",
"value":   2.59,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-01-16",
"indexname": "DGS20",
"value":   2.57,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-01-17",
"indexname": "DGS20",
"value":   2.63,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-01-18",
"indexname": "DGS20",
"value":   2.72,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-01-19",
"indexname": "DGS20",
"value":   2.78,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-01-22",
"indexname": "DGS20",
"value":   2.82,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-01-23",
"indexname": "DGS20",
"value":   2.82,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-01-24",
"indexname": "DGS20",
"value":   2.78,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-01-25",
"indexname": "DGS20",
"value":   2.74,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-01-26",
"indexname": "DGS20",
"value":   2.71,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-01-29",
"indexname": "DGS20",
"value":   2.64,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-01-30",
"indexname": "DGS20",
"value":   2.59,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-01-31",
"indexname": "DGS20",
"value":   2.65,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-02-01",
"indexname": "DGS20",
"value":   2.64,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-02-02",
"indexname": "DGS20",
"value":   2.76,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-02-05",
"indexname": "DGS20",
"value":   2.71,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-02-06",
"indexname": "DGS20",
"value":   2.78,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-02-07",
"indexname": "DGS20",
"value":   2.78,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-02-08",
"indexname": "DGS20",
"value":   2.83,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-02-09",
"indexname": "DGS20",
"value":   2.75,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-02-12",
"indexname": "DGS20",
"value":   2.78,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-02-13",
"indexname": "DGS20",
"value":    2.7,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-02-14",
"indexname": "DGS20",
"value":   2.72,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-02-15",
"indexname": "DGS20",
"value":   2.78,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-02-16",
"indexname": "DGS20",
"value":    2.8,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-02-20",
"indexname": "DGS20",
"value":   2.84,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-02-21",
"indexname": "DGS20",
"value":   2.79,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-02-22",
"indexname": "DGS20",
"value":   2.77,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-02-23",
"indexname": "DGS20",
"value":   2.75,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-02-26",
"indexname": "DGS20",
"value":   2.69,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-02-27",
"indexname": "DGS20",
"value":   2.71,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-02-28",
"indexname": "DGS20",
"value":   2.73,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-02-29",
"indexname": "DGS20",
"value":    2.8,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-03-01",
"indexname": "DGS20",
"value":   2.77,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-03-04",
"indexname": "DGS20",
"value":   2.78,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-03-05",
"indexname": "DGS20",
"value":   2.73,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-03-06",
"indexname": "DGS20",
"value":   2.76,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-03-07",
"indexname": "DGS20",
"value":   2.82,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-03-08",
"indexname": "DGS20",
"value":   2.83,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-03-11",
"indexname": "DGS20",
"value":   2.82,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-03-12",
"indexname": "DGS20",
"value":   2.92,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-03-13",
"indexname": "DGS20",
"value":   3.08,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-03-14",
"indexname": "DGS20",
"value":   3.08,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-03-15",
"indexname": "DGS20",
"value":   3.08,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-03-18",
"indexname": "DGS20",
"value":   3.14,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-03-19",
"indexname": "DGS20",
"value":   3.13,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-03-20",
"indexname": "DGS20",
"value":   3.06,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-03-21",
"indexname": "DGS20",
"value":   3.04,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-03-22",
"indexname": "DGS20",
"value":   2.99,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-03-25",
"indexname": "DGS20",
"value":      3,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-03-26",
"indexname": "DGS20",
"value":   2.96,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-03-27",
"indexname": "DGS20",
"value":   2.97,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-03-28",
"indexname": "DGS20",
"value":   2.93,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-03-29",
"indexname": "DGS20",
"value":      3,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-04-01",
"indexname": "DGS20",
"value":      3,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-04-02",
"indexname": "DGS20",
"value":   3.07,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-04-03",
"indexname": "DGS20",
"value":   3.02,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-04-04",
"indexname": "DGS20",
"value":   2.97,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-04-05",
"indexname": "DGS20",
"value":   2.85,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-04-08",
"indexname": "DGS20",
"value":   2.82,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-04-09",
"indexname": "DGS20",
"value":   2.77,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-04-10",
"indexname": "DGS20",
"value":   2.82,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-04-11",
"indexname": "DGS20",
"value":   2.85,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-04-12",
"indexname": "DGS20",
"value":   2.77,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-04-15",
"indexname": "DGS20",
"value":   2.75,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-04-16",
"indexname": "DGS20",
"value":   2.79,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-04-17",
"indexname": "DGS20",
"value":   2.76,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-04-18",
"indexname": "DGS20",
"value":   2.74,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-04-19",
"indexname": "DGS20",
"value":   2.75,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-04-22",
"indexname": "DGS20",
"value":   2.71,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-04-23",
"indexname": "DGS20",
"value":   2.75,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-04-24",
"indexname": "DGS20",
"value":   2.76,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-04-25",
"indexname": "DGS20",
"value":   2.74,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-04-26",
"indexname": "DGS20",
"value":   2.73,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-04-29",
"indexname": "DGS20",
"value":   2.73,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-04-30",
"indexname": "DGS20",
"value":   2.76,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-05-01",
"indexname": "DGS20",
"value":   2.72,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-05-02",
"indexname": "DGS20",
"value":   2.72,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-05-03",
"indexname": "DGS20",
"value":   2.67,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-05-06",
"indexname": "DGS20",
"value":   2.67,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-05-07",
"indexname": "DGS20",
"value":   2.63,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-05-08",
"indexname": "DGS20",
"value":   2.63,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-05-09",
"indexname": "DGS20",
"value":   2.64,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-05-10",
"indexname": "DGS20",
"value":   2.59,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-05-13",
"indexname": "DGS20",
"value":   2.53,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-05-14",
"indexname": "DGS20",
"value":    2.5,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-05-15",
"indexname": "DGS20",
"value":   2.48,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-05-16",
"indexname": "DGS20",
"value":   2.39,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-05-17",
"indexname": "DGS20",
"value":    2.4,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-05-20",
"indexname": "DGS20",
"value":   2.42,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-05-21",
"indexname": "DGS20",
"value":   2.48,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-05-22",
"indexname": "DGS20",
"value":   2.41,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-05-23",
"indexname": "DGS20",
"value":   2.46,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-05-24",
"indexname": "DGS20",
"value":   2.44,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-05-28",
"indexname": "DGS20",
"value":   2.44,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-05-29",
"indexname": "DGS20",
"value":   2.32,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-05-30",
"indexname": "DGS20",
"value":   2.27,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-05-31",
"indexname": "DGS20",
"value":   2.13,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-06-03",
"indexname": "DGS20",
"value":   2.17,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-06-04",
"indexname": "DGS20",
"value":   2.23,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-06-05",
"indexname": "DGS20",
"value":   2.34,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-06-06",
"indexname": "DGS20",
"value":   2.35,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-06-07",
"indexname": "DGS20",
"value":   2.36,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-06-10",
"indexname": "DGS20",
"value":    2.3,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-06-11",
"indexname": "DGS20",
"value":   2.37,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-06-12",
"indexname": "DGS20",
"value":    2.3,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-06-13",
"indexname": "DGS20",
"value":   2.33,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-06-14",
"indexname": "DGS20",
"value":    2.3,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-06-17",
"indexname": "DGS20",
"value":   2.28,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-06-18",
"indexname": "DGS20",
"value":   2.33,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-06-19",
"indexname": "DGS20",
"value":   2.34,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-06-20",
"indexname": "DGS20",
"value":    2.3,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-06-21",
"indexname": "DGS20",
"value":   2.37,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-06-24",
"indexname": "DGS20",
"value":   2.31,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-06-25",
"indexname": "DGS20",
"value":   2.34,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-06-26",
"indexname": "DGS20",
"value":   2.32,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-06-27",
"indexname": "DGS20",
"value":   2.28,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-06-28",
"indexname": "DGS20",
"value":   2.38,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-07-01",
"indexname": "DGS20",
"value":    2.3,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-07-02",
"indexname": "DGS20",
"value":   2.36,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-07-04",
"indexname": "DGS20",
"value":   2.34,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-07-05",
"indexname": "DGS20",
"value":   2.28,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-07-08",
"indexname": "DGS20",
"value":   2.24,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-07-09",
"indexname": "DGS20",
"value":   2.22,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-07-10",
"indexname": "DGS20",
"value":   2.22,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-07-11",
"indexname": "DGS20",
"value":   2.18,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-07-12",
"indexname": "DGS20",
"value":    2.2,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-07-15",
"indexname": "DGS20",
"value":   2.18,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-07-16",
"indexname": "DGS20",
"value":   2.22,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-07-17",
"indexname": "DGS20",
"value":   2.21,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-07-18",
"indexname": "DGS20",
"value":   2.24,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-07-19",
"indexname": "DGS20",
"value":   2.17,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-07-22",
"indexname": "DGS20",
"value":   2.15,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-07-23",
"indexname": "DGS20",
"value":   2.11,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-07-24",
"indexname": "DGS20",
"value":   2.11,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-07-25",
"indexname": "DGS20",
"value":   2.13,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-07-26",
"indexname": "DGS20",
"value":   2.27,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-07-29",
"indexname": "DGS20",
"value":   2.22,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-07-30",
"indexname": "DGS20",
"value":   2.21,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-07-31",
"indexname": "DGS20",
"value":   2.25,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-08-01",
"indexname": "DGS20",
"value":    2.2,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-08-02",
"indexname": "DGS20",
"value":    2.3,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-08-05",
"indexname": "DGS20",
"value":   2.29,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-08-06",
"indexname": "DGS20",
"value":   2.37,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-08-07",
"indexname": "DGS20",
"value":   2.39,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-08-08",
"indexname": "DGS20",
"value":    2.4,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-08-09",
"indexname": "DGS20",
"value":   2.37,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-08-12",
"indexname": "DGS20",
"value":   2.37,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-08-13",
"indexname": "DGS20",
"value":   2.45,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-08-14",
"indexname": "DGS20",
"value":   2.53,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-08-15",
"indexname": "DGS20",
"value":   2.57,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-08-16",
"indexname": "DGS20",
"value":   2.55,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-08-19",
"indexname": "DGS20",
"value":   2.55,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-08-20",
"indexname": "DGS20",
"value":   2.53,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-08-21",
"indexname": "DGS20",
"value":   2.44,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-08-22",
"indexname": "DGS20",
"value":   2.41,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-08-23",
"indexname": "DGS20",
"value":   2.41,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-08-26",
"indexname": "DGS20",
"value":   2.38,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-08-27",
"indexname": "DGS20",
"value":   2.36,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-08-28",
"indexname": "DGS20",
"value":   2.38,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-08-29",
"indexname": "DGS20",
"value":   2.36,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-08-30",
"indexname": "DGS20",
"value":   2.29,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-09-03",
"indexname": "DGS20",
"value":    2.3,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-09-04",
"indexname": "DGS20",
"value":   2.32,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-09-05",
"indexname": "DGS20",
"value":   2.41,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-09-06",
"indexname": "DGS20",
"value":   2.42,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-09-09",
"indexname": "DGS20",
"value":   2.43,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-09-10",
"indexname": "DGS20",
"value":   2.44,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-09-11",
"indexname": "DGS20",
"value":   2.52,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-09-12",
"indexname": "DGS20",
"value":   2.53,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-09-13",
"indexname": "DGS20",
"value":   2.68,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-09-16",
"indexname": "DGS20",
"value":   2.64,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-09-17",
"indexname": "DGS20",
"value":   2.61,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-09-18",
"indexname": "DGS20",
"value":   2.58,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-09-19",
"indexname": "DGS20",
"value":   2.58,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-09-20",
"indexname": "DGS20",
"value":   2.57,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-09-23",
"indexname": "DGS20",
"value":   2.53,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-09-24",
"indexname": "DGS20",
"value":   2.47,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-09-25",
"indexname": "DGS20",
"value":    2.4,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-09-26",
"indexname": "DGS20",
"value":   2.43,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-09-27",
"indexname": "DGS20",
"value":   2.42,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-09-30",
"indexname": "DGS20",
"value":   2.41,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-10-01",
"indexname": "DGS20",
"value":   2.41,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-10-02",
"indexname": "DGS20",
"value":   2.42,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-10-03",
"indexname": "DGS20",
"value":   2.48,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-10-04",
"indexname": "DGS20",
"value":   2.55,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-10-08",
"indexname": "DGS20",
"value":   2.52,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-10-09",
"indexname": "DGS20",
"value":   2.48,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-10-10",
"indexname": "DGS20",
"value":   2.45,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-10-11",
"indexname": "DGS20",
"value":   2.44,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-10-14",
"indexname": "DGS20",
"value":   2.45,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-10-15",
"indexname": "DGS20",
"value":   2.51,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-10-16",
"indexname": "DGS20",
"value":    2.6,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-10-17",
"indexname": "DGS20",
"value":   2.63,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-10-18",
"indexname": "DGS20",
"value":   2.55,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-10-21",
"indexname": "DGS20",
"value":   2.57,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-10-22",
"indexname": "DGS20",
"value":   2.53,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-10-23",
"indexname": "DGS20",
"value":   2.55,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-10-24",
"indexname": "DGS20",
"value":    2.6,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-10-25",
"indexname": "DGS20",
"value":   2.53,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-10-28",
"indexname": "DGS20",
"value":   2.48,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-10-30",
"indexname": "DGS20",
"value":   2.46,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-10-31",
"indexname": "DGS20",
"value":    2.5,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-11-01",
"indexname": "DGS20",
"value":   2.51,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-11-04",
"indexname": "DGS20",
"value":   2.47,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-11-05",
"indexname": "DGS20",
"value":   2.52,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-11-06",
"indexname": "DGS20",
"value":   2.42,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-11-07",
"indexname": "DGS20",
"value":   2.35,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-11-08",
"indexname": "DGS20",
"value":   2.34,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-11-12",
"indexname": "DGS20",
"value":   2.31,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-11-13",
"indexname": "DGS20",
"value":   2.31,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-11-14",
"indexname": "DGS20",
"value":    2.3,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-11-15",
"indexname": "DGS20",
"value":   2.31,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-11-18",
"indexname": "DGS20",
"value":   2.34,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-11-19",
"indexname": "DGS20",
"value":    2.4,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-11-20",
"indexname": "DGS20",
"value":   2.42,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-11-22",
"indexname": "DGS20",
"value":   2.42,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-11-25",
"indexname": "DGS20",
"value":   2.39,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-11-26",
"indexname": "DGS20",
"value":   2.38,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-11-27",
"indexname": "DGS20",
"value":   2.36,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-11-28",
"indexname": "DGS20",
"value":   2.37,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-11-29",
"indexname": "DGS20",
"value":   2.37,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-12-02",
"indexname": "DGS20",
"value":   2.37,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-12-03",
"indexname": "DGS20",
"value":   2.36,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-12-04",
"indexname": "DGS20",
"value":   2.35,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-12-05",
"indexname": "DGS20",
"value":   2.33,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-12-06",
"indexname": "DGS20",
"value":   2.39,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-12-09",
"indexname": "DGS20",
"value":   2.38,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-12-10",
"indexname": "DGS20",
"value":   2.41,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-12-11",
"indexname": "DGS20",
"value":   2.48,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-12-12",
"indexname": "DGS20",
"value":   2.49,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-12-13",
"indexname": "DGS20",
"value":   2.46,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-12-16",
"indexname": "DGS20",
"value":   2.53,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-12-17",
"indexname": "DGS20",
"value":   2.59,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-12-18",
"indexname": "DGS20",
"value":   2.58,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-12-19",
"indexname": "DGS20",
"value":   2.57,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-12-20",
"indexname": "DGS20",
"value":   2.52,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-12-23",
"indexname": "DGS20",
"value":   2.53,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-12-25",
"indexname": "DGS20",
"value":   2.52,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-12-26",
"indexname": "DGS20",
"value":   2.48,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-12-27",
"indexname": "DGS20",
"value":   2.47,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-12-30",
"indexname": "DGS20",
"value":   2.54,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-01-01",
"indexname": "DGS20",
"value":   2.63,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-01-02",
"indexname": "DGS20",
"value":    2.7,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-01-03",
"indexname": "DGS20",
"value":    2.7,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-01-06",
"indexname": "DGS20",
"value":    2.7,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-01-07",
"indexname": "DGS20",
"value":   2.66,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-01-08",
"indexname": "DGS20",
"value":   2.65,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-01-09",
"indexname": "DGS20",
"value":   2.68,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-01-10",
"indexname": "DGS20",
"value":   2.65,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-01-13",
"indexname": "DGS20",
"value":   2.65,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-01-14",
"indexname": "DGS20",
"value":   2.62,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-01-15",
"indexname": "DGS20",
"value":   2.61,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-01-16",
"indexname": "DGS20",
"value":   2.66,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-01-17",
"indexname": "DGS20",
"value":   2.63,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-01-21",
"indexname": "DGS20",
"value":   2.62,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-01-22",
"indexname": "DGS20",
"value":   2.62,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-01-23",
"indexname": "DGS20",
"value":   2.64,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-01-24",
"indexname": "DGS20",
"value":   2.75,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-01-27",
"indexname": "DGS20",
"value":   2.76,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-01-28",
"indexname": "DGS20",
"value":   2.79,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-01-29",
"indexname": "DGS20",
"value":    2.8,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-01-30",
"indexname": "DGS20",
"value":   2.79,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-01-31",
"indexname": "DGS20",
"value":   2.83,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-02-03",
"indexname": "DGS20",
"value":   2.79,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-02-04",
"indexname": "DGS20",
"value":   2.83,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-02-05",
"indexname": "DGS20",
"value":   2.79,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-02-06",
"indexname": "DGS20",
"value":   2.78,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-02-07",
"indexname": "DGS20",
"value":   2.79,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-02-10",
"indexname": "DGS20",
"value":   2.78,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-02-11",
"indexname": "DGS20",
"value":   2.81,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-02-12",
"indexname": "DGS20",
"value":   2.86,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-02-13",
"indexname": "DGS20",
"value":   2.79,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-02-14",
"indexname": "DGS20",
"value":    2.8,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-02-18",
"indexname": "DGS20",
"value":   2.83,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-02-19",
"indexname": "DGS20",
"value":   2.82,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-02-20",
"indexname": "DGS20",
"value":   2.79,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-02-21",
"indexname": "DGS20",
"value":   2.77,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-02-24",
"indexname": "DGS20",
"value":   2.69,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-02-25",
"indexname": "DGS20",
"value":   2.69,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-02-26",
"indexname": "DGS20",
"value":   2.72,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-02-27",
"indexname": "DGS20",
"value":   2.71,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-02-28",
"indexname": "DGS20",
"value":   2.68,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-03-03",
"indexname": "DGS20",
"value":    2.7,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-03-04",
"indexname": "DGS20",
"value":   2.72,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-03-05",
"indexname": "DGS20",
"value":   2.77,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-03-06",
"indexname": "DGS20",
"value":   2.82,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-03-07",
"indexname": "DGS20",
"value":   2.89,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-03-10",
"indexname": "DGS20",
"value":   2.89,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-03-11",
"indexname": "DGS20",
"value":   2.85,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-03-12",
"indexname": "DGS20",
"value":   2.85,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-03-13",
"indexname": "DGS20",
"value":   2.87,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-03-14",
"indexname": "DGS20",
"value":   2.85,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-03-17",
"indexname": "DGS20",
"value":   2.79,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-03-18",
"indexname": "DGS20",
"value":   2.75,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-03-19",
"indexname": "DGS20",
"value":    2.8,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-03-20",
"indexname": "DGS20",
"value":   2.77,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-03-21",
"indexname": "DGS20",
"value":   2.75,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-03-24",
"indexname": "DGS20",
"value":   2.76,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-03-25",
"indexname": "DGS20",
"value":   2.75,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-03-26",
"indexname": "DGS20",
"value":   2.71,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-03-27",
"indexname": "DGS20",
"value":   2.71,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-03-31",
"indexname": "DGS20",
"value":    2.7,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-04-01",
"indexname": "DGS20",
"value":   2.72,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-04-02",
"indexname": "DGS20",
"value":   2.66,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-04-03",
"indexname": "DGS20",
"value":    2.6,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-04-04",
"indexname": "DGS20",
"value":    2.5,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-04-07",
"indexname": "DGS20",
"value":   2.54,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-04-08",
"indexname": "DGS20",
"value":   2.57,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-04-09",
"indexname": "DGS20",
"value":   2.63,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-04-10",
"indexname": "DGS20",
"value":   2.62,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-04-11",
"indexname": "DGS20",
"value":   2.54,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-04-14",
"indexname": "DGS20",
"value":    2.5,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-04-15",
"indexname": "DGS20",
"value":   2.53,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-04-16",
"indexname": "DGS20",
"value":   2.51,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-04-17",
"indexname": "DGS20",
"value":   2.49,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-04-18",
"indexname": "DGS20",
"value":    2.5,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-04-21",
"indexname": "DGS20",
"value":    2.5,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-04-22",
"indexname": "DGS20",
"value":   2.52,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-04-23",
"indexname": "DGS20",
"value":    2.5,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-04-24",
"indexname": "DGS20",
"value":   2.52,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-04-25",
"indexname": "DGS20",
"value":   2.47,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-04-28",
"indexname": "DGS20",
"value":   2.49,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-04-29",
"indexname": "DGS20",
"value":   2.49,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-04-30",
"indexname": "DGS20",
"value":   2.44,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-05-01",
"indexname": "DGS20",
"value":   2.44,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-05-02",
"indexname": "DGS20",
"value":   2.58,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-05-05",
"indexname": "DGS20",
"value":    2.6,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-05-06",
"indexname": "DGS20",
"value":   2.62,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-05-07",
"indexname": "DGS20",
"value":   2.61,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-05-08",
"indexname": "DGS20",
"value":    2.6,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-05-09",
"indexname": "DGS20",
"value":    2.7,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-05-12",
"indexname": "DGS20",
"value":   2.73,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-05-13",
"indexname": "DGS20",
"value":   2.77,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-05-14",
"indexname": "DGS20",
"value":   2.76,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-05-15",
"indexname": "DGS20",
"value":   2.69,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-05-16",
"indexname": "DGS20",
"value":   2.77,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-05-19",
"indexname": "DGS20",
"value":   2.79,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-05-20",
"indexname": "DGS20",
"value":   2.75,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-05-21",
"indexname": "DGS20",
"value":   2.83,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-05-22",
"indexname": "DGS20",
"value":   2.82,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-05-23",
"indexname": "DGS20",
"value":    2.8,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-05-27",
"indexname": "DGS20",
"value":   2.95,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-05-28",
"indexname": "DGS20",
"value":   2.91,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-05-29",
"indexname": "DGS20",
"value":   2.92,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-05-30",
"indexname": "DGS20",
"value":   2.95,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-06-02",
"indexname": "DGS20",
"value":   2.92,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-06-03",
"indexname": "DGS20",
"value":   2.95,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-06-04",
"indexname": "DGS20",
"value":    2.9,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-06-05",
"indexname": "DGS20",
"value":   2.89,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-06-06",
"indexname": "DGS20",
"value":   2.98,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-06-09",
"indexname": "DGS20",
"value":   3.03,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-06-10",
"indexname": "DGS20",
"value":      3,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-06-11",
"indexname": "DGS20",
"value":   3.04,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-06-12",
"indexname": "DGS20",
"value":   2.99,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-06-13",
"indexname": "DGS20",
"value":   2.95,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-06-16",
"indexname": "DGS20",
"value":   3.01,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-06-17",
"indexname": "DGS20",
"value":      3,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-06-18",
"indexname": "DGS20",
"value":   3.09,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-06-19",
"indexname": "DGS20",
"value":   3.18,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-06-20",
"indexname": "DGS20",
"value":   3.26,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-06-23",
"indexname": "DGS20",
"value":   3.27,
"maturity":     20,
"country": "US" 
},
{
 "date": "2013-06-24",
"indexname": "DGS20",
"value":   3.31,
"maturity":     20,
"country": "US" 
},
{
 "date": "2012-01-02",
"indexname": "DGS30",
"value":   2.98,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-01-03",
"indexname": "DGS30",
"value":   3.03,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-01-04",
"indexname": "DGS30",
"value":   3.06,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-01-05",
"indexname": "DGS30",
"value":   3.02,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-01-08",
"indexname": "DGS30",
"value":   3.02,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-01-09",
"indexname": "DGS30",
"value":   3.04,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-01-10",
"indexname": "DGS30",
"value":   2.96,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-01-11",
"indexname": "DGS30",
"value":   2.97,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-01-12",
"indexname": "DGS30",
"value":   2.91,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-01-16",
"indexname": "DGS30",
"value":   2.89,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-01-17",
"indexname": "DGS30",
"value":   2.96,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-01-18",
"indexname": "DGS30",
"value":   3.05,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-01-19",
"indexname": "DGS30",
"value":    3.1,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-01-22",
"indexname": "DGS30",
"value":   3.15,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-01-23",
"indexname": "DGS30",
"value":   3.15,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-01-24",
"indexname": "DGS30",
"value":   3.13,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-01-25",
"indexname": "DGS30",
"value":    3.1,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-01-26",
"indexname": "DGS30",
"value":   3.07,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-01-29",
"indexname": "DGS30",
"value":   2.99,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-01-30",
"indexname": "DGS30",
"value":   2.94,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-01-31",
"indexname": "DGS30",
"value":   3.01,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-02-01",
"indexname": "DGS30",
"value":   3.01,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-02-02",
"indexname": "DGS30",
"value":   3.13,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-02-05",
"indexname": "DGS30",
"value":   3.08,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-02-06",
"indexname": "DGS30",
"value":   3.14,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-02-07",
"indexname": "DGS30",
"value":   3.14,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-02-08",
"indexname": "DGS30",
"value":    3.2,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-02-09",
"indexname": "DGS30",
"value":   3.11,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-02-12",
"indexname": "DGS30",
"value":   3.14,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-02-13",
"indexname": "DGS30",
"value":   3.06,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-02-14",
"indexname": "DGS30",
"value":   3.09,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-02-15",
"indexname": "DGS30",
"value":   3.14,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-02-16",
"indexname": "DGS30",
"value":   3.16,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-02-20",
"indexname": "DGS30",
"value":    3.2,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-02-21",
"indexname": "DGS30",
"value":   3.15,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-02-22",
"indexname": "DGS30",
"value":   3.13,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-02-23",
"indexname": "DGS30",
"value":    3.1,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-02-26",
"indexname": "DGS30",
"value":   3.04,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-02-27",
"indexname": "DGS30",
"value":   3.07,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-02-28",
"indexname": "DGS30",
"value":   3.08,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-02-29",
"indexname": "DGS30",
"value":   3.15,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-03-01",
"indexname": "DGS30",
"value":   3.11,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-03-04",
"indexname": "DGS30",
"value":   3.13,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-03-05",
"indexname": "DGS30",
"value":   3.08,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-03-06",
"indexname": "DGS30",
"value":   3.12,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-03-07",
"indexname": "DGS30",
"value":   3.18,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-03-08",
"indexname": "DGS30",
"value":   3.19,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-03-11",
"indexname": "DGS30",
"value":   3.17,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-03-12",
"indexname": "DGS30",
"value":   3.26,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-03-13",
"indexname": "DGS30",
"value":   3.43,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-03-14",
"indexname": "DGS30",
"value":   3.41,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-03-15",
"indexname": "DGS30",
"value":   3.41,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-03-18",
"indexname": "DGS30",
"value":   3.48,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-03-19",
"indexname": "DGS30",
"value":   3.46,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-03-20",
"indexname": "DGS30",
"value":   3.38,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-03-21",
"indexname": "DGS30",
"value":   3.37,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-03-22",
"indexname": "DGS30",
"value":   3.31,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-03-25",
"indexname": "DGS30",
"value":   3.33,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-03-26",
"indexname": "DGS30",
"value":   3.29,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-03-27",
"indexname": "DGS30",
"value":   3.31,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-03-28",
"indexname": "DGS30",
"value":   3.27,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-03-29",
"indexname": "DGS30",
"value":   3.35,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-04-01",
"indexname": "DGS30",
"value":   3.35,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-04-02",
"indexname": "DGS30",
"value":   3.41,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-04-03",
"indexname": "DGS30",
"value":   3.37,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-04-04",
"indexname": "DGS30",
"value":   3.32,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-04-05",
"indexname": "DGS30",
"value":   3.21,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-04-08",
"indexname": "DGS30",
"value":   3.18,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-04-09",
"indexname": "DGS30",
"value":   3.13,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-04-10",
"indexname": "DGS30",
"value":   3.18,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-04-11",
"indexname": "DGS30",
"value":   3.22,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-04-12",
"indexname": "DGS30",
"value":   3.14,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-04-15",
"indexname": "DGS30",
"value":   3.12,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-04-16",
"indexname": "DGS30",
"value":   3.15,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-04-17",
"indexname": "DGS30",
"value":   3.13,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-04-18",
"indexname": "DGS30",
"value":   3.12,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-04-19",
"indexname": "DGS30",
"value":   3.12,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-04-22",
"indexname": "DGS30",
"value":   3.08,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-04-23",
"indexname": "DGS30",
"value":   3.12,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-04-24",
"indexname": "DGS30",
"value":   3.15,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-04-25",
"indexname": "DGS30",
"value":   3.13,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-04-26",
"indexname": "DGS30",
"value":   3.12,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-04-29",
"indexname": "DGS30",
"value":   3.12,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-04-30",
"indexname": "DGS30",
"value":   3.16,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-05-01",
"indexname": "DGS30",
"value":   3.11,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-05-02",
"indexname": "DGS30",
"value":   3.12,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-05-03",
"indexname": "DGS30",
"value":   3.07,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-05-06",
"indexname": "DGS30",
"value":   3.07,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-05-07",
"indexname": "DGS30",
"value":   3.03,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-05-08",
"indexname": "DGS30",
"value":   3.03,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-05-09",
"indexname": "DGS30",
"value":   3.07,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-05-10",
"indexname": "DGS30",
"value":   3.02,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-05-13",
"indexname": "DGS30",
"value":   2.95,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-05-14",
"indexname": "DGS30",
"value":   2.91,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-05-15",
"indexname": "DGS30",
"value":    2.9,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-05-16",
"indexname": "DGS30",
"value":    2.8,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-05-17",
"indexname": "DGS30",
"value":    2.8,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-05-20",
"indexname": "DGS30",
"value":    2.8,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-05-21",
"indexname": "DGS30",
"value":   2.88,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-05-22",
"indexname": "DGS30",
"value":   2.81,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-05-23",
"indexname": "DGS30",
"value":   2.86,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-05-24",
"indexname": "DGS30",
"value":   2.85,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-05-28",
"indexname": "DGS30",
"value":   2.85,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-05-29",
"indexname": "DGS30",
"value":   2.72,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-05-30",
"indexname": "DGS30",
"value":   2.67,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-05-31",
"indexname": "DGS30",
"value":   2.53,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-06-03",
"indexname": "DGS30",
"value":   2.56,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-06-04",
"indexname": "DGS30",
"value":   2.63,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-06-05",
"indexname": "DGS30",
"value":   2.73,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-06-06",
"indexname": "DGS30",
"value":   2.75,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-06-07",
"indexname": "DGS30",
"value":   2.77,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-06-10",
"indexname": "DGS30",
"value":   2.71,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-06-11",
"indexname": "DGS30",
"value":   2.77,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-06-12",
"indexname": "DGS30",
"value":    2.7,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-06-13",
"indexname": "DGS30",
"value":   2.73,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-06-14",
"indexname": "DGS30",
"value":    2.7,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-06-17",
"indexname": "DGS30",
"value":   2.67,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-06-18",
"indexname": "DGS30",
"value":   2.73,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-06-19",
"indexname": "DGS30",
"value":   2.72,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-06-20",
"indexname": "DGS30",
"value":   2.68,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-06-21",
"indexname": "DGS30",
"value":   2.75,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-06-24",
"indexname": "DGS30",
"value":   2.69,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-06-25",
"indexname": "DGS30",
"value":   2.71,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-06-26",
"indexname": "DGS30",
"value":    2.7,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-06-27",
"indexname": "DGS30",
"value":   2.67,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-06-28",
"indexname": "DGS30",
"value":   2.76,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-07-01",
"indexname": "DGS30",
"value":   2.69,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-07-02",
"indexname": "DGS30",
"value":   2.74,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-07-04",
"indexname": "DGS30",
"value":   2.72,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-07-05",
"indexname": "DGS30",
"value":   2.66,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-07-08",
"indexname": "DGS30",
"value":   2.62,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-07-09",
"indexname": "DGS30",
"value":    2.6,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-07-10",
"indexname": "DGS30",
"value":    2.6,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-07-11",
"indexname": "DGS30",
"value":   2.57,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-07-12",
"indexname": "DGS30",
"value":   2.58,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-07-15",
"indexname": "DGS30",
"value":   2.56,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-07-16",
"indexname": "DGS30",
"value":   2.59,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-07-17",
"indexname": "DGS30",
"value":   2.59,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-07-18",
"indexname": "DGS30",
"value":   2.61,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-07-19",
"indexname": "DGS30",
"value":   2.55,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-07-22",
"indexname": "DGS30",
"value":   2.52,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-07-23",
"indexname": "DGS30",
"value":   2.47,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-07-24",
"indexname": "DGS30",
"value":   2.46,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-07-25",
"indexname": "DGS30",
"value":   2.49,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-07-26",
"indexname": "DGS30",
"value":   2.63,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-07-29",
"indexname": "DGS30",
"value":   2.58,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-07-30",
"indexname": "DGS30",
"value":   2.56,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-07-31",
"indexname": "DGS30",
"value":    2.6,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-08-01",
"indexname": "DGS30",
"value":   2.55,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-08-02",
"indexname": "DGS30",
"value":   2.65,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-08-05",
"indexname": "DGS30",
"value":   2.65,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-08-06",
"indexname": "DGS30",
"value":   2.72,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-08-07",
"indexname": "DGS30",
"value":   2.75,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-08-08",
"indexname": "DGS30",
"value":   2.78,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-08-09",
"indexname": "DGS30",
"value":   2.74,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-08-12",
"indexname": "DGS30",
"value":   2.74,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-08-13",
"indexname": "DGS30",
"value":   2.82,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-08-14",
"indexname": "DGS30",
"value":    2.9,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-08-15",
"indexname": "DGS30",
"value":   2.96,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-08-16",
"indexname": "DGS30",
"value":   2.93,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-08-19",
"indexname": "DGS30",
"value":   2.93,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-08-20",
"indexname": "DGS30",
"value":    2.9,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-08-21",
"indexname": "DGS30",
"value":   2.82,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-08-22",
"indexname": "DGS30",
"value":   2.79,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-08-23",
"indexname": "DGS30",
"value":   2.79,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-08-26",
"indexname": "DGS30",
"value":   2.76,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-08-27",
"indexname": "DGS30",
"value":   2.75,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-08-28",
"indexname": "DGS30",
"value":   2.77,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-08-29",
"indexname": "DGS30",
"value":   2.75,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-08-30",
"indexname": "DGS30",
"value":   2.68,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-09-03",
"indexname": "DGS30",
"value":   2.69,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-09-04",
"indexname": "DGS30",
"value":    2.7,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-09-05",
"indexname": "DGS30",
"value":    2.8,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-09-06",
"indexname": "DGS30",
"value":   2.81,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-09-09",
"indexname": "DGS30",
"value":   2.83,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-09-10",
"indexname": "DGS30",
"value":   2.84,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-09-11",
"indexname": "DGS30",
"value":   2.92,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-09-12",
"indexname": "DGS30",
"value":   2.95,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-09-13",
"indexname": "DGS30",
"value":   3.09,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-09-16",
"indexname": "DGS30",
"value":   3.03,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-09-17",
"indexname": "DGS30",
"value":      3,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-09-18",
"indexname": "DGS30",
"value":   2.97,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-09-19",
"indexname": "DGS30",
"value":   2.96,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-09-20",
"indexname": "DGS30",
"value":   2.95,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-09-23",
"indexname": "DGS30",
"value":   2.91,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-09-24",
"indexname": "DGS30",
"value":   2.86,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-09-25",
"indexname": "DGS30",
"value":   2.79,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-09-26",
"indexname": "DGS30",
"value":   2.83,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-09-27",
"indexname": "DGS30",
"value":   2.82,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-09-30",
"indexname": "DGS30",
"value":   2.81,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-10-01",
"indexname": "DGS30",
"value":   2.81,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-10-02",
"indexname": "DGS30",
"value":   2.82,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-10-03",
"indexname": "DGS30",
"value":   2.89,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-10-04",
"indexname": "DGS30",
"value":   2.96,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-10-08",
"indexname": "DGS30",
"value":   2.93,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-10-09",
"indexname": "DGS30",
"value":   2.89,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-10-10",
"indexname": "DGS30",
"value":   2.86,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-10-11",
"indexname": "DGS30",
"value":   2.83,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-10-14",
"indexname": "DGS30",
"value":   2.85,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-10-15",
"indexname": "DGS30",
"value":   2.91,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-10-16",
"indexname": "DGS30",
"value":   2.98,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-10-17",
"indexname": "DGS30",
"value":   3.02,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-10-18",
"indexname": "DGS30",
"value":   2.94,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-10-21",
"indexname": "DGS30",
"value":   2.95,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-10-22",
"indexname": "DGS30",
"value":   2.91,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-10-23",
"indexname": "DGS30",
"value":   2.93,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-10-24",
"indexname": "DGS30",
"value":   2.98,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-10-25",
"indexname": "DGS30",
"value":   2.92,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-10-28",
"indexname": "DGS30",
"value":   2.87,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-10-30",
"indexname": "DGS30",
"value":   2.85,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-10-31",
"indexname": "DGS30",
"value":   2.89,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-11-01",
"indexname": "DGS30",
"value":   2.91,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-11-04",
"indexname": "DGS30",
"value":   2.88,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-11-05",
"indexname": "DGS30",
"value":   2.92,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-11-06",
"indexname": "DGS30",
"value":   2.83,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-11-07",
"indexname": "DGS30",
"value":   2.77,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-11-08",
"indexname": "DGS30",
"value":   2.75,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-11-12",
"indexname": "DGS30",
"value":   2.72,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-11-13",
"indexname": "DGS30",
"value":   2.73,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-11-14",
"indexname": "DGS30",
"value":   2.72,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-11-15",
"indexname": "DGS30",
"value":   2.73,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-11-18",
"indexname": "DGS30",
"value":   2.76,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-11-19",
"indexname": "DGS30",
"value":   2.82,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-11-20",
"indexname": "DGS30",
"value":   2.83,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-11-22",
"indexname": "DGS30",
"value":   2.83,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-11-25",
"indexname": "DGS30",
"value":    2.8,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-11-26",
"indexname": "DGS30",
"value":   2.79,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-11-27",
"indexname": "DGS30",
"value":   2.79,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-11-28",
"indexname": "DGS30",
"value":   2.79,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-11-29",
"indexname": "DGS30",
"value":   2.81,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-12-02",
"indexname": "DGS30",
"value":    2.8,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-12-03",
"indexname": "DGS30",
"value":   2.78,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-12-04",
"indexname": "DGS30",
"value":   2.78,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-12-05",
"indexname": "DGS30",
"value":   2.76,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-12-06",
"indexname": "DGS30",
"value":   2.81,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-12-09",
"indexname": "DGS30",
"value":    2.8,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-12-10",
"indexname": "DGS30",
"value":   2.83,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-12-11",
"indexname": "DGS30",
"value":    2.9,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-12-12",
"indexname": "DGS30",
"value":    2.9,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-12-13",
"indexname": "DGS30",
"value":   2.87,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-12-16",
"indexname": "DGS30",
"value":   2.94,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-12-17",
"indexname": "DGS30",
"value":      3,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-12-18",
"indexname": "DGS30",
"value":   2.99,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-12-19",
"indexname": "DGS30",
"value":   2.98,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-12-20",
"indexname": "DGS30",
"value":   2.93,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-12-23",
"indexname": "DGS30",
"value":   2.94,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-12-25",
"indexname": "DGS30",
"value":   2.94,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-12-26",
"indexname": "DGS30",
"value":   2.89,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-12-27",
"indexname": "DGS30",
"value":   2.88,
"maturity":     30,
"country": "US" 
},
{
 "date": "2012-12-30",
"indexname": "DGS30",
"value":   2.95,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-01-01",
"indexname": "DGS30",
"value":   3.04,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-01-02",
"indexname": "DGS30",
"value":   3.12,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-01-03",
"indexname": "DGS30",
"value":    3.1,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-01-06",
"indexname": "DGS30",
"value":    3.1,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-01-07",
"indexname": "DGS30",
"value":   3.06,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-01-08",
"indexname": "DGS30",
"value":   3.06,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-01-09",
"indexname": "DGS30",
"value":   3.08,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-01-10",
"indexname": "DGS30",
"value":   3.05,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-01-13",
"indexname": "DGS30",
"value":   3.05,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-01-14",
"indexname": "DGS30",
"value":   3.02,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-01-15",
"indexname": "DGS30",
"value":   3.01,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-01-16",
"indexname": "DGS30",
"value":   3.06,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-01-17",
"indexname": "DGS30",
"value":   3.03,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-01-21",
"indexname": "DGS30",
"value":   3.02,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-01-22",
"indexname": "DGS30",
"value":   3.02,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-01-23",
"indexname": "DGS30",
"value":   3.04,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-01-24",
"indexname": "DGS30",
"value":   3.14,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-01-27",
"indexname": "DGS30",
"value":   3.15,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-01-28",
"indexname": "DGS30",
"value":   3.18,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-01-29",
"indexname": "DGS30",
"value":   3.19,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-01-30",
"indexname": "DGS30",
"value":   3.17,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-01-31",
"indexname": "DGS30",
"value":   3.21,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-02-03",
"indexname": "DGS30",
"value":   3.17,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-02-04",
"indexname": "DGS30",
"value":   3.21,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-02-05",
"indexname": "DGS30",
"value":   3.18,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-02-06",
"indexname": "DGS30",
"value":   3.17,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-02-07",
"indexname": "DGS30",
"value":   3.17,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-02-10",
"indexname": "DGS30",
"value":   3.16,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-02-11",
"indexname": "DGS30",
"value":   3.19,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-02-12",
"indexname": "DGS30",
"value":   3.23,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-02-13",
"indexname": "DGS30",
"value":   3.17,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-02-14",
"indexname": "DGS30",
"value":   3.18,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-02-18",
"indexname": "DGS30",
"value":   3.21,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-02-19",
"indexname": "DGS30",
"value":    3.2,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-02-20",
"indexname": "DGS30",
"value":   3.17,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-02-21",
"indexname": "DGS30",
"value":   3.15,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-02-24",
"indexname": "DGS30",
"value":   3.08,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-02-25",
"indexname": "DGS30",
"value":   3.08,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-02-26",
"indexname": "DGS30",
"value":   3.11,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-02-27",
"indexname": "DGS30",
"value":    3.1,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-02-28",
"indexname": "DGS30",
"value":   3.06,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-03-03",
"indexname": "DGS30",
"value":   3.08,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-03-04",
"indexname": "DGS30",
"value":    3.1,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-03-05",
"indexname": "DGS30",
"value":   3.15,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-03-06",
"indexname": "DGS30",
"value":    3.2,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-03-07",
"indexname": "DGS30",
"value":   3.25,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-03-10",
"indexname": "DGS30",
"value":   3.26,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-03-11",
"indexname": "DGS30",
"value":   3.22,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-03-12",
"indexname": "DGS30",
"value":   3.22,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-03-13",
"indexname": "DGS30",
"value":   3.25,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-03-14",
"indexname": "DGS30",
"value":   3.22,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-03-17",
"indexname": "DGS30",
"value":   3.18,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-03-18",
"indexname": "DGS30",
"value":   3.13,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-03-19",
"indexname": "DGS30",
"value":   3.19,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-03-20",
"indexname": "DGS30",
"value":   3.15,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-03-21",
"indexname": "DGS30",
"value":   3.13,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-03-24",
"indexname": "DGS30",
"value":   3.14,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-03-25",
"indexname": "DGS30",
"value":   3.13,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-03-26",
"indexname": "DGS30",
"value":   3.09,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-03-27",
"indexname": "DGS30",
"value":    3.1,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-03-31",
"indexname": "DGS30",
"value":   3.08,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-04-01",
"indexname": "DGS30",
"value":    3.1,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-04-02",
"indexname": "DGS30",
"value":   3.05,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-04-03",
"indexname": "DGS30",
"value":   2.99,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-04-04",
"indexname": "DGS30",
"value":   2.87,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-04-07",
"indexname": "DGS30",
"value":   2.91,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-04-08",
"indexname": "DGS30",
"value":   2.94,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-04-09",
"indexname": "DGS30",
"value":   3.01,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-04-10",
"indexname": "DGS30",
"value":   3.01,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-04-11",
"indexname": "DGS30",
"value":   2.92,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-04-14",
"indexname": "DGS30",
"value":   2.88,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-04-15",
"indexname": "DGS30",
"value":   2.91,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-04-16",
"indexname": "DGS30",
"value":   2.89,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-04-17",
"indexname": "DGS30",
"value":   2.87,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-04-18",
"indexname": "DGS30",
"value":   2.88,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-04-21",
"indexname": "DGS30",
"value":   2.88,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-04-22",
"indexname": "DGS30",
"value":    2.9,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-04-23",
"indexname": "DGS30",
"value":   2.89,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-04-24",
"indexname": "DGS30",
"value":   2.91,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-04-25",
"indexname": "DGS30",
"value":   2.87,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-04-28",
"indexname": "DGS30",
"value":   2.88,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-04-29",
"indexname": "DGS30",
"value":   2.88,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-04-30",
"indexname": "DGS30",
"value":   2.83,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-05-01",
"indexname": "DGS30",
"value":   2.82,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-05-02",
"indexname": "DGS30",
"value":   2.96,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-05-05",
"indexname": "DGS30",
"value":   2.98,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-05-06",
"indexname": "DGS30",
"value":      3,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-05-07",
"indexname": "DGS30",
"value":   2.99,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-05-08",
"indexname": "DGS30",
"value":   3.01,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-05-09",
"indexname": "DGS30",
"value":    3.1,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-05-12",
"indexname": "DGS30",
"value":   3.13,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-05-13",
"indexname": "DGS30",
"value":   3.17,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-05-14",
"indexname": "DGS30",
"value":   3.16,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-05-15",
"indexname": "DGS30",
"value":   3.09,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-05-16",
"indexname": "DGS30",
"value":   3.17,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-05-19",
"indexname": "DGS30",
"value":   3.18,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-05-20",
"indexname": "DGS30",
"value":   3.14,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-05-21",
"indexname": "DGS30",
"value":   3.21,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-05-22",
"indexname": "DGS30",
"value":    3.2,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-05-23",
"indexname": "DGS30",
"value":   3.18,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-05-27",
"indexname": "DGS30",
"value":   3.31,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-05-28",
"indexname": "DGS30",
"value":   3.27,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-05-29",
"indexname": "DGS30",
"value":   3.28,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-05-30",
"indexname": "DGS30",
"value":    3.3,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-06-02",
"indexname": "DGS30",
"value":   3.27,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-06-03",
"indexname": "DGS30",
"value":    3.3,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-06-04",
"indexname": "DGS30",
"value":   3.25,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-06-05",
"indexname": "DGS30",
"value":   3.23,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-06-06",
"indexname": "DGS30",
"value":   3.33,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-06-09",
"indexname": "DGS30",
"value":   3.36,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-06-10",
"indexname": "DGS30",
"value":   3.33,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-06-11",
"indexname": "DGS30",
"value":   3.37,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-06-12",
"indexname": "DGS30",
"value":   3.33,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-06-13",
"indexname": "DGS30",
"value":   3.28,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-06-16",
"indexname": "DGS30",
"value":   3.35,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-06-17",
"indexname": "DGS30",
"value":   3.34,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-06-18",
"indexname": "DGS30",
"value":   3.41,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-06-19",
"indexname": "DGS30",
"value":   3.49,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-06-20",
"indexname": "DGS30",
"value":   3.56,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-06-23",
"indexname": "DGS30",
"value":   3.56,
"maturity":     30,
"country": "US" 
},
{
 "date": "2013-06-24",
"indexname": "DGS30",
"value":    3.6,
"maturity":     30,
"country": "US" 
} 
],
    xAxis = {
 "type": "addCategoryAxis",
"showPercent": false,
"grouporderRule": "date" 
},
    yAxis = {
 "type": "addMeasureAxis",
"showPercent": false 
},
    zAxis = [],
    legend = {
 "x":     60,
"y":     10,
"width":    620,
"height":     20,
"horizontalAlign": "right" 
};
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


---
### Yield Curve Storyboard

Another way to look at yields would be as a yield curve.  Generally, this means remove time, but with `dimplejs` `storyboard` feature we can see the history of the yield curve.  Daily would be a little tedious, so let's do monthly 2013.  Watch closely.


```r
#get weekly since April 2013
ust.melt <- xtsMelt(ust.xts[endpoints(ust.xts,"months"),]["2013::",])

ust.melt$date <- format(as.Date(ust.melt$date),"%m/%d/%Y")
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

d5 <- dPlot(
  value ~ maturity,
  data = ust.melt,
  type = "line"
)
d5$xAxis( orderRule ="maturity" )
d5$set( storyboard = "date" )
d5
```

<div id ="chart5"></div>

<div id='chart5' class='rChart dimple'></div>
<script type="text/javascript">
  var opts = {
 "dom": "chart5",
"width":    800,
"height":    400,
"x": "maturity",
"y": "value",
"type": "line",
"storyboard": "date",
"id": "chart5" 
},
    data = [
 {
 "date": "01/31/2013",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "02/28/2013",
"indexname": "DGS1",
"value":   0.16,
"maturity":      1,
"country": "US" 
},
{
 "date": "03/31/2013",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "04/30/2013",
"indexname": "DGS1",
"value":   0.11,
"maturity":      1,
"country": "US" 
},
{
 "date": "05/30/2013",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "06/24/2013",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "01/31/2013",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "02/28/2013",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "03/31/2013",
"indexname": "DGS2",
"value":   0.23,
"maturity":      2,
"country": "US" 
},
{
 "date": "04/30/2013",
"indexname": "DGS2",
"value":    0.2,
"maturity":      2,
"country": "US" 
},
{
 "date": "05/30/2013",
"indexname": "DGS2",
"value":    0.3,
"maturity":      2,
"country": "US" 
},
{
 "date": "06/24/2013",
"indexname": "DGS2",
"value":   0.43,
"maturity":      2,
"country": "US" 
},
{
 "date": "01/31/2013",
"indexname": "DGS3",
"value":    0.4,
"maturity":      3,
"country": "US" 
},
{
 "date": "02/28/2013",
"indexname": "DGS3",
"value":   0.35,
"maturity":      3,
"country": "US" 
},
{
 "date": "03/31/2013",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "04/30/2013",
"indexname": "DGS3",
"value":    0.3,
"maturity":      3,
"country": "US" 
},
{
 "date": "05/30/2013",
"indexname": "DGS3",
"value":   0.52,
"maturity":      3,
"country": "US" 
},
{
 "date": "06/24/2013",
"indexname": "DGS3",
"value":   0.74,
"maturity":      3,
"country": "US" 
},
{
 "date": "01/31/2013",
"indexname": "DGS5",
"value":   0.88,
"maturity":      5,
"country": "US" 
},
{
 "date": "02/28/2013",
"indexname": "DGS5",
"value":   0.75,
"maturity":      5,
"country": "US" 
},
{
 "date": "03/31/2013",
"indexname": "DGS5",
"value":   0.76,
"maturity":      5,
"country": "US" 
},
{
 "date": "04/30/2013",
"indexname": "DGS5",
"value":   0.65,
"maturity":      5,
"country": "US" 
},
{
 "date": "05/30/2013",
"indexname": "DGS5",
"value":   1.05,
"maturity":      5,
"country": "US" 
},
{
 "date": "06/24/2013",
"indexname": "DGS5",
"value":   1.49,
"maturity":      5,
"country": "US" 
},
{
 "date": "01/31/2013",
"indexname": "DGS7",
"value":    1.4,
"maturity":      7,
"country": "US" 
},
{
 "date": "02/28/2013",
"indexname": "DGS7",
"value":   1.23,
"maturity":      7,
"country": "US" 
},
{
 "date": "03/31/2013",
"indexname": "DGS7",
"value":   1.23,
"maturity":      7,
"country": "US" 
},
{
 "date": "04/30/2013",
"indexname": "DGS7",
"value":   1.07,
"maturity":      7,
"country": "US" 
},
{
 "date": "05/30/2013",
"indexname": "DGS7",
"value":   1.55,
"maturity":      7,
"country": "US" 
},
{
 "date": "06/24/2013",
"indexname": "DGS7",
"value":   2.03,
"maturity":      7,
"country": "US" 
},
{
 "date": "01/31/2013",
"indexname": "DGS10",
"value":   2.04,
"maturity":     10,
"country": "US" 
},
{
 "date": "02/28/2013",
"indexname": "DGS10",
"value":   1.86,
"maturity":     10,
"country": "US" 
},
{
 "date": "03/31/2013",
"indexname": "DGS10",
"value":   1.86,
"maturity":     10,
"country": "US" 
},
{
 "date": "04/30/2013",
"indexname": "DGS10",
"value":   1.66,
"maturity":     10,
"country": "US" 
},
{
 "date": "05/30/2013",
"indexname": "DGS10",
"value":   2.16,
"maturity":     10,
"country": "US" 
},
{
 "date": "06/24/2013",
"indexname": "DGS10",
"value":    2.6,
"maturity":     10,
"country": "US" 
},
{
 "date": "01/31/2013",
"indexname": "DGS20",
"value":   2.83,
"maturity":     20,
"country": "US" 
},
{
 "date": "02/28/2013",
"indexname": "DGS20",
"value":   2.68,
"maturity":     20,
"country": "US" 
},
{
 "date": "03/31/2013",
"indexname": "DGS20",
"value":    2.7,
"maturity":     20,
"country": "US" 
},
{
 "date": "04/30/2013",
"indexname": "DGS20",
"value":   2.44,
"maturity":     20,
"country": "US" 
},
{
 "date": "05/30/2013",
"indexname": "DGS20",
"value":   2.95,
"maturity":     20,
"country": "US" 
},
{
 "date": "06/24/2013",
"indexname": "DGS20",
"value":   3.31,
"maturity":     20,
"country": "US" 
},
{
 "date": "01/31/2013",
"indexname": "DGS30",
"value":   3.21,
"maturity":     30,
"country": "US" 
},
{
 "date": "02/28/2013",
"indexname": "DGS30",
"value":   3.06,
"maturity":     30,
"country": "US" 
},
{
 "date": "03/31/2013",
"indexname": "DGS30",
"value":   3.08,
"maturity":     30,
"country": "US" 
},
{
 "date": "04/30/2013",
"indexname": "DGS30",
"value":   2.83,
"maturity":     30,
"country": "US" 
},
{
 "date": "05/30/2013",
"indexname": "DGS30",
"value":    3.3,
"maturity":     30,
"country": "US" 
},
{
 "date": "06/24/2013",
"indexname": "DGS30",
"value":    3.6,
"maturity":     30,
"country": "US" 
} 
],
    xAxis = {
 "type": "addCategoryAxis",
"showPercent": false,
"orderRule": "maturity" 
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


---
### Other dimplejs Chart Types

Telling a story with your data has never been so easy.  Add a little text content describing the change and next you will be presenting at [Eyeo](http://eyeofestival.com/).

Just to make sure we cover some of the other plot types, let's draw our other two `dimplejs` options--area, bar, and bubble.


```r
d6 <- dPlot(
  x = "date",
  y = "value",
  groups = "indexname",
  data = ust.melt,
  type = "area"
)
d6$xAxis( orderRule = "date" )
d6
```

<div id ="chart6"></div>

<div id='chart6' class='rChart dimple'></div>
<script type="text/javascript">
  var opts = {
 "dom": "chart6",
"width":    800,
"height":    400,
"x": "date",
"y": "value",
"groups": "indexname",
"type": "area",
"id": "chart6" 
},
    data = [
 {
 "date": "01/31/2013",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "02/28/2013",
"indexname": "DGS1",
"value":   0.16,
"maturity":      1,
"country": "US" 
},
{
 "date": "03/31/2013",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "04/30/2013",
"indexname": "DGS1",
"value":   0.11,
"maturity":      1,
"country": "US" 
},
{
 "date": "05/30/2013",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "06/24/2013",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "01/31/2013",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "02/28/2013",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "03/31/2013",
"indexname": "DGS2",
"value":   0.23,
"maturity":      2,
"country": "US" 
},
{
 "date": "04/30/2013",
"indexname": "DGS2",
"value":    0.2,
"maturity":      2,
"country": "US" 
},
{
 "date": "05/30/2013",
"indexname": "DGS2",
"value":    0.3,
"maturity":      2,
"country": "US" 
},
{
 "date": "06/24/2013",
"indexname": "DGS2",
"value":   0.43,
"maturity":      2,
"country": "US" 
},
{
 "date": "01/31/2013",
"indexname": "DGS3",
"value":    0.4,
"maturity":      3,
"country": "US" 
},
{
 "date": "02/28/2013",
"indexname": "DGS3",
"value":   0.35,
"maturity":      3,
"country": "US" 
},
{
 "date": "03/31/2013",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "04/30/2013",
"indexname": "DGS3",
"value":    0.3,
"maturity":      3,
"country": "US" 
},
{
 "date": "05/30/2013",
"indexname": "DGS3",
"value":   0.52,
"maturity":      3,
"country": "US" 
},
{
 "date": "06/24/2013",
"indexname": "DGS3",
"value":   0.74,
"maturity":      3,
"country": "US" 
},
{
 "date": "01/31/2013",
"indexname": "DGS5",
"value":   0.88,
"maturity":      5,
"country": "US" 
},
{
 "date": "02/28/2013",
"indexname": "DGS5",
"value":   0.75,
"maturity":      5,
"country": "US" 
},
{
 "date": "03/31/2013",
"indexname": "DGS5",
"value":   0.76,
"maturity":      5,
"country": "US" 
},
{
 "date": "04/30/2013",
"indexname": "DGS5",
"value":   0.65,
"maturity":      5,
"country": "US" 
},
{
 "date": "05/30/2013",
"indexname": "DGS5",
"value":   1.05,
"maturity":      5,
"country": "US" 
},
{
 "date": "06/24/2013",
"indexname": "DGS5",
"value":   1.49,
"maturity":      5,
"country": "US" 
},
{
 "date": "01/31/2013",
"indexname": "DGS7",
"value":    1.4,
"maturity":      7,
"country": "US" 
},
{
 "date": "02/28/2013",
"indexname": "DGS7",
"value":   1.23,
"maturity":      7,
"country": "US" 
},
{
 "date": "03/31/2013",
"indexname": "DGS7",
"value":   1.23,
"maturity":      7,
"country": "US" 
},
{
 "date": "04/30/2013",
"indexname": "DGS7",
"value":   1.07,
"maturity":      7,
"country": "US" 
},
{
 "date": "05/30/2013",
"indexname": "DGS7",
"value":   1.55,
"maturity":      7,
"country": "US" 
},
{
 "date": "06/24/2013",
"indexname": "DGS7",
"value":   2.03,
"maturity":      7,
"country": "US" 
},
{
 "date": "01/31/2013",
"indexname": "DGS10",
"value":   2.04,
"maturity":     10,
"country": "US" 
},
{
 "date": "02/28/2013",
"indexname": "DGS10",
"value":   1.86,
"maturity":     10,
"country": "US" 
},
{
 "date": "03/31/2013",
"indexname": "DGS10",
"value":   1.86,
"maturity":     10,
"country": "US" 
},
{
 "date": "04/30/2013",
"indexname": "DGS10",
"value":   1.66,
"maturity":     10,
"country": "US" 
},
{
 "date": "05/30/2013",
"indexname": "DGS10",
"value":   2.16,
"maturity":     10,
"country": "US" 
},
{
 "date": "06/24/2013",
"indexname": "DGS10",
"value":    2.6,
"maturity":     10,
"country": "US" 
},
{
 "date": "01/31/2013",
"indexname": "DGS20",
"value":   2.83,
"maturity":     20,
"country": "US" 
},
{
 "date": "02/28/2013",
"indexname": "DGS20",
"value":   2.68,
"maturity":     20,
"country": "US" 
},
{
 "date": "03/31/2013",
"indexname": "DGS20",
"value":    2.7,
"maturity":     20,
"country": "US" 
},
{
 "date": "04/30/2013",
"indexname": "DGS20",
"value":   2.44,
"maturity":     20,
"country": "US" 
},
{
 "date": "05/30/2013",
"indexname": "DGS20",
"value":   2.95,
"maturity":     20,
"country": "US" 
},
{
 "date": "06/24/2013",
"indexname": "DGS20",
"value":   3.31,
"maturity":     20,
"country": "US" 
},
{
 "date": "01/31/2013",
"indexname": "DGS30",
"value":   3.21,
"maturity":     30,
"country": "US" 
},
{
 "date": "02/28/2013",
"indexname": "DGS30",
"value":   3.06,
"maturity":     30,
"country": "US" 
},
{
 "date": "03/31/2013",
"indexname": "DGS30",
"value":   3.08,
"maturity":     30,
"country": "US" 
},
{
 "date": "04/30/2013",
"indexname": "DGS30",
"value":   2.83,
"maturity":     30,
"country": "US" 
},
{
 "date": "05/30/2013",
"indexname": "DGS30",
"value":    3.3,
"maturity":     30,
"country": "US" 
},
{
 "date": "06/24/2013",
"indexname": "DGS30",
"value":    3.6,
"maturity":     30,
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


And although a stacked 100% bar does not make a lot of sense with this data, here is how we might do that by changing `type = "bar"` and `d7$yAxis( type = "addPctAxis" )`.


```r
d7 <- dPlot(
  x = "date",
  y = "value",
  groups = "indexname",
  data = ust.melt,
  type = "bar"
)
d7$xAxis( orderRule = "date" )
d7$yAxis( type = "addPctAxis" )
d7
```

<div id ="chart7"></div>

<div id='chart7' class='rChart dimple'></div>
<script type="text/javascript">
  var opts = {
 "dom": "chart7",
"width":    800,
"height":    400,
"x": "date",
"y": "value",
"groups": "indexname",
"type": "bar",
"id": "chart7" 
},
    data = [
 {
 "date": "01/31/2013",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "02/28/2013",
"indexname": "DGS1",
"value":   0.16,
"maturity":      1,
"country": "US" 
},
{
 "date": "03/31/2013",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "04/30/2013",
"indexname": "DGS1",
"value":   0.11,
"maturity":      1,
"country": "US" 
},
{
 "date": "05/30/2013",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "06/24/2013",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "01/31/2013",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "02/28/2013",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "03/31/2013",
"indexname": "DGS2",
"value":   0.23,
"maturity":      2,
"country": "US" 
},
{
 "date": "04/30/2013",
"indexname": "DGS2",
"value":    0.2,
"maturity":      2,
"country": "US" 
},
{
 "date": "05/30/2013",
"indexname": "DGS2",
"value":    0.3,
"maturity":      2,
"country": "US" 
},
{
 "date": "06/24/2013",
"indexname": "DGS2",
"value":   0.43,
"maturity":      2,
"country": "US" 
},
{
 "date": "01/31/2013",
"indexname": "DGS3",
"value":    0.4,
"maturity":      3,
"country": "US" 
},
{
 "date": "02/28/2013",
"indexname": "DGS3",
"value":   0.35,
"maturity":      3,
"country": "US" 
},
{
 "date": "03/31/2013",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "04/30/2013",
"indexname": "DGS3",
"value":    0.3,
"maturity":      3,
"country": "US" 
},
{
 "date": "05/30/2013",
"indexname": "DGS3",
"value":   0.52,
"maturity":      3,
"country": "US" 
},
{
 "date": "06/24/2013",
"indexname": "DGS3",
"value":   0.74,
"maturity":      3,
"country": "US" 
},
{
 "date": "01/31/2013",
"indexname": "DGS5",
"value":   0.88,
"maturity":      5,
"country": "US" 
},
{
 "date": "02/28/2013",
"indexname": "DGS5",
"value":   0.75,
"maturity":      5,
"country": "US" 
},
{
 "date": "03/31/2013",
"indexname": "DGS5",
"value":   0.76,
"maturity":      5,
"country": "US" 
},
{
 "date": "04/30/2013",
"indexname": "DGS5",
"value":   0.65,
"maturity":      5,
"country": "US" 
},
{
 "date": "05/30/2013",
"indexname": "DGS5",
"value":   1.05,
"maturity":      5,
"country": "US" 
},
{
 "date": "06/24/2013",
"indexname": "DGS5",
"value":   1.49,
"maturity":      5,
"country": "US" 
},
{
 "date": "01/31/2013",
"indexname": "DGS7",
"value":    1.4,
"maturity":      7,
"country": "US" 
},
{
 "date": "02/28/2013",
"indexname": "DGS7",
"value":   1.23,
"maturity":      7,
"country": "US" 
},
{
 "date": "03/31/2013",
"indexname": "DGS7",
"value":   1.23,
"maturity":      7,
"country": "US" 
},
{
 "date": "04/30/2013",
"indexname": "DGS7",
"value":   1.07,
"maturity":      7,
"country": "US" 
},
{
 "date": "05/30/2013",
"indexname": "DGS7",
"value":   1.55,
"maturity":      7,
"country": "US" 
},
{
 "date": "06/24/2013",
"indexname": "DGS7",
"value":   2.03,
"maturity":      7,
"country": "US" 
},
{
 "date": "01/31/2013",
"indexname": "DGS10",
"value":   2.04,
"maturity":     10,
"country": "US" 
},
{
 "date": "02/28/2013",
"indexname": "DGS10",
"value":   1.86,
"maturity":     10,
"country": "US" 
},
{
 "date": "03/31/2013",
"indexname": "DGS10",
"value":   1.86,
"maturity":     10,
"country": "US" 
},
{
 "date": "04/30/2013",
"indexname": "DGS10",
"value":   1.66,
"maturity":     10,
"country": "US" 
},
{
 "date": "05/30/2013",
"indexname": "DGS10",
"value":   2.16,
"maturity":     10,
"country": "US" 
},
{
 "date": "06/24/2013",
"indexname": "DGS10",
"value":    2.6,
"maturity":     10,
"country": "US" 
},
{
 "date": "01/31/2013",
"indexname": "DGS20",
"value":   2.83,
"maturity":     20,
"country": "US" 
},
{
 "date": "02/28/2013",
"indexname": "DGS20",
"value":   2.68,
"maturity":     20,
"country": "US" 
},
{
 "date": "03/31/2013",
"indexname": "DGS20",
"value":    2.7,
"maturity":     20,
"country": "US" 
},
{
 "date": "04/30/2013",
"indexname": "DGS20",
"value":   2.44,
"maturity":     20,
"country": "US" 
},
{
 "date": "05/30/2013",
"indexname": "DGS20",
"value":   2.95,
"maturity":     20,
"country": "US" 
},
{
 "date": "06/24/2013",
"indexname": "DGS20",
"value":   3.31,
"maturity":     20,
"country": "US" 
},
{
 "date": "01/31/2013",
"indexname": "DGS30",
"value":   3.21,
"maturity":     30,
"country": "US" 
},
{
 "date": "02/28/2013",
"indexname": "DGS30",
"value":   3.06,
"maturity":     30,
"country": "US" 
},
{
 "date": "03/31/2013",
"indexname": "DGS30",
"value":   3.08,
"maturity":     30,
"country": "US" 
},
{
 "date": "04/30/2013",
"indexname": "DGS30",
"value":   2.83,
"maturity":     30,
"country": "US" 
},
{
 "date": "05/30/2013",
"indexname": "DGS30",
"value":    3.3,
"maturity":     30,
"country": "US" 
},
{
 "date": "06/24/2013",
"indexname": "DGS30",
"value":    3.6,
"maturity":     30,
"country": "US" 
} 
],
    xAxis = {
 "type": "addCategoryAxis",
"showPercent": false,
"orderRule": "date" 
},
    yAxis = {
 "type": "addPctAxis",
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


Bubble also might not be the best way to plot yields, but here is an example.


```r
d8 <- dPlot(
  x = c("indexname","date"),
  y = "value",
  z = "value",
  groups = "indexname",
  data = ust.melt,
  type = "bubble"
)
d8$xAxis( grouporderRule = "date", orderRule = "maturity" )
d8$zAxis( type = "addMeasureAxis", overrideMax = 10 )
d8
```

<div id ="chart8"></div>

<div id='chart8' class='rChart dimple'></div>
<script type="text/javascript">
  var opts = {
 "dom": "chart8",
"width":    800,
"height":    400,
"x": "date",
"y": "value",
"groups": "indexname",
"type": "bar",
"id": "chart8" 
},
    data = [
 {
 "date": "01/31/2013",
"indexname": "DGS1",
"value":   0.15,
"maturity":      1,
"country": "US" 
},
{
 "date": "02/28/2013",
"indexname": "DGS1",
"value":   0.16,
"maturity":      1,
"country": "US" 
},
{
 "date": "03/31/2013",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "04/30/2013",
"indexname": "DGS1",
"value":   0.11,
"maturity":      1,
"country": "US" 
},
{
 "date": "05/30/2013",
"indexname": "DGS1",
"value":   0.14,
"maturity":      1,
"country": "US" 
},
{
 "date": "06/24/2013",
"indexname": "DGS1",
"value":   0.17,
"maturity":      1,
"country": "US" 
},
{
 "date": "01/31/2013",
"indexname": "DGS2",
"value":   0.27,
"maturity":      2,
"country": "US" 
},
{
 "date": "02/28/2013",
"indexname": "DGS2",
"value":   0.25,
"maturity":      2,
"country": "US" 
},
{
 "date": "03/31/2013",
"indexname": "DGS2",
"value":   0.23,
"maturity":      2,
"country": "US" 
},
{
 "date": "04/30/2013",
"indexname": "DGS2",
"value":    0.2,
"maturity":      2,
"country": "US" 
},
{
 "date": "05/30/2013",
"indexname": "DGS2",
"value":    0.3,
"maturity":      2,
"country": "US" 
},
{
 "date": "06/24/2013",
"indexname": "DGS2",
"value":   0.43,
"maturity":      2,
"country": "US" 
},
{
 "date": "01/31/2013",
"indexname": "DGS3",
"value":    0.4,
"maturity":      3,
"country": "US" 
},
{
 "date": "02/28/2013",
"indexname": "DGS3",
"value":   0.35,
"maturity":      3,
"country": "US" 
},
{
 "date": "03/31/2013",
"indexname": "DGS3",
"value":   0.36,
"maturity":      3,
"country": "US" 
},
{
 "date": "04/30/2013",
"indexname": "DGS3",
"value":    0.3,
"maturity":      3,
"country": "US" 
},
{
 "date": "05/30/2013",
"indexname": "DGS3",
"value":   0.52,
"maturity":      3,
"country": "US" 
},
{
 "date": "06/24/2013",
"indexname": "DGS3",
"value":   0.74,
"maturity":      3,
"country": "US" 
},
{
 "date": "01/31/2013",
"indexname": "DGS5",
"value":   0.88,
"maturity":      5,
"country": "US" 
},
{
 "date": "02/28/2013",
"indexname": "DGS5",
"value":   0.75,
"maturity":      5,
"country": "US" 
},
{
 "date": "03/31/2013",
"indexname": "DGS5",
"value":   0.76,
"maturity":      5,
"country": "US" 
},
{
 "date": "04/30/2013",
"indexname": "DGS5",
"value":   0.65,
"maturity":      5,
"country": "US" 
},
{
 "date": "05/30/2013",
"indexname": "DGS5",
"value":   1.05,
"maturity":      5,
"country": "US" 
},
{
 "date": "06/24/2013",
"indexname": "DGS5",
"value":   1.49,
"maturity":      5,
"country": "US" 
},
{
 "date": "01/31/2013",
"indexname": "DGS7",
"value":    1.4,
"maturity":      7,
"country": "US" 
},
{
 "date": "02/28/2013",
"indexname": "DGS7",
"value":   1.23,
"maturity":      7,
"country": "US" 
},
{
 "date": "03/31/2013",
"indexname": "DGS7",
"value":   1.23,
"maturity":      7,
"country": "US" 
},
{
 "date": "04/30/2013",
"indexname": "DGS7",
"value":   1.07,
"maturity":      7,
"country": "US" 
},
{
 "date": "05/30/2013",
"indexname": "DGS7",
"value":   1.55,
"maturity":      7,
"country": "US" 
},
{
 "date": "06/24/2013",
"indexname": "DGS7",
"value":   2.03,
"maturity":      7,
"country": "US" 
},
{
 "date": "01/31/2013",
"indexname": "DGS10",
"value":   2.04,
"maturity":     10,
"country": "US" 
},
{
 "date": "02/28/2013",
"indexname": "DGS10",
"value":   1.86,
"maturity":     10,
"country": "US" 
},
{
 "date": "03/31/2013",
"indexname": "DGS10",
"value":   1.86,
"maturity":     10,
"country": "US" 
},
{
 "date": "04/30/2013",
"indexname": "DGS10",
"value":   1.66,
"maturity":     10,
"country": "US" 
},
{
 "date": "05/30/2013",
"indexname": "DGS10",
"value":   2.16,
"maturity":     10,
"country": "US" 
},
{
 "date": "06/24/2013",
"indexname": "DGS10",
"value":    2.6,
"maturity":     10,
"country": "US" 
},
{
 "date": "01/31/2013",
"indexname": "DGS20",
"value":   2.83,
"maturity":     20,
"country": "US" 
},
{
 "date": "02/28/2013",
"indexname": "DGS20",
"value":   2.68,
"maturity":     20,
"country": "US" 
},
{
 "date": "03/31/2013",
"indexname": "DGS20",
"value":    2.7,
"maturity":     20,
"country": "US" 
},
{
 "date": "04/30/2013",
"indexname": "DGS20",
"value":   2.44,
"maturity":     20,
"country": "US" 
},
{
 "date": "05/30/2013",
"indexname": "DGS20",
"value":   2.95,
"maturity":     20,
"country": "US" 
},
{
 "date": "06/24/2013",
"indexname": "DGS20",
"value":   3.31,
"maturity":     20,
"country": "US" 
},
{
 "date": "01/31/2013",
"indexname": "DGS30",
"value":   3.21,
"maturity":     30,
"country": "US" 
},
{
 "date": "02/28/2013",
"indexname": "DGS30",
"value":   3.06,
"maturity":     30,
"country": "US" 
},
{
 "date": "03/31/2013",
"indexname": "DGS30",
"value":   3.08,
"maturity":     30,
"country": "US" 
},
{
 "date": "04/30/2013",
"indexname": "DGS30",
"value":   2.83,
"maturity":     30,
"country": "US" 
},
{
 "date": "05/30/2013",
"indexname": "DGS30",
"value":    3.3,
"maturity":     30,
"country": "US" 
},
{
 "date": "06/24/2013",
"indexname": "DGS30",
"value":    3.6,
"maturity":     30,
"country": "US" 
} 
],
    xAxis = {
 "type": "addCategoryAxis",
"showPercent": false,
"orderRule": "date" 
},
    yAxis = {
 "type": "addPctAxis",
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


---
### More rCharts, slidify, and dimplejs

The beauty of [rCharts](http://rcharts.io/site) is its ability to harness the ingenuity from the entire ecosystem inside and outside of `r`.  Whole libraries, such as [dimplejs](http://dimplejs.org), [nvd3](http://nvd3.org), [rickshaw](http://code.shutterstock.com/rickshaw/), [highcharts](http://highcharts.com), [morris](http://www.oesmith.co.uk/morris.js/), and [polycharts](http://www.polychartjs.com/), or even specific custom [visualizations](http://rcharts.io/site/gallery.html) can quickly be incorporated into your workflow and publishing.  If desired, these can be delivered in various reproducible formats with [slidify](http://slidify.org).  I strongly encourage you to check out [rCharts](http://rcharts.io/site), [slidify](http://slidify.org), and [dimplejs](http://dimplejs.org).  They have changed my world.


---
### Thanks:
- [Ramnath Vaidyanathan](http://github.com/ramnathv) for his amazing dedication, responsiveness, and help with [rCharts](http://rcharts.io/site) and [slidify](http://slidify.org).
- [John Kiernander](https://twitter.com/jkiernander) for `dimplejs`[http://dimplejs.org] and his seemingly infinite supply of helpful and inspirational [examples](http://dimplejs.org/advanced_examples_index.html).
- [Mike Bostock](http://bost.ocks.org/mike/example/) for everything.
