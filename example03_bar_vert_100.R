### example 3 vt stacked bar
d1 <- dPlot(
  x ="Month" ,
  y = "UnitSales",
  groups = "Channel",
  data = data,
  type = "dimple.plot.bar"
)
d1$xAxis(orderRule = "Date")
d1$yAxis(type = "addPctAxis")
d1$set(
  legend = list(
    x = 60,
    y = 10,
    width = 700,
    height = 20,
    horizontalAlign = "right"
  )
)
d1