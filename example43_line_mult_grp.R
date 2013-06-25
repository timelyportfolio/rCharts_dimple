### example 43 Grouped Multiple line
d1 <- dPlot(
  y = "UnitSales",
  x = c("Owner","Month"),
  groups = "Brand",
  data = subset(data, Owner %in% c("Aperture","Black Mesa")),
  type = "line",
  bounds = list(x=70,y=30,height=420,width=330),
  barGap = 0.05,
  height = 400,
  width = 590
)
d1$xAxis(type = "addCategoryAxis", grouporderRule = "Date")
d1$yAxis(type = "addMeasureAxis")
d1$legend(
  x = 510,
  y = 20,
  width = 100,
  height = 300,
  horizontalAlign = "left"
)
d1