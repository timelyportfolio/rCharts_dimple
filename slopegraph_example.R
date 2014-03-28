#use rCharts and dimple to kind of make a slope graph
#reference: http://www.jameskeirstead.ca/blog/slopegraphs-in-r/

#another very good reference on slopegraph
#http://charliepark.org/slopegraphs/#the_tablegraphic
#http://charliepark.org/a-slopegraph-update/

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
  width = 550,
  bounds = list(x=200,y=30,height=700,width=300)
)
d1

#with improvements from afterScript template
d1$setTemplate(
  afterScript = "
<script>
  //axes adjustments for slopegraph
  
  //based on template myChart.axes[2] should be y
  //but just to make sure do map
  var ySlope = myChart.axes.filter(function(axis){return axis.position==='y'})[0];
  var xSlope = myChart.axes.filter(function(axis){return axis.position==='x'})[0]
  
  //remove axis labels if desired
  ySlope.shapes.remove();
  //remove gridlines
  ySlope.gridlineShapes.remove();
  //remove axis title
  ySlope.titleShape.remove();
  
  var slopelabels = d3.select('#'+opts.id).select('svg').select('g').append('g')
   .attr('class','slopelabels')
  
  //get unique values for groups in data
  //note will only work with one group level
  var firstPoints = data.filter(function(d){
    return d[opts.x] == myChart.axes[0]._draw.scale().domain()[0];
  });
  
  slopelabels.selectAll('text')
    .data(firstPoints)
    .enter()
    .append('text')
    .attr('class','labels')
    //.attr('x', function(d){
    //  return xSlope._scale(d[opts.x])
    //})
    .attr('x',d3.select('.axis').select('.tick text').attr('x') - 20)
    .attr('y', function(d){
      return ySlope._scale(d[opts.y])
    })
    .attr('dy','0.2em')
    .attr('transform',d3.select('.axis').select('.tick').attr('transform'))
    .attr('fill',function(d)  {
      return myChart._assignedColors[d[opts.groups]].fill
    })
    //.attr('stroke',function(d){return myChart._assignedColors[d[opts.groups]].stroke})
    .attr('opacity',function(d){return myChart._assignedColors[d[opts.groups]].opacity})
    .style('text-anchor','end')
    .text(function(d){
      return d[opts.groups]
    });
  
    // constraint relaxation on labels
    // from http://bl.ocks.org/syntagmatic/4053096
    //add y for each of these to use code as is
    firstPoints.forEach(function(d){
      d.y = ySlope._scale(d[opts.y]);
    })
  
    var alpha = 0.5;
    var spacing = 12;
    function relax() {
      var again = false;
      firstPoints.forEach(function(a,i) {
        firstPoints.slice(i+1).forEach(function(b) {
          var dy = a.y - b.y;
          if (Math.abs(dy) < spacing) {
            again = true;
            var sign = dy > 0 ? 1 : -1;
            a.y += sign*alpha;
            b.y -= sign*alpha;
          }
        });
      });
      d3.selectAll('.labels')
        .attr('y', function(d) {
        return d.y;
      });
      if (again) setTimeout(relax,20);
    };
    
    relax();  
    
    
    //add numbers to each point
    var pointtext = d3.select('#'+opts.id).select('svg').select('g').append('g')
      .attr('class','pointtext')
    pointtext.selectAll('text')
      .data(data)
      .enter()
      .append('g')
      .attr('transform',function(d){
        return d3.select(d3.select('.axis').selectAll('.tick')[0].filter(function(dd){
          return d3.select(dd).datum() == d[opts.x]
        })[0]).attr('transform')
      })
      .append('text')
      .attr('x',function(d){
        return d3.select('.axis').select('.tick text').attr('x')
      })
      .attr('y',function(d){
        return ySlope._scale(d[opts.y])})
      .attr('dy','0.2em')
      //.attr('fill',function(d){return myChart._assignedColors[d[opts.groups]].fill})
      //.attr('stroke',function(d){return myChart._assignedColors[d[opts.groups]].stroke})
      //.attr('opacity',function(d){return myChart._assignedColors[d[opts.groups]].opacity})
      .attr('text-anchor','middle')
      .style('font-size','12')
      .style('pointer-events','none')
      .text(function(d){
        return d[opts.y]
      })
</script>"
)
d1
