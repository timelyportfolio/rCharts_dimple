### example 15 block matrix
d1 <- dPlot(
  x = c("Channel","PriceTier"),
  y = "Owner",
  groups = "PriceTier",
  data = data,
  type = "bar"
)
d1$yAxis(type = "addCategoryAxis")
d1$xAxis(type = "addCategoryAxis")
d1$legend(
  x = 200,
  y = 10,
  width = 400,
  height = 20,
  horizontalAlign = "right"
)
d1