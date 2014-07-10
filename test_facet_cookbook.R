#try to do with dimple + rCharts
#http://www.cookbook-r.com/Graphs/Facets_(ggplot2)/

library(reshape2)
library(ggplot2)
library(rCharts)
library(dplyr)
library(magrittr)
tips

oldviewer = options("viewer")
options(viewer=NULL)
#sp <- ggplot(tips, aes(x=total_bill, y=tip/total_bill)) + geom_point(shape=1)

dp <- tips %>%
  data.frame(tip_pct = .$tip/.$total_bill) %>%
  dPlot(
    tip_pct ~ total_bill,
    groups = c("tip_pct","total_bill"),
    data = .,
    type = "bubble",
    xAxis = list(type = "addMeasureAxis")
  ) %T>%
  .$set(defaultColors = "#!['#CCCCCC']!#") %T>%
  show() %T>%
  .$set(facet = list (y = "sex"), width = 400, height = 600) %T>%
  show()  %T>%
  .$set(facet = list (x="sex",y =NULL,removeAxes=T), width = 600, height = 400) %T>%
  show()  %T>%
  .$set(facet = list (x="sex",y = "day",removeAxes=T, width = 600, height = 600)) %T>%
  show()  %T>%

dp %T>% .$set(
    facet = list (x="sex",y = "day",removeAxes=F)
    , width = 600
    , height = 600
    # setBounds not working yet
    , setBounds = list( x = 50 , y = 10, width = 550, height = 500)
    , margins = list(top=20,bottom=30, right=20, left=100)
  ) %>% show()



# example from free scale to try bar
gp <- ggplot_build(
  ggplot(tips, aes(x=total_bill)) + 
    geom_histogram(binwidth=2,colour="white") +
    facet_grid(sex ~ smoker)
)

gp %>%
  use_series(data) %>% .[[1]] %>%
  inner_join(y = gp$panel$layout) %>%
  dPlot(
    ncount ~ x,
    data = .,
    type = "bar",
    defaultColors = RColorBrewer::brewer.pal(9,"Greys")[c(5,7)]
  ) %T>%
  show() %T>%
  .$set(facet =list(y="sex",x="smoker", removeAxes=T), defaultColors = "#!d3.scale.category10()!#") %T>%
  show() %T>%
  .$set(facet =list(y="sex", x="smoker", removeAxes=T), groups = "smoker", defaultColors = "#!d3.scale.category20b().range().reverse().splice(8,3)!#", type="area", y = "density") %T>%
  show() %T>%
  .$set(facet =list(x=NULL,y=NULL,removeAxes=NULL), type="area", y = "density", groups = "smoker", defaultColors=topo.colors(30)[c(5,15)] %>% substr(1,7)) %T>%
  show() %T>%
  .$set(type = "line") %T>%
  show() %T>%
  .$set(interpolation = "step", groups = "sex",  defaultColors = latticeExtra::theEconomist.theme()$superpose.line$col[c(1,4)]) %T>%
  show() %T>%
  .$set(type = "bar", x = c("smoker","x"), xAxis = list(grouporderRule = "x"),defaultColors = "#!d3.scale.ordinal().domain(['Female','Male']).range(['#EF3B2C','#4292C6'])!#") %T>%
  show()