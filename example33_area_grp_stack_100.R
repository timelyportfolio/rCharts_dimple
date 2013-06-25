### example 33 Grouped Stacked Area 100%
d1 <- dPlot(
  y = "UnitSales",
  x = c("Owner","Month"),
  groups = "SKU",
  data = subset(data, Owner %in% c("Aperture","Black Mesa")),
  type = "area",
  bounds = list(x=70,y=30,height=340,width=330),
  barGap = 0.05,
  lineWeight = 1,
  height = 400,
  width = 590
)
d1$xAxis(type = "addCategoryAxis", grouporderRule = "Date")
d1$yAxis(type = "addPctAxis")
d1$legend(
  x = 430,
  y = 20,
  width = 100,
  height = 300,
  horizontalAlign = "left"
)
d1