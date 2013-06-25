### example 26 Horizontal Grouped Bubble Lollipop
d1 <- dPlot(
  y = c("PriceTier","Channel"),
  x = "UnitSales",
  z = "OperatingProfit",
  groups = "Channel",
  data = subset(
    data,
    Date %in% c(
      "01/07/2012",
      "01/08/2012",
      "01/09/2012",
      "01/10/2012",
      "01/11/2012",
      "01/12/2012"
    )
  ),
  type = "bubble"
)
d1$yAxis( type = "addCategoryAxis" )
d1$xAxis( type = "addMeasureAxis" )
d1$zAxis( type = "addMeasureAxis" )
d1$legend(
  x = 200,
  y = 10,
  width = 500,
  height = 20,
  horizontalAlign = "right"
)
d1