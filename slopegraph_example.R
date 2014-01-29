#use rCharts and dimple to kind of make a slope graph
#reference: http://www.jameskeirstead.ca/blog/slopegraphs-in-r/

data <- read.csv(
  "https://raw.github.com/jkeirstead/r-slopegraph/master/cancer_survival_rates.csv"
)

library(rCharts)

#out of the box
d1 <- dPlot(
  value ~ year,
  groups = "group",
  data = data,
  type = "line",
  height = 800,
  width = 500
)
d1

#with improvements from special script template
d1$templates$script = "http://timelyportfolio.github.io/rCharts_dimple/chart_slopegraph.html"
d1