## one way (probably temporary) of making a Title for a dimplejs plot

require(rCharts)

# use the classic iris dataset from R
# but add a column for observation so no aggregation on our scatter chart
iris.df <- data.frame(rownames(iris),iris)
colnames(iris.df)[1] <- "obs"

d1 <- dPlot(
  Sepal.Width ~ Petal.Length,
  groups = c("obs","Species"),
  data = iris.df,
  type = "bubble", 
  height = 400,
  width = 700
)
d1$xAxis( type = "addMeasureAxis" )
# not the right way but a way of specifying a template
# I put one up as an example of how we can specify a Title in R for our plot
d1$templates$script = "http://timelyportfolio.github.io/rCharts_dimple/chartWithTitle.html"

# now set a title for our chart
d1$set( title = "Iris Data with dimplejs" )
d1


d1$srccode = '
## one way (probably temporary) of making a Title for a dimplejs plot

require(rCharts)

# use the classic iris dataset from R
# but add a column for observation so no aggregation on our scatter chart
iris.df <- data.frame(rownames(iris),iris)
colnames(iris.df)[1] <- "obs"

d1 <- dPlot(
Sepal.Width ~ Petal.Length,
groups = c("obs","Species"),
data = iris.df,
type = "bubble"
)
d1$xAxis( type = "addMeasureAxis" )
# not the right way but a way of specifying a template
# I put one up as an example of how we can specify a Title in R for our plot
d1$templates$script = "http://timelyportfolio.github.io/rCharts_dimple/chartWithTitle.html"

# now set a title for our chart
d1$set( title = "Iris Data with dimplejs" )
d1'
d1$templates$page = "rChart2.html"

d1