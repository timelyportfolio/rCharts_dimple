require(rCharts)

options(stringsAsFactors=F)

views <- data.frame(
  Asset = c(
    "U.S. Treasuries"
    ,"Curve Positions"
    ,"Non US Developed"
    ,"Emerging Markets"
    ,"Mortgage-Backed Securities"
    ,"Investment Grade Credit"
    ,"High Yield"
    ,"Municipals"
    ,"Currency"
  ),
  View = c(
    3
    ,6
    ,3
    ,2
    ,4
    ,3
    ,3
    ,4
    ,2
  )
)

dP <- dPlot(
  Asset ~ View,
  data = views,
  type = "bar",
  height = 600,
  width = 600,
  bounds = list( x= 240, y = 50 , width = 360, height = 500)
)
dP$xAxis( type = "addMeasureAxis" )
dP$yAxis( type = "addCategoryAxis" )
dP

#need some color
dP$colorAxis(
  type = "addColorAxis",
  colorSeries = "View",
  palette = RColorBrewer::brewer.pal(n=5,"RdYlGn") 
)
dP

#probably need x to be Category Axis
dP$xAxis( type = "addCategoryAxis" )
dP
#but what about views without an asset
#in this case 1 and 5
#dimple does not allow easy way of specifying explicit
#categorical domain for axis scale
#we will fool it and then remove
dP$params$data = rbind(
  views,
  data.frame(
    Asset = rep("Currency",2),
    View = c(1,5)
  )
)
#now for the manual removal of the byproduct of fooling dimple
dP$setTemplate(
  afterScript = "
    <script>
      d3.selectAll('#All_1_Currency_,#All_5_Currency_').remove()
    </script>
  "
)
dP


#now our y Axis gets sorted in a way we might not like
dP$yAxis(
  orderRule = rev(views$Asset)
)
dP

#one last bit of cleanup
#label the axes as in the original
dP$setTemplate(
  afterScript = "
    <script>
      //get rid of dummy data
      d3.selectAll('#All_1_Currency_,#All_5_Currency_').remove()
      //get rid of text labels on x axis
      d3.select('.axis:nth-child(2)').selectAll('.tick text').remove()
      //label with text from original
      d3.select('.axis:nth-child(2)').select('.tick').append('text')
        .text('Minimum Allocation')
        .attr('dy','1.5em')
        .style('fill',myChart.axes[0].colors[0])
      d3.select('.axis:nth-child(2)').select('.tick:last-of-type').append('text')
        .text('Maximum Allocation')
        .attr('text-anchor','end')
        .attr('dy','1.5em')
        .style('fill',myChart.axes[0].colors[4])
    </script>
  "
)
dP

#but if we want to sort our y Axis by view
#could do this
dP$yAxis(
  orderRule = views$Asset[order(views$View,decreasing=T)]
)
dP