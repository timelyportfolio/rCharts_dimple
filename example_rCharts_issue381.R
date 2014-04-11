#forked from https://gist.github.com/patilv/7073094

library(rCharts)
library(reshape2)
findata=read.csv("https://raw.github.com/patilv/rChartsTutorials/master/findata.csv")
# These are data regarding NCAA athletic department expenses at public universities. Please see the blog post where these charts were originally used 
# regarding more details on the origins of these data.: http://analyticsandvisualization.blogspot.com/2013/10/subsidies-revenues-and-expenses-of-ncaa.html
findata=findata[,-c(1:3)] # removing first dummy column - the csv quirk - second column on Rank, and third column on School. Retaining only numeric vars here
corrmatrix<-cor(findata) #store corr matrix
# The following steps are generic and can all be placed in a function with some tweaks to customize output 
corrdata=as.data.frame(corrmatrix)
corrdata$Variable1=names(corrdata)
corrdatamelt=melt(corrdata,id="Variable1")
names(corrdatamelt)=c("Variable1","Variable2","CorrelationCoefficient")
corrmatplot = dPlot(
  Variable2 ~ Variable1
  ,z = "CorrelationCoefficient"
  ,data = corrdatamelt
  ,type = 'bubble'
  ,height = 350
  ,width = 500
  ,bounds = list( x = 150, y = 50, width = 330, height = 200)
)
corrmatplot$yAxis ( type= "addCategoryAxis" )
corrmatplot$zAxis (
  type= "addMeasureAxis"
  , outputFormat = "0.5f"
  , overrideMin = -1
  , overrideMax = 1
)
corrmatplot$colorAxis(
  type = "addColorAxis"
  ,colorSeries = 'CorrelationCoefficient'
  ,palette = c('red','white','blue')
)
corrmatplot
