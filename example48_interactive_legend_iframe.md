### Build the Chart and Test iframe


```r
require(rCharts)
```

```
## Loading required package: rCharts
```

```r

data <- read.delim("http://pmsi-alignalytics.github.io/dimple/data/example_data.tsv")
### eliminate . to avoid confusion in javascript
colnames(data) <- gsub("[.]", "", colnames(data))

d1 <- dPlot(SalesValue ~ Price, groups = c("SKU", "Channel", "Owner"), data = subset(data, 
    Date == "01/12/2012"), type = "bubble", height = 400, width = 590, bounds = list(x = 60, 
    y = 30, width = 420, height = 330))
d1$xAxis(type = "addMeasureAxis")
d1$yAxis(type = "addMeasureAxis")
d1$legend(x = 530, y = 100, width = 60, height = 300, horizontalAlign = "right")
d1$templates$script = "assets/chart_legend.html"
d1$show()
```

<iframe src=figure/unnamed-chunk-1.html seamless></iframe>

