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
d49$xAxis(overrideMax = ceiling(max(mtcars.df[,"mpg"])))
d49$yAxis(overrideMax = ceiling(max(mtcars.df[,"wt"])))
d49$set(facet = list(x = "cyl"))
d49$templates$script = system.file(
  "libraries/dimple/layouts/chartFacet.html",
  package = "rCharts"
)
d49

d50 <- d49
d50$yAxis(overrideMax = ceiling(max(mtcars.df[,"wt"])))
d50$params$facet = list(y = "cyl")
d50


d51 <- dPlot(
  x = "mpg",
  y = "wt",
  groups="model",
  data = mtcars.df,
  type = "bubble"
)
d51$xAxis(type = "addMeasureAxis")
d51$xAxis(overrideMax = ceiling(max(mtcars.df[,"mpg"])))
d51$yAxis(overrideMax = ceiling(max(mtcars.df[,"wt"])))
d51$set(facet = list(x = "vs", y = "am"))
d51$templates$script = system.file(
  "libraries/dimple/layouts/chartFacet.html",
  package = "rCharts"
)
d51


d52 <- dPlot(
  x = "mpg",
  y = "wt",
  groups="model",
  data = mtcars.df,
  type = "bubble"
)
d52$xAxis(type = "addMeasureAxis")
d52$xAxis(overrideMax = ceiling(max(mtcars.df[,"mpg"])))
d52$yAxis(overrideMax = ceiling(max(mtcars.df[,"wt"])))
d52$set(facet = list(x = "cyl", y = "vs"))
d52$templates$script = system.file(
  "libraries/dimple/layouts/chartFacet.html",
  package = "rCharts"
)
d52



hair_eye = as.data.frame(HairEyeColor)
d60 <- dPlot(
  x = "Hair",
  y = "Freq",
  groups = "Eye",
  data = hair_eye,
  type = 'bar'
)
d60$templates$script = system.file(
  "libraries/dimple/layouts/chartFacet.html",
  package = "rCharts"
)
d60$set(facet = list(x = "Sex"))
d60


d61 <- dPlot(
  Freq~Hair,# | Sex * Eye,
  groups = "Hair",
  data = hair_eye,
  type = 'bubble'
)
d61$templates$script = system.file(
  "libraries/dimple/layouts/chartFacet.html",
  package = "rCharts"
)
d61$yAxis(overrideMax = 100)
d61$xAxis(orderRule = "Hair")
d61$facet(x = "Sex", y = "Eye")
d61


d62 = d61
d62$params$type = "bar"
d62