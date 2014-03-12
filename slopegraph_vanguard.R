require(dplyr)

#data from pimco and vanguard websites imported into Excel and translated into csv
#if local uncomment next line
#pimco_vanguard <- read.csv("vanguard_pimco.csv")
#get data from published google doc spreadsheet
#note this is old data
pimco_vanguard <- read.csv(
  "https://docs.google.com/spreadsheet/pub?key=0AieeEIaS0AOsdDFET0ZmbTBKWDNoMnZrZ0oySWRia1E&single=true&gid=0&output=csv"
)

vanguard_returns <- reshape2::melt(
  filter( pimco_vanguard, FundComplex == "Vanguard"),
  id.vars = 1:2,
  variable.name = "period",
  value.name = "return"
)
vanguard_returns$period <- gsub(
  x = vanguard_returns$period,
  pattern = "X1",
  replacement = "1"
)

#out of the box
d1 <- dPlot(
  return ~ period,
  groups = "FundSymbol",
  data = vanguard_returns,
  type = "line",
  height = 800,
  width = 550,
  bounds = list(x=200,y=30,height=700,width=300)
)
d1

#now let's make like a slopegraph
#inspired by James Keirstad's blog post Slopegraphs in R
#http://www.jameskeirstead.ca/blog/slopegraphs-in-r/
#using labelling technique from http://bl.ocks.org/syntagmatic/4053096
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
    return d3.format('.1%')(d[opts.y])
  })
</script>"
)
d1

#too many funds;  let's look with less funds
vanguard_returns$FundSymbol <- as.character(vanguard_returns$FundSymbol)
d1$yAxis( outputFormat = ".1%")
d1$params$data = subset(
  vanguard_returns,
  FundSymbol %in% unique(vanguard_returns$FundSymbol)[1:20]
)
d1