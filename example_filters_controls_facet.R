#example how to use the new addFilters with angular and lodash

#require(devtools)
#install("rCharts","timelyportfolio",ref="dimple_controls")
require(rCharts)
options(viewer=NULL)
d1 <- dPlot(
  Freq ~ Sex,
  groups = c("Eye"),
  data = as.data.frame(HairEyeColor),
  type = "bar"  
)
d1$params$facet = list(x=NULL,y=NULL)
d1$addControls(
  "facetx",
  value = "Hair",
  values = colnames(as.data.frame(HairEyeColor)[-4])
)
d1$addControls(
  "x",
  value = "Sex",
  values = colnames(as.data.frame(HairEyeColor)[-4])
)
d1$addControls(
  "groups",
  value = "Eye",
  values = colnames(as.data.frame(HairEyeColor)[-4])
)
d1$addFilters("Hair","Eye")
d1$defaultColors("#!d3.scale.category10()!#")
d1


#d1$params$facet = list( ncol = 2 )
d1$params$facet = list( x = NULL, y = NULL, removeAxes = TRUE)
d1


d1$templates$script = 
  "./chart_singleselect.html"
  #"http://timelyportfolio.github.io/rCharts_dimple/chart_singleselect.html"
d1



d1$addAssets("./js/d3-grid.js")
d1$save("filter_controls_facet_single.html",cdn=T)
