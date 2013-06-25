### example 17 Vertical Lollipop
d1 <- dPlot(
  UnitSales ~ Month,
  groups = "Channel",
  data = data,
  type = "bubble"
)
#defaults to yAxis (Measure) and xAxis (Category)
d1$xAxis( orderRule = "Date")
d1$legend(
  x = 200,
  y = 10,
  width = 500,
  height = 20,
  horizontalAlign = "right"
)
d1