### example 13 vertical marimekko

d1 <- dPlot(
  UnitSales ~ Channel,
  groups = "Owner",
  data = data,
  type = "dimple.plot.bar"
)
d1$xAxis(type = "addAxis", measure = "UnitSales", showPercent = TRUE)
d1$yAxis(type = "addPctAxis")
d1$set(
  legend = list(
    x = 200,
    y = 10,
    width = 400,
    height = 20,
    horizontalAlign = "right"
  )
)

d1$set(storyboard = "Date")
d1