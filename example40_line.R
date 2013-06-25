### example 40 Line
d1 <- dPlot(
  UnitSales ~ Month,
  data = subset(data, Owner %in% c("Aperture","Black Mesa")),
  type = "line"
)
d1$xAxis(type = "addCategoryAxis", orderRule = "Date")
d1$yAxis(type = "addMeasureAxis")
d1