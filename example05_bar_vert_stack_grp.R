### example 5 vertical stack grouped bar
d1 <- dPlot(
  x = c("PriceTier","Channel"),
  y = "UnitSales",
  groups = "Owner",
  data = data,
  type = "dimple.plot.bar"
)
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