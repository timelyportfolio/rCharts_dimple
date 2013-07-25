### example 48 interactive legend
#get data used by dimple for all of its examples as a first test
data <- read.delim(
  "http://pmsi-alignalytics.github.io/dimple/data/example_data.tsv"
)
### eliminate . to avoid confusion in javascript
colnames(data) <- gsub("[.]","",colnames(data))

d1 <- dPlot(
  OperatingProfit~UnitSales,
  groups = c("SKU", "Channel", "Owner"),
  data = subset(data, Date == "01/12/2012"),
  type = "bubble",
  height = 400,
  width = 590,
  bounds = list(x=60, y=30, width=420, height=330)
)
d1$xAxis( type = "addCategoryAxis" )
d1$yAxis( type = "addMeasureAxis" )
d1$legend(
  x = 200,
  y = 10,
  width = 500,
  height = 20,
  horizontalAlign = "right"
)
d1