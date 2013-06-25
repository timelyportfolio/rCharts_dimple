### example 4 vertical grouped bar
d1 <- dPlot(
  x = c("PriceTier","Channel"),
  y = "UnitSales",
  groups = "Channel",
  data = data,
  type = "dimple.plot.bar"
)
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