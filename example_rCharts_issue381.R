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
  ,outputFormat = "0.5f"
)
corrmatplot


#now do the bar
corrmatplot$set(type = "bar")
corrmatplot


#with the bar let's play with tooltips
#first tooltip will just be the number in the center of the bar
corrmatplot$templates$script = 
  "http://timelyportfolio.github.io/rCharts_dimple/chart_tooltip_flexible.html"

#this template is designed to let us define onHover and onLeave
#with thought afterScript but does not work since separate <script> block
#so use chartDiv instead
corrmatplot$setTemplate(
  chartDiv = 
'
<div id = "{{chartId}}"></div>
<script>
function onHover(e){
  //ugly but it works; if tooltip exists then select otherwise append
  //whole d3 enter, update, exit makes things difficult here
  var custTool = (
    d3.select(e.selectedShape[0][0].parentNode).select("#chartTooltip")[0][0] ? 
    d3.select(e.selectedShape[0][0].parentNode).select("#chartTooltip") :
    d3.select(e.selectedShape[0][0].parentNode).append("text").attr("id","chartTooltip")
  )
    
  custTool
    //reads outputFormat and assumes it exists
    .text(d3.format(opts.colorAxis.outputFormat)(e.selectedShape.data()[0].cValue))
    //turn dispay on with css since none from leave
    .style("display",null)
    .style("pointer-events","none")
    //use x and y from selected rectangle to position with transform for center
    .attr("x",e.selectedShape.attr("x"))
    .attr("y",e.selectedShape.attr("y"))
    //move to center
    .attr("transform",
      "translate(" + e.selectedShape.attr("width") / 2 + "," + e.selectedShape.attr("height")/2 + ")"
    )
    .attr("dy",6)
    .style("text-anchor","middle")
}
function onLeave(e){
  myChart.svg.select("#chartTooltip")
    .style("display","none");
}
</script>
'
,
afterScript = '<script></script>'
)
corrmatplot
