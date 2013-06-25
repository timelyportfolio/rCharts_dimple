### example 1 vt bar
d1 <- dPlot(
  x ="Month" ,
  y = "UnitSales",
  data = data,
  type = "dimple.plot.bar"
)
d1$xAxis(orderRule = "Date")
d1