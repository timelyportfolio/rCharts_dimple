### example 36 Vertical Stacked Area 100%

d1 <- dPlot(
  x = "UnitSales",
  y = "Month",
  groups = "Channel",
  data = subset(data, Owner %in% c("Aperture","Black Mesa")),
  type = "dimple.plot.area",
  bounds = list(x=80,y=30,height=480,width=330),
  height = 400,
  width = 590
)
d1$xAxis(type = "addPctAxis")
d1$yAxis(type = "addCategoryAxis", grouporderRule = "Date")
d1$set(
  legend = list(
    x = 60,
    y = 10,
    width = 500,
    height = 20,
    horizontalAlign = "right"
  )
)
d1