### example 18 Vertical Grouped Lollipop

d1 <- dPlot(
  y = "UnitSales",
  x = c("PriceTier","Channel"),
  groups = "Channel",
  data = data,
  type = "dimple.plot.bubble"
)
#defaults to yAxis (Measure) and xAxis (Category)
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