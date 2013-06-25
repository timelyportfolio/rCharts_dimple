### example 36 Vertical 100% Stacked Area
d1 <- dPlot(
  x = "UnitSales",
  y = "Month",
  groups = "Channel",
  data = subset(data, Owner %in% c("Aperture","Black Mesa")),
  type = "area",
  bounds = list(x=80,y=30,height=480,width=330),
  height = 400,
  width = 590
)
d1$xAxis(type = "addPctAxis")
d1$yAxis(type = "addCategoryAxis", grouporderRule = "Date")
d1$legend(
  x = 60,
  y = 10,
  width = 500,
  height = 20,
  horizontalAlign = "right"
)
d1