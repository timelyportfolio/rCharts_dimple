require(Lahman)  
require(plyr)
dat = Teams[,c('yearID', 'name', 'G', 'SO')]
team_data = na.omit(transform(dat, SOG = round(SO/G, 2)))
team_data$yearID = paste0(team_data$yearID, "-01-01")

ggplot(data = team_data, aes(x=yearID, y=SOG, colour=name)) +
  geom_point() +
  stat_summary(fun.y=mean,geom="line",aes(group=1))


require(rCharts)
p1 <- dPlot(
  SOG ~ yearID,
  groups = "average",
  data = team_data,
  type = 'line' 
)
p1$layer(
  y="SOG",
  x="yearID",
  groups = "name",
  data = NULL,
  type = 'bubble' 
)
p1$xAxis(
  type = "addTimeAxis",
  inputFormat = "%Y-%m-%d",
  outputFormat = "%Y"
)
p1$yAxis(
  outputFormat = ".2f",
  #axes are not linked, so dimple doesn't handle well
  #overrideMin and overrideMax are inherited though
  #if not specified in additional layers
  overrideMax = round(max(team_data$SOG))
)
myteam = "Boston Red Sox"
p1$layer(
  SOG ~ yearID,
  data = team_data[team_data$name == myteam,],
  groups = "name",
  type = 'line'
)
p1


#now clean it up a bit with new rCharts functionality
p1$setTemplate(
  afterScript = sprintf(
    '<script>
    //#remove the hover effect for the lines
    svg.selectAll("circle").selectAll("[id*=%s]").transition().remove()
    svg.selectAll("circle").selectAll("[id*=%s]").transition().remove()
    svg.selectAll("path")
        .transition()
        .delay(200)
        .style("pointer-events","none")
    //do a delayed transition to make the circles smaller
    //since dimple drawing has a transition; wait for it
    svg.selectAll("circle").transition().attr("r",1).delay(200)
    //delete some of the ticks
    svg.select(".axis").selectAll(".tick")[0].forEach(function(d,i){
          if (!(+d3.time.format("%%Y")(new Date(+d3.select(d).datum())) %% 10 == 0)) {
            d.remove()
          }
        });
    //fix scale for additional layers
    //does not work cross browser
    //use overrideMin/Max instead
    /*d3.selectAll("circle.series1.bubble")
      .transition()
      .attr("cy",function(d){
        return myChart.axes[1]._draw.scale()(d.y)
      })
      .delay(200);
    */
    </script>',
    "'league'",
    "'team'"
  )
)
p1

#color axis is not working as expected
# I think this is really nice functionality
# in next version make sure to solve this
p1$colorAxis(
  type = "addColorAxis",
  colorSeries = "SOG",
  palette = "#FF0000"
)