---
title: rCharts + dimple | Slopegraph
author: Timely Portfolio
github: {user: timelyportfolio, repo: rCharts_dimple, branch: "gh-pages"}
framework: bootstrap
mode: selfcontained
highlighter: prettify
hitheme: twitter-bootstrap
---
  
<style>
  .container { width: 850px;}
</style>

## rCharts + dimple | Slopegraph

James Keirstead implemented [slopegraphs in R](http://www.jameskeirstead.ca/blog/slopegraphs-in-r/) based on the the very thorough post from [Charlie Park](http://charliepark.org/slopegraphs/#the_tablegraphic).  I couldn't resist trying to do something similar with [rCharts](http://rcharts.io) and [dimplejs](http://dimplejs.org).










<h4>First Try | Out of the Box</h4>
A slopegraph most closely resembles a line graph.  Let's plot the data in a simple line graph using `type = 'line'` with dimple.


```r
d1 <- dPlot2(  #dPlot2 for minor internal change to iframesrc
  value ~ year,
  groups = "group",
  data = data,
  type = "line",
  height = 800,
  width = 550,
  bounds = list(x=200,y=30,height=700,width=300)
)
d1$show("iframesrc")
```

<iframe srcdoc='
&lt;!doctype HTML&gt;
&lt;meta charset = &#039;utf-8&#039;&gt;
&lt;html&gt;
  &lt;head&gt;
    
    &lt;script src=&#039;C:/Program Files/R/R-3.0.2/library/rCharts/libraries/dimple/js/dimple.v1.1.5.js&#039; type=&#039;text/javascript&#039;&gt;&lt;/script&gt;
    &lt;script src=&#039;C:/Program Files/R/R-3.0.2/library/rCharts/libraries/dimple/js/d3.v3.js&#039; type=&#039;text/javascript&#039;&gt;&lt;/script&gt;
    &lt;script src=&#039;C:/Program Files/R/R-3.0.2/library/rCharts/libraries/dimple/js/d3-grid.js&#039; type=&#039;text/javascript&#039;&gt;&lt;/script&gt;
    
    &lt;style&gt;
    .rChart {
      display: block;
      margin-left: auto; 
      margin-right: auto;
      width: 550px;
      height: 800px;
    }  
    &lt;/style&gt;
    
  &lt;/head&gt;
  &lt;body &gt;
    
    &lt;div id = &#039;chart2c2c33ea8ac&#039; class = &#039;rChart dimple&#039;&gt;&lt;/div&gt;    
    &lt;script type=&quot;text/javascript&quot;&gt;
  var opts = {
 &quot;dom&quot;: &quot;chart2c2c33ea8ac&quot;,
&quot;width&quot;:    550,
&quot;height&quot;:    800,
&quot;xAxis&quot;: {
 &quot;type&quot;: &quot;addCategoryAxis&quot;,
&quot;showPercent&quot;: false 
},
&quot;yAxis&quot;: {
 &quot;type&quot;: &quot;addMeasureAxis&quot;,
&quot;showPercent&quot;: false 
},
&quot;zAxis&quot;: [],
&quot;colorAxis&quot;: [],
&quot;defaultColors&quot;: [],
&quot;layers&quot;: [],
&quot;legend&quot;: [],
&quot;x&quot;: &quot;year&quot;,
&quot;y&quot;: &quot;value&quot;,
&quot;groups&quot;: &quot;group&quot;,
&quot;type&quot;: &quot;line&quot;,
&quot;bounds&quot;: {
 &quot;x&quot;:    200,
&quot;y&quot;:     30,
&quot;height&quot;:    700,
&quot;width&quot;:    300 
},
&quot;id&quot;: &quot;chart2c2c33ea8ac&quot; 
},
    data = [{&quot;group&quot;:&quot;Oral cavity&quot;,&quot;year&quot;:5,&quot;value&quot;:56.7},{&quot;group&quot;:&quot;Oesophagus&quot;,&quot;year&quot;:5,&quot;value&quot;:14.2},{&quot;group&quot;:&quot;Stomach&quot;,&quot;year&quot;:5,&quot;value&quot;:23.8},{&quot;group&quot;:&quot;Colon&quot;,&quot;year&quot;:5,&quot;value&quot;:61.7},{&quot;group&quot;:&quot;Rectum&quot;,&quot;year&quot;:5,&quot;value&quot;:62.6},{&quot;group&quot;:&quot;Liver and intrahepatic bile duct&quot;,&quot;year&quot;:5,&quot;value&quot;:7.5},{&quot;group&quot;:&quot;Pancreas&quot;,&quot;year&quot;:5,&quot;value&quot;:4},{&quot;group&quot;:&quot;Larynx&quot;,&quot;year&quot;:5,&quot;value&quot;:68.8},{&quot;group&quot;:&quot;Lung and bronchus&quot;,&quot;year&quot;:5,&quot;value&quot;:15},{&quot;group&quot;:&quot;Melanomas&quot;,&quot;year&quot;:5,&quot;value&quot;:89},{&quot;group&quot;:&quot;Breast&quot;,&quot;year&quot;:5,&quot;value&quot;:86.4},{&quot;group&quot;:&quot;Cervix uteri&quot;,&quot;year&quot;:5,&quot;value&quot;:70.5},{&quot;group&quot;:&quot;Corpus uteri and uterus&quot;,&quot;year&quot;:5,&quot;value&quot;:84.3},{&quot;group&quot;:&quot;Ovary&quot;,&quot;year&quot;:5,&quot;value&quot;:55},{&quot;group&quot;:&quot;Prostate&quot;,&quot;year&quot;:5,&quot;value&quot;:98.8},{&quot;group&quot;:&quot;Testis&quot;,&quot;year&quot;:5,&quot;value&quot;:94.7},{&quot;group&quot;:&quot;Urinary bladder&quot;,&quot;year&quot;:5,&quot;value&quot;:82.1},{&quot;group&quot;:&quot;Kidney and renal pelvis&quot;,&quot;year&quot;:5,&quot;value&quot;:61.8},{&quot;group&quot;:&quot;Brain and other nervous system&quot;,&quot;year&quot;:5,&quot;value&quot;:32},{&quot;group&quot;:&quot;Thyroid&quot;,&quot;year&quot;:5,&quot;value&quot;:96},{&quot;group&quot;:&quot;Hodgkin&#039;s disease&quot;,&quot;year&quot;:5,&quot;value&quot;:85.1},{&quot;group&quot;:&quot;Non-Hodgkin lymphomas&quot;,&quot;year&quot;:5,&quot;value&quot;:57.8},{&quot;group&quot;:&quot;Multiple myeloma&quot;,&quot;year&quot;:5,&quot;value&quot;:29.5},{&quot;group&quot;:&quot;Leukaemias&quot;,&quot;year&quot;:5,&quot;value&quot;:42.5},{&quot;group&quot;:&quot;Oral cavity&quot;,&quot;year&quot;:10,&quot;value&quot;:44.2},{&quot;group&quot;:&quot;Oesophagus&quot;,&quot;year&quot;:10,&quot;value&quot;:7.9},{&quot;group&quot;:&quot;Stomach&quot;,&quot;year&quot;:10,&quot;value&quot;:19.4},{&quot;group&quot;:&quot;Colon&quot;,&quot;year&quot;:10,&quot;value&quot;:55.4},{&quot;group&quot;:&quot;Rectum&quot;,&quot;year&quot;:10,&quot;value&quot;:55.2},{&quot;group&quot;:&quot;Liver and intrahepatic bile duct&quot;,&quot;year&quot;:10,&quot;value&quot;:5.8},{&quot;group&quot;:&quot;Pancreas&quot;,&quot;year&quot;:10,&quot;value&quot;:3},{&quot;group&quot;:&quot;Larynx&quot;,&quot;year&quot;:10,&quot;value&quot;:56.7},{&quot;group&quot;:&quot;Lung and bronchus&quot;,&quot;year&quot;:10,&quot;value&quot;:10.6},{&quot;group&quot;:&quot;Melanomas&quot;,&quot;year&quot;:10,&quot;value&quot;:86.7},{&quot;group&quot;:&quot;Breast&quot;,&quot;year&quot;:10,&quot;value&quot;:78.3},{&quot;group&quot;:&quot;Cervix uteri&quot;,&quot;year&quot;:10,&quot;value&quot;:64.1},{&quot;group&quot;:&quot;Corpus uteri and uterus&quot;,&quot;year&quot;:10,&quot;value&quot;:83.2},{&quot;group&quot;:&quot;Ovary&quot;,&quot;year&quot;:10,&quot;value&quot;:49.3},{&quot;group&quot;:&quot;Prostate&quot;,&quot;year&quot;:10,&quot;value&quot;:95.2},{&quot;group&quot;:&quot;Testis&quot;,&quot;year&quot;:10,&quot;value&quot;:94},{&quot;group&quot;:&quot;Urinary bladder&quot;,&quot;year&quot;:10,&quot;value&quot;:76.2},{&quot;group&quot;:&quot;Kidney and renal pelvis&quot;,&quot;year&quot;:10,&quot;value&quot;:54.4},{&quot;group&quot;:&quot;Brain and other nervous system&quot;,&quot;year&quot;:10,&quot;value&quot;:29.2},{&quot;group&quot;:&quot;Thyroid&quot;,&quot;year&quot;:10,&quot;value&quot;:95.8},{&quot;group&quot;:&quot;Hodgkin&#039;s disease&quot;,&quot;year&quot;:10,&quot;value&quot;:79.8},{&quot;group&quot;:&quot;Non-Hodgkin lymphomas&quot;,&quot;year&quot;:10,&quot;value&quot;:46.3},{&quot;group&quot;:&quot;Multiple myeloma&quot;,&quot;year&quot;:10,&quot;value&quot;:12.7},{&quot;group&quot;:&quot;Leukaemias&quot;,&quot;year&quot;:10,&quot;value&quot;:32.4},{&quot;group&quot;:&quot;Oral cavity&quot;,&quot;year&quot;:15,&quot;value&quot;:37.5},{&quot;group&quot;:&quot;Oesophagus&quot;,&quot;year&quot;:15,&quot;value&quot;:7.7},{&quot;group&quot;:&quot;Stomach&quot;,&quot;year&quot;:15,&quot;value&quot;:19},{&quot;group&quot;:&quot;Colon&quot;,&quot;year&quot;:15,&quot;value&quot;:53.9},{&quot;group&quot;:&quot;Rectum&quot;,&quot;year&quot;:15,&quot;value&quot;:51.8},{&quot;group&quot;:&quot;Liver and intrahepatic bile duct&quot;,&quot;year&quot;:15,&quot;value&quot;:6.3},{&quot;group&quot;:&quot;Pancreas&quot;,&quot;year&quot;:15,&quot;value&quot;:2.7},{&quot;group&quot;:&quot;Larynx&quot;,&quot;year&quot;:15,&quot;value&quot;:45.8},{&quot;group&quot;:&quot;Lung and bronchus&quot;,&quot;year&quot;:15,&quot;value&quot;:8.1},{&quot;group&quot;:&quot;Melanomas&quot;,&quot;year&quot;:15,&quot;value&quot;:83.5},{&quot;group&quot;:&quot;Breast&quot;,&quot;year&quot;:15,&quot;value&quot;:71.3},{&quot;group&quot;:&quot;Cervix uteri&quot;,&quot;year&quot;:15,&quot;value&quot;:62.8},{&quot;group&quot;:&quot;Corpus uteri and uterus&quot;,&quot;year&quot;:15,&quot;value&quot;:80.8},{&quot;group&quot;:&quot;Ovary&quot;,&quot;year&quot;:15,&quot;value&quot;:49.9},{&quot;group&quot;:&quot;Prostate&quot;,&quot;year&quot;:15,&quot;value&quot;:87.1},{&quot;group&quot;:&quot;Testis&quot;,&quot;year&quot;:15,&quot;value&quot;:91.1},{&quot;group&quot;:&quot;Urinary bladder&quot;,&quot;year&quot;:15,&quot;value&quot;:70.3},{&quot;group&quot;:&quot;Kidney and renal pelvis&quot;,&quot;year&quot;:15,&quot;value&quot;:49.8},{&quot;group&quot;:&quot;Brain and other nervous system&quot;,&quot;year&quot;:15,&quot;value&quot;:27.6},{&quot;group&quot;:&quot;Thyroid&quot;,&quot;year&quot;:15,&quot;value&quot;:94},{&quot;group&quot;:&quot;Hodgkin&#039;s disease&quot;,&quot;year&quot;:15,&quot;value&quot;:73.8},{&quot;group&quot;:&quot;Non-Hodgkin lymphomas&quot;,&quot;year&quot;:15,&quot;value&quot;:38.3},{&quot;group&quot;:&quot;Multiple myeloma&quot;,&quot;year&quot;:15,&quot;value&quot;:7},{&quot;group&quot;:&quot;Leukaemias&quot;,&quot;year&quot;:15,&quot;value&quot;:29.7},{&quot;group&quot;:&quot;Oral cavity&quot;,&quot;year&quot;:20,&quot;value&quot;:33},{&quot;group&quot;:&quot;Oesophagus&quot;,&quot;year&quot;:20,&quot;value&quot;:5.4},{&quot;group&quot;:&quot;Stomach&quot;,&quot;year&quot;:20,&quot;value&quot;:14.9},{&quot;group&quot;:&quot;Colon&quot;,&quot;year&quot;:20,&quot;value&quot;:52.3},{&quot;group&quot;:&quot;Rectum&quot;,&quot;year&quot;:20,&quot;value&quot;:49.2},{&quot;group&quot;:&quot;Liver and intrahepatic bile duct&quot;,&quot;year&quot;:20,&quot;value&quot;:7.6},{&quot;group&quot;:&quot;Pancreas&quot;,&quot;year&quot;:20,&quot;value&quot;:2.7},{&quot;group&quot;:&quot;Larynx&quot;,&quot;year&quot;:20,&quot;value&quot;:37.8},{&quot;group&quot;:&quot;Lung and bronchus&quot;,&quot;year&quot;:20,&quot;value&quot;:6.5},{&quot;group&quot;:&quot;Melanomas&quot;,&quot;year&quot;:20,&quot;value&quot;:82.8},{&quot;group&quot;:&quot;Breast&quot;,&quot;year&quot;:20,&quot;value&quot;:65},{&quot;group&quot;:&quot;Cervix uteri&quot;,&quot;year&quot;:20,&quot;value&quot;:60},{&quot;group&quot;:&quot;Corpus uteri and uterus&quot;,&quot;year&quot;:20,&quot;value&quot;:79.2},{&quot;group&quot;:&quot;Ovary&quot;,&quot;year&quot;:20,&quot;value&quot;:49.6},{&quot;group&quot;:&quot;Prostate&quot;,&quot;year&quot;:20,&quot;value&quot;:81.1},{&quot;group&quot;:&quot;Testis&quot;,&quot;year&quot;:20,&quot;value&quot;:88.2},{&quot;group&quot;:&quot;Urinary bladder&quot;,&quot;year&quot;:20,&quot;value&quot;:67.9},{&quot;group&quot;:&quot;Kidney and renal pelvis&quot;,&quot;year&quot;:20,&quot;value&quot;:47.3},{&quot;group&quot;:&quot;Brain and other nervous system&quot;,&quot;year&quot;:20,&quot;value&quot;:26.1},{&quot;group&quot;:&quot;Thyroid&quot;,&quot;year&quot;:20,&quot;value&quot;:95.4},{&quot;group&quot;:&quot;Hodgkin&#039;s disease&quot;,&quot;year&quot;:20,&quot;value&quot;:67.1},{&quot;group&quot;:&quot;Non-Hodgkin lymphomas&quot;,&quot;year&quot;:20,&quot;value&quot;:34.3},{&quot;group&quot;:&quot;Multiple myeloma&quot;,&quot;year&quot;:20,&quot;value&quot;:4.8},{&quot;group&quot;:&quot;Leukaemias&quot;,&quot;year&quot;:20,&quot;value&quot;:26.2}];
  var svg = dimple.newSvg(&quot;#&quot; + opts.id, opts.width, opts.height);

  //data = dimple.filterData(data, &quot;Owner&quot;, [&quot;Aperture&quot;, &quot;Black Mesa&quot;])
  var myChart = new dimple.chart(svg, data);
  if (opts.bounds) {
    myChart.setBounds(opts.bounds.x, opts.bounds.y, opts.bounds.width, opts.bounds.height);//myChart.setBounds(80, 30, 480, 330);
  }
  //dimple allows use of custom CSS with noFormats
  if(opts.noFormats) { myChart.noFormats = opts.noFormats; };
  //for markimekko and addAxis also have third parameter measure
  //so need to evaluate if measure provided
  
  //function to build axes
  function buildAxis(position,layer){
    var axis;
    var axisopts = opts[position+&quot;Axis&quot;];
    
    if(axisopts.measure) {
      axis = myChart[axisopts.type](position,layer[position],axisopts.measure);
    } else {
      axis = myChart[axisopts.type](position, layer[position]);
    };
    if(!(axisopts.type === &quot;addPctAxis&quot;)) axis.showPercent = axisopts.showPercent;
    if (axisopts.orderRule) axis.addOrderRule(axisopts.orderRule);
    if (axisopts.grouporderRule) axis.addGroupOrderRule(axisopts.grouporderRule);  
    if (axisopts.overrideMin) axis.overrideMin = axisopts.overrideMin;
    if (axisopts.overrideMax) axis.overrideMax = axisopts.overrideMax;
    if (axisopts.overrideMax) axis.overrideMax = axisopts.overrideMax;
    if (axisopts.inputFormat) axis.dateParseFormat = axisopts.inputFormat;
    if (axisopts.outputFormat) axis.tickFormat = axisopts.outputFormat;    
    return axis;
  };
  
  var c = null;
  if(d3.keys(opts.colorAxis).length &gt; 0) {
    c = myChart[opts.colorAxis.type](opts.colorAxis.colorSeries,opts.colorAxis.palette) ;
  }
  
  //allow manipulation of default colors to use with dimple
  if(opts.defaultColors.length) {
    opts.defaultColors = opts.defaultColors[0];
    if (typeof(opts.defaultColors) == &quot;function&quot;) {
      //assume this is a d3 scale
      //for now loop through first 20 but need a better way to handle
      defaultColorsArray = [];
      for (var n=0;n&lt;20;n++) {
        defaultColorsArray.push(opts.defaultColors(n));
      };
      opts.defaultColors = defaultColorsArray;
    }
    opts.defaultColors.forEach(function(d,i) {
      opts.defaultColors[i] = new dimple.color(d);
    })
    myChart.defaultColors = opts.defaultColors;
  }  
  
  //do series
  //set up a function since same for each
  //as of now we have x,y,groups,data,type in opts for primary layer
  //and other layers reside in opts.layers
  function buildSeries(layer, hidden){
    //inherit from primary layer if not intentionally changed or xAxis, yAxis, zAxis null
    if (!layer.xAxis) layer.xAxis = opts.xAxis;    
    if (!layer.yAxis) layer.yAxis = opts.yAxis;
    if (!layer.zAxis) layer.zAxis = opts.zAxis;
    
    var x = buildAxis(&quot;x&quot;, layer);
    x.hidden = hidden;
    
    var y = buildAxis(&quot;y&quot;, layer);
    y.hidden = hidden;
    
    //z for bubbles
    var z = null;
    if (!(typeof(layer.zAxis) === &#039;undefined&#039;) &amp;&amp; layer.zAxis.type){
      z = buildAxis(&quot;z&quot;, layer);
    };
    
    //here think I need to evaluate group and if missing do null
    //as the group argument
    //if provided need to use groups from layer
    var s = new dimple.series(myChart, null, x, y, z, c, dimple.plot[layer.type], dimple.aggregateMethod.avg, dimple.plot[layer.type].stacked);
    
    //as of v1.1.4 dimple can use different dataset for each series
    if(layer.data){
      //convert to an array of objects
      var tempdata;
      //avoid lodash for now
      datakeys = d3.keys(layer.data)
      tempdata = layer.data[datakeys[1]].map(function(d,i){
        var tempobj = {}
        datakeys.forEach(function(key){
          tempobj[key] = layer.data[key][i]
        })
        return tempobj
      })
      s.data = tempdata;
    }
    
    if(layer.hasOwnProperty(&quot;groups&quot;)) {
      s.categoryFields = (typeof layer.groups === &quot;object&quot;) ? layer.groups : [layer.groups];
      //series offers an aggregate method that we will also need to check if available
      //options available are avg, count, max, min, sum
      if (!(typeof(layer.aggregate) === &#039;undefined&#039;)) {
        s.aggregate = eval(layer.aggregate);
      }
      if (!(typeof(layer.lineWeight) === &#039;undefined&#039;)) {
        s.lineWeight = eval(layer.lineWeight);
      }
      if (!(typeof(layer.barGap) === &#039;undefined&#039;)) {
        s.barGap = eval(layer.barGap);
      }    
    };    
   /* if (!(typeof(layer.eventHandler) === &#039;undefined&#039;)) {
      layer.eventHandler = (layer.eventHandler.length === &quot;undefined&quot;) ? layer.eventHandler : [layer.eventHandler];
      layer.eventHandler.forEach(function(evt){
        s.addEventHandler(evt.event, eval(evt.handler))
      })
    }*/
      
    myChart.series.push(s);
    
    /*placeholder fix domain of primary scale for new series data
    //not working right now but something like this
    //for now just use overrideMin and overrideMax from rCharts
    for( var i = 0; i&lt;2; i++) {
      if (!myChart.axes[i].overrideMin) {
        myChart.series[0]._axisBounds(i==0?&quot;x&quot;:&quot;y&quot;).min = myChart.series[0]._axisBounds(i==0?&quot;x&quot;:&quot;y&quot;).min &lt; s._axisBounds(i==0?&quot;x&quot;:&quot;y&quot;).min ? myChart.series[0]._axisBounds(i==0?&quot;x&quot;:&quot;y&quot;).min : s._axisBounds(i==0?&quot;x&quot;:&quot;y&quot;).min;
      }
      if (!myChart.axes[i].overrideMax) {  
        myChart.series[0]._axisBounds(i==0?&quot;x&quot;:&quot;y&quot;)._max = myChart.series[0]._axisBounds(i==0?&quot;x&quot;:&quot;y&quot;).max &gt; s._axisBounds(i==0?&quot;x&quot;:&quot;y&quot;).max ? myChart.series[0]._axisBounds(i==0?&quot;x&quot;:&quot;y&quot;).max : s._axisBounds(i==0?&quot;x&quot;:&quot;y&quot;).max;
      }
      myChart.axes[i]._update();
    }
    */
    
    return s;
  };
  
  buildSeries(opts, false);
  if (opts.layers.length &gt; 0) {
    opts.layers.forEach(function(layer){
      buildSeries(layer, true);
    })
  }
  //unsure if this is best but if legend is provided (not empty) then evaluate
  if(d3.keys(opts.legend).length &gt; 0) {
    var l =myChart.addLegend();
    d3.keys(opts.legend).forEach(function(d){
      l[d] = opts.legend[d];
    });
  }
  //quick way to get this going but need to make this cleaner
  if(opts.storyboard) {
    myChart.setStoryboard(opts.storyboard);
  };
  myChart.draw();

&lt;/script&gt;
    
    &lt;script&gt;&lt;/script&gt;    
  &lt;/body&gt;
&lt;/html&gt;
' scrolling='no' seamless class='rChart 
dimple
 ' height = 
800px
 ' width = 
550px
id='iframe-chart2c2c33ea8ac'>
</iframe>


<h4>With Some Javascript Adjustments</h4>
Let's transform this simple line with some javascript.  I'll incorporate this [nice labelling example](http://bl.ocks.org/syntagmatic/4053096) to help us label our y axis.


```r
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
d1$show("iframesrc")
```

<iframe srcdoc='
&lt;!doctype HTML&gt;
&lt;meta charset = &#039;utf-8&#039;&gt;
&lt;html&gt;
  &lt;head&gt;
    
    &lt;script src=&#039;C:/Program Files/R/R-3.0.2/library/rCharts/libraries/dimple/js/dimple.v1.1.5.js&#039; type=&#039;text/javascript&#039;&gt;&lt;/script&gt;
    &lt;script src=&#039;C:/Program Files/R/R-3.0.2/library/rCharts/libraries/dimple/js/d3.v3.js&#039; type=&#039;text/javascript&#039;&gt;&lt;/script&gt;
    &lt;script src=&#039;C:/Program Files/R/R-3.0.2/library/rCharts/libraries/dimple/js/d3-grid.js&#039; type=&#039;text/javascript&#039;&gt;&lt;/script&gt;
    
    &lt;style&gt;
    .rChart {
      display: block;
      margin-left: auto; 
      margin-right: auto;
      width: 550px;
      height: 800px;
    }  
    &lt;/style&gt;
    
  &lt;/head&gt;
  &lt;body &gt;
    
    &lt;div id = &#039;chart2c2c33ea8ac&#039; class = &#039;rChart dimple&#039;&gt;&lt;/div&gt;    
    &lt;script type=&quot;text/javascript&quot;&gt;
  var opts = {
 &quot;dom&quot;: &quot;chart2c2c33ea8ac&quot;,
&quot;width&quot;:    550,
&quot;height&quot;:    800,
&quot;xAxis&quot;: {
 &quot;type&quot;: &quot;addCategoryAxis&quot;,
&quot;showPercent&quot;: false 
},
&quot;yAxis&quot;: {
 &quot;type&quot;: &quot;addMeasureAxis&quot;,
&quot;showPercent&quot;: false 
},
&quot;zAxis&quot;: [],
&quot;colorAxis&quot;: [],
&quot;defaultColors&quot;: [],
&quot;layers&quot;: [],
&quot;legend&quot;: [],
&quot;x&quot;: &quot;year&quot;,
&quot;y&quot;: &quot;value&quot;,
&quot;groups&quot;: &quot;group&quot;,
&quot;type&quot;: &quot;line&quot;,
&quot;bounds&quot;: {
 &quot;x&quot;:    200,
&quot;y&quot;:     30,
&quot;height&quot;:    700,
&quot;width&quot;:    300 
},
&quot;id&quot;: &quot;chart2c2c33ea8ac&quot; 
},
    data = [{&quot;group&quot;:&quot;Oral cavity&quot;,&quot;year&quot;:5,&quot;value&quot;:56.7},{&quot;group&quot;:&quot;Oesophagus&quot;,&quot;year&quot;:5,&quot;value&quot;:14.2},{&quot;group&quot;:&quot;Stomach&quot;,&quot;year&quot;:5,&quot;value&quot;:23.8},{&quot;group&quot;:&quot;Colon&quot;,&quot;year&quot;:5,&quot;value&quot;:61.7},{&quot;group&quot;:&quot;Rectum&quot;,&quot;year&quot;:5,&quot;value&quot;:62.6},{&quot;group&quot;:&quot;Liver and intrahepatic bile duct&quot;,&quot;year&quot;:5,&quot;value&quot;:7.5},{&quot;group&quot;:&quot;Pancreas&quot;,&quot;year&quot;:5,&quot;value&quot;:4},{&quot;group&quot;:&quot;Larynx&quot;,&quot;year&quot;:5,&quot;value&quot;:68.8},{&quot;group&quot;:&quot;Lung and bronchus&quot;,&quot;year&quot;:5,&quot;value&quot;:15},{&quot;group&quot;:&quot;Melanomas&quot;,&quot;year&quot;:5,&quot;value&quot;:89},{&quot;group&quot;:&quot;Breast&quot;,&quot;year&quot;:5,&quot;value&quot;:86.4},{&quot;group&quot;:&quot;Cervix uteri&quot;,&quot;year&quot;:5,&quot;value&quot;:70.5},{&quot;group&quot;:&quot;Corpus uteri and uterus&quot;,&quot;year&quot;:5,&quot;value&quot;:84.3},{&quot;group&quot;:&quot;Ovary&quot;,&quot;year&quot;:5,&quot;value&quot;:55},{&quot;group&quot;:&quot;Prostate&quot;,&quot;year&quot;:5,&quot;value&quot;:98.8},{&quot;group&quot;:&quot;Testis&quot;,&quot;year&quot;:5,&quot;value&quot;:94.7},{&quot;group&quot;:&quot;Urinary bladder&quot;,&quot;year&quot;:5,&quot;value&quot;:82.1},{&quot;group&quot;:&quot;Kidney and renal pelvis&quot;,&quot;year&quot;:5,&quot;value&quot;:61.8},{&quot;group&quot;:&quot;Brain and other nervous system&quot;,&quot;year&quot;:5,&quot;value&quot;:32},{&quot;group&quot;:&quot;Thyroid&quot;,&quot;year&quot;:5,&quot;value&quot;:96},{&quot;group&quot;:&quot;Hodgkin&#039;s disease&quot;,&quot;year&quot;:5,&quot;value&quot;:85.1},{&quot;group&quot;:&quot;Non-Hodgkin lymphomas&quot;,&quot;year&quot;:5,&quot;value&quot;:57.8},{&quot;group&quot;:&quot;Multiple myeloma&quot;,&quot;year&quot;:5,&quot;value&quot;:29.5},{&quot;group&quot;:&quot;Leukaemias&quot;,&quot;year&quot;:5,&quot;value&quot;:42.5},{&quot;group&quot;:&quot;Oral cavity&quot;,&quot;year&quot;:10,&quot;value&quot;:44.2},{&quot;group&quot;:&quot;Oesophagus&quot;,&quot;year&quot;:10,&quot;value&quot;:7.9},{&quot;group&quot;:&quot;Stomach&quot;,&quot;year&quot;:10,&quot;value&quot;:19.4},{&quot;group&quot;:&quot;Colon&quot;,&quot;year&quot;:10,&quot;value&quot;:55.4},{&quot;group&quot;:&quot;Rectum&quot;,&quot;year&quot;:10,&quot;value&quot;:55.2},{&quot;group&quot;:&quot;Liver and intrahepatic bile duct&quot;,&quot;year&quot;:10,&quot;value&quot;:5.8},{&quot;group&quot;:&quot;Pancreas&quot;,&quot;year&quot;:10,&quot;value&quot;:3},{&quot;group&quot;:&quot;Larynx&quot;,&quot;year&quot;:10,&quot;value&quot;:56.7},{&quot;group&quot;:&quot;Lung and bronchus&quot;,&quot;year&quot;:10,&quot;value&quot;:10.6},{&quot;group&quot;:&quot;Melanomas&quot;,&quot;year&quot;:10,&quot;value&quot;:86.7},{&quot;group&quot;:&quot;Breast&quot;,&quot;year&quot;:10,&quot;value&quot;:78.3},{&quot;group&quot;:&quot;Cervix uteri&quot;,&quot;year&quot;:10,&quot;value&quot;:64.1},{&quot;group&quot;:&quot;Corpus uteri and uterus&quot;,&quot;year&quot;:10,&quot;value&quot;:83.2},{&quot;group&quot;:&quot;Ovary&quot;,&quot;year&quot;:10,&quot;value&quot;:49.3},{&quot;group&quot;:&quot;Prostate&quot;,&quot;year&quot;:10,&quot;value&quot;:95.2},{&quot;group&quot;:&quot;Testis&quot;,&quot;year&quot;:10,&quot;value&quot;:94},{&quot;group&quot;:&quot;Urinary bladder&quot;,&quot;year&quot;:10,&quot;value&quot;:76.2},{&quot;group&quot;:&quot;Kidney and renal pelvis&quot;,&quot;year&quot;:10,&quot;value&quot;:54.4},{&quot;group&quot;:&quot;Brain and other nervous system&quot;,&quot;year&quot;:10,&quot;value&quot;:29.2},{&quot;group&quot;:&quot;Thyroid&quot;,&quot;year&quot;:10,&quot;value&quot;:95.8},{&quot;group&quot;:&quot;Hodgkin&#039;s disease&quot;,&quot;year&quot;:10,&quot;value&quot;:79.8},{&quot;group&quot;:&quot;Non-Hodgkin lymphomas&quot;,&quot;year&quot;:10,&quot;value&quot;:46.3},{&quot;group&quot;:&quot;Multiple myeloma&quot;,&quot;year&quot;:10,&quot;value&quot;:12.7},{&quot;group&quot;:&quot;Leukaemias&quot;,&quot;year&quot;:10,&quot;value&quot;:32.4},{&quot;group&quot;:&quot;Oral cavity&quot;,&quot;year&quot;:15,&quot;value&quot;:37.5},{&quot;group&quot;:&quot;Oesophagus&quot;,&quot;year&quot;:15,&quot;value&quot;:7.7},{&quot;group&quot;:&quot;Stomach&quot;,&quot;year&quot;:15,&quot;value&quot;:19},{&quot;group&quot;:&quot;Colon&quot;,&quot;year&quot;:15,&quot;value&quot;:53.9},{&quot;group&quot;:&quot;Rectum&quot;,&quot;year&quot;:15,&quot;value&quot;:51.8},{&quot;group&quot;:&quot;Liver and intrahepatic bile duct&quot;,&quot;year&quot;:15,&quot;value&quot;:6.3},{&quot;group&quot;:&quot;Pancreas&quot;,&quot;year&quot;:15,&quot;value&quot;:2.7},{&quot;group&quot;:&quot;Larynx&quot;,&quot;year&quot;:15,&quot;value&quot;:45.8},{&quot;group&quot;:&quot;Lung and bronchus&quot;,&quot;year&quot;:15,&quot;value&quot;:8.1},{&quot;group&quot;:&quot;Melanomas&quot;,&quot;year&quot;:15,&quot;value&quot;:83.5},{&quot;group&quot;:&quot;Breast&quot;,&quot;year&quot;:15,&quot;value&quot;:71.3},{&quot;group&quot;:&quot;Cervix uteri&quot;,&quot;year&quot;:15,&quot;value&quot;:62.8},{&quot;group&quot;:&quot;Corpus uteri and uterus&quot;,&quot;year&quot;:15,&quot;value&quot;:80.8},{&quot;group&quot;:&quot;Ovary&quot;,&quot;year&quot;:15,&quot;value&quot;:49.9},{&quot;group&quot;:&quot;Prostate&quot;,&quot;year&quot;:15,&quot;value&quot;:87.1},{&quot;group&quot;:&quot;Testis&quot;,&quot;year&quot;:15,&quot;value&quot;:91.1},{&quot;group&quot;:&quot;Urinary bladder&quot;,&quot;year&quot;:15,&quot;value&quot;:70.3},{&quot;group&quot;:&quot;Kidney and renal pelvis&quot;,&quot;year&quot;:15,&quot;value&quot;:49.8},{&quot;group&quot;:&quot;Brain and other nervous system&quot;,&quot;year&quot;:15,&quot;value&quot;:27.6},{&quot;group&quot;:&quot;Thyroid&quot;,&quot;year&quot;:15,&quot;value&quot;:94},{&quot;group&quot;:&quot;Hodgkin&#039;s disease&quot;,&quot;year&quot;:15,&quot;value&quot;:73.8},{&quot;group&quot;:&quot;Non-Hodgkin lymphomas&quot;,&quot;year&quot;:15,&quot;value&quot;:38.3},{&quot;group&quot;:&quot;Multiple myeloma&quot;,&quot;year&quot;:15,&quot;value&quot;:7},{&quot;group&quot;:&quot;Leukaemias&quot;,&quot;year&quot;:15,&quot;value&quot;:29.7},{&quot;group&quot;:&quot;Oral cavity&quot;,&quot;year&quot;:20,&quot;value&quot;:33},{&quot;group&quot;:&quot;Oesophagus&quot;,&quot;year&quot;:20,&quot;value&quot;:5.4},{&quot;group&quot;:&quot;Stomach&quot;,&quot;year&quot;:20,&quot;value&quot;:14.9},{&quot;group&quot;:&quot;Colon&quot;,&quot;year&quot;:20,&quot;value&quot;:52.3},{&quot;group&quot;:&quot;Rectum&quot;,&quot;year&quot;:20,&quot;value&quot;:49.2},{&quot;group&quot;:&quot;Liver and intrahepatic bile duct&quot;,&quot;year&quot;:20,&quot;value&quot;:7.6},{&quot;group&quot;:&quot;Pancreas&quot;,&quot;year&quot;:20,&quot;value&quot;:2.7},{&quot;group&quot;:&quot;Larynx&quot;,&quot;year&quot;:20,&quot;value&quot;:37.8},{&quot;group&quot;:&quot;Lung and bronchus&quot;,&quot;year&quot;:20,&quot;value&quot;:6.5},{&quot;group&quot;:&quot;Melanomas&quot;,&quot;year&quot;:20,&quot;value&quot;:82.8},{&quot;group&quot;:&quot;Breast&quot;,&quot;year&quot;:20,&quot;value&quot;:65},{&quot;group&quot;:&quot;Cervix uteri&quot;,&quot;year&quot;:20,&quot;value&quot;:60},{&quot;group&quot;:&quot;Corpus uteri and uterus&quot;,&quot;year&quot;:20,&quot;value&quot;:79.2},{&quot;group&quot;:&quot;Ovary&quot;,&quot;year&quot;:20,&quot;value&quot;:49.6},{&quot;group&quot;:&quot;Prostate&quot;,&quot;year&quot;:20,&quot;value&quot;:81.1},{&quot;group&quot;:&quot;Testis&quot;,&quot;year&quot;:20,&quot;value&quot;:88.2},{&quot;group&quot;:&quot;Urinary bladder&quot;,&quot;year&quot;:20,&quot;value&quot;:67.9},{&quot;group&quot;:&quot;Kidney and renal pelvis&quot;,&quot;year&quot;:20,&quot;value&quot;:47.3},{&quot;group&quot;:&quot;Brain and other nervous system&quot;,&quot;year&quot;:20,&quot;value&quot;:26.1},{&quot;group&quot;:&quot;Thyroid&quot;,&quot;year&quot;:20,&quot;value&quot;:95.4},{&quot;group&quot;:&quot;Hodgkin&#039;s disease&quot;,&quot;year&quot;:20,&quot;value&quot;:67.1},{&quot;group&quot;:&quot;Non-Hodgkin lymphomas&quot;,&quot;year&quot;:20,&quot;value&quot;:34.3},{&quot;group&quot;:&quot;Multiple myeloma&quot;,&quot;year&quot;:20,&quot;value&quot;:4.8},{&quot;group&quot;:&quot;Leukaemias&quot;,&quot;year&quot;:20,&quot;value&quot;:26.2}];
  var svg = dimple.newSvg(&quot;#&quot; + opts.id, opts.width, opts.height);

  //data = dimple.filterData(data, &quot;Owner&quot;, [&quot;Aperture&quot;, &quot;Black Mesa&quot;])
  var myChart = new dimple.chart(svg, data);
  if (opts.bounds) {
    myChart.setBounds(opts.bounds.x, opts.bounds.y, opts.bounds.width, opts.bounds.height);//myChart.setBounds(80, 30, 480, 330);
  }
  //dimple allows use of custom CSS with noFormats
  if(opts.noFormats) { myChart.noFormats = opts.noFormats; };
  //for markimekko and addAxis also have third parameter measure
  //so need to evaluate if measure provided
  
  //function to build axes
  function buildAxis(position,layer){
    var axis;
    var axisopts = opts[position+&quot;Axis&quot;];
    
    if(axisopts.measure) {
      axis = myChart[axisopts.type](position,layer[position],axisopts.measure);
    } else {
      axis = myChart[axisopts.type](position, layer[position]);
    };
    if(!(axisopts.type === &quot;addPctAxis&quot;)) axis.showPercent = axisopts.showPercent;
    if (axisopts.orderRule) axis.addOrderRule(axisopts.orderRule);
    if (axisopts.grouporderRule) axis.addGroupOrderRule(axisopts.grouporderRule);  
    if (axisopts.overrideMin) axis.overrideMin = axisopts.overrideMin;
    if (axisopts.overrideMax) axis.overrideMax = axisopts.overrideMax;
    if (axisopts.overrideMax) axis.overrideMax = axisopts.overrideMax;
    if (axisopts.inputFormat) axis.dateParseFormat = axisopts.inputFormat;
    if (axisopts.outputFormat) axis.tickFormat = axisopts.outputFormat;    
    return axis;
  };
  
  var c = null;
  if(d3.keys(opts.colorAxis).length &gt; 0) {
    c = myChart[opts.colorAxis.type](opts.colorAxis.colorSeries,opts.colorAxis.palette) ;
  }
  
  //allow manipulation of default colors to use with dimple
  if(opts.defaultColors.length) {
    opts.defaultColors = opts.defaultColors[0];
    if (typeof(opts.defaultColors) == &quot;function&quot;) {
      //assume this is a d3 scale
      //for now loop through first 20 but need a better way to handle
      defaultColorsArray = [];
      for (var n=0;n&lt;20;n++) {
        defaultColorsArray.push(opts.defaultColors(n));
      };
      opts.defaultColors = defaultColorsArray;
    }
    opts.defaultColors.forEach(function(d,i) {
      opts.defaultColors[i] = new dimple.color(d);
    })
    myChart.defaultColors = opts.defaultColors;
  }  
  
  //do series
  //set up a function since same for each
  //as of now we have x,y,groups,data,type in opts for primary layer
  //and other layers reside in opts.layers
  function buildSeries(layer, hidden){
    //inherit from primary layer if not intentionally changed or xAxis, yAxis, zAxis null
    if (!layer.xAxis) layer.xAxis = opts.xAxis;    
    if (!layer.yAxis) layer.yAxis = opts.yAxis;
    if (!layer.zAxis) layer.zAxis = opts.zAxis;
    
    var x = buildAxis(&quot;x&quot;, layer);
    x.hidden = hidden;
    
    var y = buildAxis(&quot;y&quot;, layer);
    y.hidden = hidden;
    
    //z for bubbles
    var z = null;
    if (!(typeof(layer.zAxis) === &#039;undefined&#039;) &amp;&amp; layer.zAxis.type){
      z = buildAxis(&quot;z&quot;, layer);
    };
    
    //here think I need to evaluate group and if missing do null
    //as the group argument
    //if provided need to use groups from layer
    var s = new dimple.series(myChart, null, x, y, z, c, dimple.plot[layer.type], dimple.aggregateMethod.avg, dimple.plot[layer.type].stacked);
    
    //as of v1.1.4 dimple can use different dataset for each series
    if(layer.data){
      //convert to an array of objects
      var tempdata;
      //avoid lodash for now
      datakeys = d3.keys(layer.data)
      tempdata = layer.data[datakeys[1]].map(function(d,i){
        var tempobj = {}
        datakeys.forEach(function(key){
          tempobj[key] = layer.data[key][i]
        })
        return tempobj
      })
      s.data = tempdata;
    }
    
    if(layer.hasOwnProperty(&quot;groups&quot;)) {
      s.categoryFields = (typeof layer.groups === &quot;object&quot;) ? layer.groups : [layer.groups];
      //series offers an aggregate method that we will also need to check if available
      //options available are avg, count, max, min, sum
      if (!(typeof(layer.aggregate) === &#039;undefined&#039;)) {
        s.aggregate = eval(layer.aggregate);
      }
      if (!(typeof(layer.lineWeight) === &#039;undefined&#039;)) {
        s.lineWeight = eval(layer.lineWeight);
      }
      if (!(typeof(layer.barGap) === &#039;undefined&#039;)) {
        s.barGap = eval(layer.barGap);
      }    
    };    
   /* if (!(typeof(layer.eventHandler) === &#039;undefined&#039;)) {
      layer.eventHandler = (layer.eventHandler.length === &quot;undefined&quot;) ? layer.eventHandler : [layer.eventHandler];
      layer.eventHandler.forEach(function(evt){
        s.addEventHandler(evt.event, eval(evt.handler))
      })
    }*/
      
    myChart.series.push(s);
    
    /*placeholder fix domain of primary scale for new series data
    //not working right now but something like this
    //for now just use overrideMin and overrideMax from rCharts
    for( var i = 0; i&lt;2; i++) {
      if (!myChart.axes[i].overrideMin) {
        myChart.series[0]._axisBounds(i==0?&quot;x&quot;:&quot;y&quot;).min = myChart.series[0]._axisBounds(i==0?&quot;x&quot;:&quot;y&quot;).min &lt; s._axisBounds(i==0?&quot;x&quot;:&quot;y&quot;).min ? myChart.series[0]._axisBounds(i==0?&quot;x&quot;:&quot;y&quot;).min : s._axisBounds(i==0?&quot;x&quot;:&quot;y&quot;).min;
      }
      if (!myChart.axes[i].overrideMax) {  
        myChart.series[0]._axisBounds(i==0?&quot;x&quot;:&quot;y&quot;)._max = myChart.series[0]._axisBounds(i==0?&quot;x&quot;:&quot;y&quot;).max &gt; s._axisBounds(i==0?&quot;x&quot;:&quot;y&quot;).max ? myChart.series[0]._axisBounds(i==0?&quot;x&quot;:&quot;y&quot;).max : s._axisBounds(i==0?&quot;x&quot;:&quot;y&quot;).max;
      }
      myChart.axes[i]._update();
    }
    */
    
    return s;
  };
  
  buildSeries(opts, false);
  if (opts.layers.length &gt; 0) {
    opts.layers.forEach(function(layer){
      buildSeries(layer, true);
    })
  }
  //unsure if this is best but if legend is provided (not empty) then evaluate
  if(d3.keys(opts.legend).length &gt; 0) {
    var l =myChart.addLegend();
    d3.keys(opts.legend).forEach(function(d){
      l[d] = opts.legend[d];
    });
  }
  //quick way to get this going but need to make this cleaner
  if(opts.storyboard) {
    myChart.setStoryboard(opts.storyboard);
  };
  myChart.draw();

&lt;/script&gt;
    
    
    &lt;script&gt;
      //axes adjustments for slopegraph
      
      //based on template myChart.axes[2] should be y
      //but just to make sure do map
      var ySlope = myChart.axes.filter(function(axis){return axis.position===&#039;y&#039;})[0];
      var xSlope = myChart.axes.filter(function(axis){return axis.position===&#039;x&#039;})[0]
      
      //remove axis labels if desired
      ySlope.shapes.remove();
      //remove gridlines
      ySlope.gridlineShapes.remove();
      //remove axis title
      ySlope.titleShape.remove();
      
      var slopelabels = d3.select(&#039;#&#039;+opts.id).select(&#039;svg&#039;).select(&#039;g&#039;).append(&#039;g&#039;)
       .attr(&#039;class&#039;,&#039;slopelabels&#039;)
      
      //get unique values for groups in data
      //note will only work with one group level
      var firstPoints = data.filter(function(d){
        return d[opts.x] == myChart.axes[0]._draw.scale().domain()[0];
      });
      
      slopelabels.selectAll(&#039;text&#039;)
        .data(firstPoints)
        .enter()
        .append(&#039;text&#039;)
        .attr(&#039;class&#039;,&#039;labels&#039;)
        //.attr(&#039;x&#039;, function(d){
        //  return xSlope._scale(d[opts.x])
        //})
        .attr(&#039;x&#039;,d3.select(&#039;.axis&#039;).select(&#039;.tick text&#039;).attr(&#039;x&#039;) - 20)
        .attr(&#039;y&#039;, function(d){
          return ySlope._scale(d[opts.y])
        })
        .attr(&#039;dy&#039;,&#039;0.2em&#039;)
        .attr(&#039;transform&#039;,d3.select(&#039;.axis&#039;).select(&#039;.tick&#039;).attr(&#039;transform&#039;))
        .attr(&#039;fill&#039;,function(d)  {
          return myChart._assignedColors[d[opts.groups]].fill
        })
        //.attr(&#039;stroke&#039;,function(d){return myChart._assignedColors[d[opts.groups]].stroke})
        .attr(&#039;opacity&#039;,function(d){return myChart._assignedColors[d[opts.groups]].opacity})
        .style(&#039;text-anchor&#039;,&#039;end&#039;)
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
              if (Math.abs(dy) &lt; spacing) {
                again = true;
                var sign = dy &gt; 0 ? 1 : -1;
                a.y += sign*alpha;
                b.y -= sign*alpha;
              }
            });
          });
          d3.selectAll(&#039;.labels&#039;)
            .attr(&#039;y&#039;, function(d) {
            return d.y;
          });
          if (again) setTimeout(relax,20);
        };
        
        relax();  
        
        
        //add numbers to each point
        var pointtext = d3.select(&#039;#&#039;+opts.id).select(&#039;svg&#039;).select(&#039;g&#039;).append(&#039;g&#039;)
          .attr(&#039;class&#039;,&#039;pointtext&#039;)
        pointtext.selectAll(&#039;text&#039;)
          .data(data)
          .enter()
          .append(&#039;g&#039;)
          .attr(&#039;transform&#039;,function(d){
            return d3.select(d3.select(&#039;.axis&#039;).selectAll(&#039;.tick&#039;)[0].filter(function(dd){
              return d3.select(dd).datum() == d[opts.x]
            })[0]).attr(&#039;transform&#039;)
          })
          .append(&#039;text&#039;)
          .attr(&#039;x&#039;,function(d){
            return d3.select(&#039;.axis&#039;).select(&#039;.tick text&#039;).attr(&#039;x&#039;)
          })
          .attr(&#039;y&#039;,function(d){
            return ySlope._scale(d[opts.y])})
          .attr(&#039;dy&#039;,&#039;0.2em&#039;)
          //.attr(&#039;fill&#039;,function(d){return myChart._assignedColors[d[opts.groups]].fill})
          //.attr(&#039;stroke&#039;,function(d){return myChart._assignedColors[d[opts.groups]].stroke})
          //.attr(&#039;opacity&#039;,function(d){return myChart._assignedColors[d[opts.groups]].opacity})
          .attr(&#039;text-anchor&#039;,&#039;middle&#039;)
          .style(&#039;font-size&#039;,&#039;12&#039;)
          .style(&#039;pointer-events&#039;,&#039;none&#039;)
          .text(function(d){
            return d[opts.y]
          })
    &lt;/script&gt;    
  &lt;/body&gt;
&lt;/html&gt;
' scrolling='no' seamless class='rChart 
dimple
 ' height = 
800px
 ' width = 
550px
id='iframe-chart2c2c33ea8ac'>
</iframe>

