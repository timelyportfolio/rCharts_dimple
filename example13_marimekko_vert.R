#require(devtools)
#install_github('rCharts', 'ramnathv')
require(rCharts)

#get data used by dimple for all of its examples as a first test
data <- read.delim(
  "http://pmsi-alignalytics.github.io/dimple/data/example_data.tsv"
)

### eliminate . to avoid confusion in javascript
colnames(data) <- gsub("[.]","",colnames(data))

### example 13 vertical marimekko
d1 <- dPlot(
  UnitSales ~ Channel,
  groups = "Owner",
  data = data,
  type = "bar"
)
d1$xAxis(type = "addAxis", measure = "UnitSales", showPercent = TRUE)
d1$yAxis(type = "addPctAxis")
d1$legend(
  x = 200,
  y = 10,
  width = 400,
  height = 20,
  horizontalAlign = "right"
)
#test with storyboard
d1$set(storyboard = "Date")
d1