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
d1
