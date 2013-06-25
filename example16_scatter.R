### example 16 Scatter
d1 <- dPlot(
  OperatingProfit~UnitSales,
  groups = c("SKU","Channel"),
  data = subset(data, Date == "01/12/2012"),
  type = "bubble"
)
d1$xAxis( type = "addMeasureAxis" )
d1$yAxis( type = "addMeasureAxis" )
d1$legend(
  x = 200,
  y = 10,
  width = 500,
  height = 20,
  horizontalAlign = "right"
)
d1