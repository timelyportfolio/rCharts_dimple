require(dplyr)
require(quantmod)

getSymbols("DJIA", src = "FRED")

roc <- na.omit(merge(ROC(DJIA,n=1),ROC(DJIA,n=250)))

require(rCharts)
require(latticeExtra)
require(directlabels)

roc.df <- reshape2::melt(
  data.frame(
    date = as.Date(index(roc["1986::1987",])),
    ROC_1day = roc["1986::1987",1,drop=T],
    ROC_1year = roc["1986::1987",2,drop=T]
  )
  ,id.vars = 1
  , variable.name = "period"
  , value.name = "roc"
)

#draw a traditional lattice plot
direct.label(asTheEconomist(
  xyplot(roc~date,groups=period,data=roc.df,type="l"
  #       ,auto.key=TRUE
         
         ,main="Dow Jones Industrial Average (source: St. Louis Federal Reserve (FRED) )"
  )
),method="last.points")

#draw an interactive dimple chart
roc.df$date <- format(roc.df$date)
d1 <- dPlot(
  roc ~ date
  ,groups = "period"
  ,data = roc.df
  ,type = "line"
  ,height = 400
  ,width = 700
  ,bounds = list(x = 80, y = 70, width = 600 , height = 250)
  #,legend = list(x = , y = , width = , height = )
)
d1$xAxis(
  type = "addTimeAxis",
  inputFormat = "%Y-%m-%d",
  outputFormat = "%Y-%m-%d"
)
d1$yAxis(
  outputFormat = ".2%f"
)
d1$set(
  defaultColors = latticeExtra::theEconomist.theme()$superpose.line$col[c(1,4)]
)
d1$setTemplate(
  afterScript = 
'
<script>
    //get fewer ticks on x axis
    //this is a dimple issue that might or might not get fixed
    myChart.svg.select(".axis").selectAll(".tick")[0].forEach(function(d,i){
          if (!(+d3.time.format("%m")(new Date(+d3.select(d).datum())) % 3 == 1)) {
            d.remove()
          } else {
            var dtext = d3.select(d).selectAll("text");
            dtext
              .text(d3.time.format("%b %Y")(new Date(dtext.text())))
              .attr("transform","none")
              .attr("y",12)
              .style("text-anchor","middle");
          }
        });

    //remove x axis label
    myChart.axes[0].titleShape.remove()

    myChart.svg.append("text")
        .attr("id","charttitle")
        .attr("x", 0)
        .attr("y", 30)
        .text("Dow Jones Industrial Average (source: St. Louis Federal Reserve (FRED) )")
        .style("text-anchor","beginning")
        .style("font-size","16px")
        .style("font-family","sans-serif")
</script>
'    
)
d1
