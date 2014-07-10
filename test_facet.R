require(rCharts)

mtcars.df <- data.frame(rownames(mtcars),mtcars)
colnames(mtcars.df)[1] <- "model"
rownames(mtcars.df) <- 1:nrow(mtcars.df)

d49 <- dPlot(
  x = "mpg",
  y = "wt",
  groups="model",
  data = mtcars.df,
  type = "bubble"
)
d49$xAxis(type = "addMeasureAxis")
#d49$xAxis(overrideMax = ceiling(max(mtcars.df[,"mpg"])))
#d49$yAxis(overrideMax = ceiling(max(mtcars.df[,"wt"])))
d49

d49$set(facet = list(x = "cyl"))
#d49$templates$script="inst/libraries/dimple/layouts/chartFacet.html"
#d49$templates$script = "http://timelyportfolio.github.io/rCharts_dimple/chartFacet.html"
d49

d49$set(facet = list(removeAxes=T))
d49


d50 <- d49$copy()
#d50$yAxis(overrideMax = ceiling(max(mtcars.df[,"wt"])))
d50$params$facet = list(x = NULL, y = "cyl", removeAxes=T) #only diff is setting  facet
d50


d51 <- dPlot(
  x = "mpg",
  y = "wt",
  z = "hp",
  groups=c("model","vs","am"),
  data = mtcars.df,
  type = "bubble",
  defaultColors = "#!d3.scale.category10()!#"
)
d51$xAxis(type = "addMeasureAxis")
d51$zAxis(type = "addMeasureAxis")
#d51$xAxis(overrideMax = ceiling(max(mtcars.df[,"mpg"])))
#d51$yAxis(overrideMax = ceiling(max(mtcars.df[,"wt"])))
d51$set(facet = list(x = "vs", y = "am"))
d51

d51$set(facet=list(removeAxes=T))
d51

d52 <- dPlot(
  x = "mpg",
  y = "wt",
  groups=c("cyl","vs","model"),
  data = mtcars.df,
  type = "bubble"
)
d52$xAxis(type = "addMeasureAxis")
d52$xAxis(overrideMax = ceiling(max(mtcars.df[,"mpg"])))
d52$yAxis(overrideMax = ceiling(max(mtcars.df[,"wt"])))
d52$set(facet = list(x = "cyl", y = "vs"))
d52


hair_eye = as.data.frame(HairEyeColor)
d60 <- dPlot(
  x = "Hair",
  y = "Freq",
  groups = "Eye",
  data = hair_eye,
  type = 'bar'
)
d60

d61 <- dPlot(
  Freq~Hair,# | Sex * Eye,
  groups = "Hair",
  data = hair_eye,
  type = 'bubble'
)
#d61$yAxis(overrideMax = 100)
d61$xAxis(orderRule = "Hair")
d61$set(facet=list(x = "Sex", y = "Eye", removeAxes=T))
d61


d62 <- d61$copy()
d62$set(
  groups = c("Sex","Hair")
  ,type = "bar"
)
d62$defaultColors("#!d3.scale.category10()!#")
d62

d62$set(facet = list(removeAxes = T))
d62
