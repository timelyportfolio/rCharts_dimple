###e xample 46 Vertical Grouped Line
d1 <- dPlot(
  x = "UnitSales",
  y = c("Owner","Month"),
  groups = "Owner",
  data = subset(data, Owner %in% c("Aperture","Black Mesa")),
  type = "line",
  bounds = list(x=90,y=30,height=470,width=330),
  barGap = 0.05,
  height = 400,
  width = 590
)
d1$xAxis(type = "addMeasureAxis")
d1$yAxis(type = "addCategoryAxis", grouporderRule = "Date")
d1