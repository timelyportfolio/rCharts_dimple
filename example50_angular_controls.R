#install_github("rCharts","timelyportfolio","test-speedimprove")

require(rCharts)
#get data used by dimple for all of its examples as a first test
data <- read.delim(
  "http://pmsi-alignalytics.github.io/dimple/data/example_data.tsv"
)

#eliminate . to avoid confusion in javascript
colnames(data) <- gsub("[.]","",colnames(data))

#example 1 vt bar
d1 <- dPlot(
  x ="Month" ,
  y = "UnitSales",
  data = data,
  type = "area"
)
d1$xAxis(orderRule = "Date")
d1$addControls("y", value = "UnitSales", values = names(data))
d1$addControls("groups", value = "", values = names(data))
d1$addControls("type", value = "area", values = c("bar","line","area"))
d1