### example 10 horizontal stacked bar

d1 <- dPlot(
  x = "UnitSales", 
  y = c("PriceTier","Channel"),
  groups = "Channel",
  data = data,
  type = "dimple.plot.bar"
)
d1$xAxis(type = "addMeasureAxis")
#good test of orderRule on y instead of x
d1$yAxis(type = "addCategoryAxis")
d1$set(
  legend = list(
    x = 200,
    y = 10,
    width = 400,
    height = 20,
    horizontalAlign = "right"
  )
)
d1