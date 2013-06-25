### example 42 Grouped Single Line
d1 <- dPlot(
  y = "UnitSales",
  x = c("Owner","Month"),
  groups = "Owner",
  data = subset(data, Owner %in% c("Aperture","Black Mesa")),
  type = "line",
  barGap = 0.05
)
d1$xAxis(type = "addCategoryAxis", grouporderRule = "Date")
d1$yAxis(type = "addMeasureAxis")
d1