### example 31 Grouped Area

d1 <- dPlot(
  y = "UnitSales",
  x = c("Owner","Month"),
  groups = "Owner",
  data = subset(data, Owner %in% c("Aperture","Black Mesa")),
  type = "dimple.plot.area"
)
d1$xAxis(type = "addCategoryAxis", grouporderRule = "Date")
d1$yAxis(type = "addMeasureAxis")
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