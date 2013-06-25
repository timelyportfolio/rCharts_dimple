### example 27 Bubble Matrix
d1 <- dPlot(
  x = c( "Channel", "PriceTier"),
  y = "Owner",
  z = "Distribution",
  groups = "PriceTier",
  data = data,
  type = "bubble",
  aggregate = "dimple.aggregateMethod.max"
)
d1$xAxis( type = "addCategoryAxis" )
d1$yAxis( type = "addCategoryAxis" )
d1$zAxis( type = "addMeasureAxis", overrideMax = 200 )
d1$legend(
  x = 200,
  y = 10,
  width = 500,
  height = 20,
  horizontalAlign = "right"
)
d1