### example 21 Dot Matrix
d1 <- dPlot(
  y = "Owner",
  x = c("Channel","PriceTier"),
  groups = "PriceTier",
  data = data,
  type = "bubble"
)
d1$xAxis( type = "addCategoryAxis" )
d1$yAxis( type = "addCategoryAxis")
d1$legend(
  x = 200,
  y = 10,
  width = 500,
  height = 20,
  horizontalAlign = "right"
)
d1