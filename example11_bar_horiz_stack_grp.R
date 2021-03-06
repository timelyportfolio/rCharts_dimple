### example 11 horizontal stacked grouped bar
d1 <- dPlot(
  x = "UnitSales", 
  y = c("PriceTier","Channel"),
  groups = "Owner",
  data = data,
  type = "bar"
)
d1$xAxis(type = "addMeasureAxis")
#good test of orderRule on y instead of x
d1$yAxis(type = "addCategoryAxis")
d1$legend(
  x = 200,
  y = 10,
  width = 400,
  height = 20,
  horizontalAlign = "right"
)
d1