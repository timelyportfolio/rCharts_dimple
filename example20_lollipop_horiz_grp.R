### example 20 Horizontal Grouped Lollipop

d1 <- dPlot(
  x = "UnitSales",
  y = c("PriceTier","Channel"),
  groups = "Channel",
  data = data,
  type = "dimple.plot.bubble"
)
d1$xAxis( type = "addMeasureAxis" )
d1$yAxis( type = "addCategoryAxis")
d1$set(
  legend = list(
    x = 200,
    y = 10,
    width = 500,
    height = 20,
    horizontalAlign = "right"
  )
)
d1