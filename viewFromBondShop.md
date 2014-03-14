---
title: View From a Bond Shop
author: Timely Portfolio
github: {user: timelyportfolio, repo: rCharts_dimple, branch: "gh-pages"}
framework: bootplus
layout: post
mode: selfcontained
highlighter: prettify
hitheme: twitter-bootstrap
lead : >
  Iterate Through a Chart with rCharts and dimplejs
assets:
  jshead:
    - http://d3js.org/d3.v3.min.js
    - http://dimplejs.org/dist/dimple.v1.1.5.min.js
  css:
    - "http://fonts.googleapis.com/css?family=Raleway:300"
    - "http://fonts.googleapis.com/css?family=Oxygen"    
---

# Not a Designer but I Do Know rCharts ...

<style>
body{
  font-family: 'Oxygen', sans-serif;
  font-size: 15px;
  line-height: 22px;
}

h1,h2,h3,h4 {
  font-family: 'Raleway', sans-serif;
}

.tooltip{
  opacity:1 !important
}
</style>




Yesterday I saw this chart (<strong>these are not my views</strong>) in a presentation by an undisclosed fixed income shop (unless they tell me they want me to disclose their identity).  Likely due to my immersion in `d3` and `rCharts` I paid no attention to the content and my mind went immediately to<br>

<blockquote>
Could this be better designed?    
</blockquote>

... and soon after ...

<blockquote>
Could I do it with <code>rCharts</code> and <code>dimplejs</code>?    
</blockquote>
![original graphic](assets/fig/originalview.jpg)
<em style="font-size:10px;">source: not me</em>

---
### Little Data <- Manual Input
Since the data is a summary view, manually inputting it into a `data.frame` is really easy.  We'll name it `views` and express our view with a scale 1 (don't like) to 6 (really like).


```r
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
```


---
### And the Iteration Begins
The beauty of rCharts is that we do not have to break our workflow as we explore and iterate.  Often the hardest part of iteration is finding a starting point when we are staring at a blank page or canvas.  I overcome this by just doing something and expecting it to be bad.


```r
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
dP$show(chartId = "example1")
```


<div id = 'example1' class = 'rChart dimple'></div>
<script type="text/javascript">
  var opts = {
 "dom": "example1",
"width":    600,
"height":    600,
"xAxis": {
 "type": "addMeasureAxis",
"showPercent": false 
},
"yAxis": {
 "type": "addCategoryAxis",
"showPercent": false 
},
"zAxis": [],
"colorAxis": [],
"defaultColors": [],
"layers": [],
"legend": [],
"x": "View",
"y": "Asset",
"type": "bar",
"bounds": {
 "x":    240,
"y":     50,
"width":    360,
"height":    500 
},
"id": "example1" 
},
    data = [{"Asset":"U.S. Treasuries","View":3},{"Asset":"Curve Positions","View":6},{"Asset":"Non US Developed","View":3},{"Asset":"Emerging Markets","View":2},{"Asset":"Mortgage-Backed Securities","View":4},{"Asset":"Investment Grade Credit","View":3},{"Asset":"High Yield","View":3},{"Asset":"Municipals","View":4},{"Asset":"Currency","View":2}];
  var svg = dimple.newSvg("#" + opts.id, opts.width, opts.height);

  //data = dimple.filterData(data, "Owner", ["Aperture", "Black Mesa"])
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
    var axisopts = opts[position+"Axis"];
    
    if(axisopts.measure) {
      axis = myChart[axisopts.type](position,layer[position],axisopts.measure);
    } else {
      axis = myChart[axisopts.type](position, layer[position]);
    };
    if(!(axisopts.type === "addPctAxis")) axis.showPercent = axisopts.showPercent;
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
  if(d3.keys(opts.colorAxis).length > 0) {
    c = myChart[opts.colorAxis.type](opts.colorAxis.colorSeries,opts.colorAxis.palette) ;
  }
  
  //allow manipulation of default colors to use with dimple
  if(opts.defaultColors.length) {
    opts.defaultColors = opts.defaultColors[0];
    if (typeof(opts.defaultColors) == "function") {
      //assume this is a d3 scale
      //for now loop through first 20 but need a better way to handle
      defaultColorsArray = [];
      for (var n=0;n<20;n++) {
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
    var x = buildAxis("x", layer);
    x.hidden = hidden;
    
    var y = buildAxis("y", layer);
    y.hidden = hidden;
    
    //z for bubbles
    var z = null;
    if (!(typeof(layer.zAxis) === 'undefined') && layer.zAxis.type){
      z = buildAxis("z", layer);
    };
    
    //here think I need to evaluate group and if missing do null
    //as the group argument
    //if provided need to use groups from layer
    var s = new dimple.series(myChart, null, x, y, z, c, dimple.plot[layer.type], dimple.aggregateMethod.avg, dimple.plot[layer.type].stacked);
    
    if(layer.hasOwnProperty("groups")) {
      s.categoryFields = (typeof layer.groups === "object") ? layer.groups : [layer.groups]; 
    };
    
    //series offers an aggregate method that we will also need to check if available
    //options available are avg, count, max, min, sum
    if (!(typeof(layer.aggregate) === 'undefined')) {
      s.aggregate = eval(layer.aggregate);
    }
    if (!(typeof(layer.lineWeight) === 'undefined')) {
      s.lineWeight = eval(layer.lineWeight);
    }
    if (!(typeof(layer.barGap) === 'undefined')) {
      s.barGap = eval(layer.barGap);
    }
    
   /* if (!(typeof(layer.eventHandler) === 'undefined')) {
      layer.eventHandler = (layer.eventHandler.length === "undefined") ? layer.eventHandler : [layer.eventHandler];
      layer.eventHandler.forEach(function(evt){
        s.addEventHandler(evt.event, eval(evt.handler))
      })
    }*/
      
    myChart.series.push(s);
    return s;
  };
  
  buildSeries(opts, false);
  if (opts.layers.length > 0) {
    opts.layers.forEach(function(layer){
      buildSeries(layer, true);
    })
  }
  //unsure if this is best but if legend is provided (not empty) then evaluate
  if(d3.keys(opts.legend).length > 0) {
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

</script>


<div id = "example1"></div>

---
### Add Some Color
Some color might help.  `dimplejs` makes a color scale easy.  Although there is `colorbrewer.js`, we can avoid a js dependency and plug in `RColorBrewer` colors from `R`.  With a couple lines of new code we can get a heat map type color scheme with red, yellow, and green.  Sorry to the color blind readers, but I thought I would try to match the color scheme from the original.


```r
#need some color
dP$colorAxis(
  type = "addColorAxis",
  colorSeries = "View",
  palette = RColorBrewer::brewer.pal(n=5,"RdYlGn") 
)
dP$show(chartId = "example2")
```


<div id = 'example2' class = 'rChart dimple'></div>
<script type="text/javascript">
  var opts = {
 "dom": "example2",
"width":    600,
"height":    600,
"xAxis": {
 "type": "addMeasureAxis",
"showPercent": false 
},
"yAxis": {
 "type": "addCategoryAxis",
"showPercent": false 
},
"zAxis": [],
"colorAxis": {
 "type": "addColorAxis",
"colorSeries": "View",
"palette": [ "#D7191C", "#FDAE61", "#FFFFBF", "#A6D96A", "#1A9641" ] 
},
"defaultColors": [],
"layers": [],
"legend": [],
"x": "View",
"y": "Asset",
"type": "bar",
"bounds": {
 "x":    240,
"y":     50,
"width":    360,
"height":    500 
},
"id": "example2" 
},
    data = [{"Asset":"U.S. Treasuries","View":3},{"Asset":"Curve Positions","View":6},{"Asset":"Non US Developed","View":3},{"Asset":"Emerging Markets","View":2},{"Asset":"Mortgage-Backed Securities","View":4},{"Asset":"Investment Grade Credit","View":3},{"Asset":"High Yield","View":3},{"Asset":"Municipals","View":4},{"Asset":"Currency","View":2}];
  var svg = dimple.newSvg("#" + opts.id, opts.width, opts.height);

  //data = dimple.filterData(data, "Owner", ["Aperture", "Black Mesa"])
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
    var axisopts = opts[position+"Axis"];
    
    if(axisopts.measure) {
      axis = myChart[axisopts.type](position,layer[position],axisopts.measure);
    } else {
      axis = myChart[axisopts.type](position, layer[position]);
    };
    if(!(axisopts.type === "addPctAxis")) axis.showPercent = axisopts.showPercent;
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
  if(d3.keys(opts.colorAxis).length > 0) {
    c = myChart[opts.colorAxis.type](opts.colorAxis.colorSeries,opts.colorAxis.palette) ;
  }
  
  //allow manipulation of default colors to use with dimple
  if(opts.defaultColors.length) {
    opts.defaultColors = opts.defaultColors[0];
    if (typeof(opts.defaultColors) == "function") {
      //assume this is a d3 scale
      //for now loop through first 20 but need a better way to handle
      defaultColorsArray = [];
      for (var n=0;n<20;n++) {
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
    var x = buildAxis("x", layer);
    x.hidden = hidden;
    
    var y = buildAxis("y", layer);
    y.hidden = hidden;
    
    //z for bubbles
    var z = null;
    if (!(typeof(layer.zAxis) === 'undefined') && layer.zAxis.type){
      z = buildAxis("z", layer);
    };
    
    //here think I need to evaluate group and if missing do null
    //as the group argument
    //if provided need to use groups from layer
    var s = new dimple.series(myChart, null, x, y, z, c, dimple.plot[layer.type], dimple.aggregateMethod.avg, dimple.plot[layer.type].stacked);
    
    if(layer.hasOwnProperty("groups")) {
      s.categoryFields = (typeof layer.groups === "object") ? layer.groups : [layer.groups]; 
    };
    
    //series offers an aggregate method that we will also need to check if available
    //options available are avg, count, max, min, sum
    if (!(typeof(layer.aggregate) === 'undefined')) {
      s.aggregate = eval(layer.aggregate);
    }
    if (!(typeof(layer.lineWeight) === 'undefined')) {
      s.lineWeight = eval(layer.lineWeight);
    }
    if (!(typeof(layer.barGap) === 'undefined')) {
      s.barGap = eval(layer.barGap);
    }
    
   /* if (!(typeof(layer.eventHandler) === 'undefined')) {
      layer.eventHandler = (layer.eventHandler.length === "undefined") ? layer.eventHandler : [layer.eventHandler];
      layer.eventHandler.forEach(function(evt){
        s.addEventHandler(evt.event, eval(evt.handler))
      })
    }*/
      
    myChart.series.push(s);
    return s;
  };
  
  buildSeries(opts, false);
  if (opts.layers.length > 0) {
    opts.layers.forEach(function(layer){
      buildSeries(layer, true);
    })
  }
  //unsure if this is best but if legend is provided (not empty) then evaluate
  if(d3.keys(opts.legend).length > 0) {
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

</script>


<div id = "example2"></div>

---
### Dimple Calls This a Block Matrix
This `dimplejs` [block matrix example](http://dimplejs.org/examples_viewer.html?id=bars_matrix) might be a better option than a traditional bar chart.  Block matrix charts have two categorical or discrete axes.  Let's make our `xAxis` categorical.


```r
#probably need x to be Category Axis
dP$xAxis( type = "addCategoryAxis" )
dP$show(chartId = "example3")
```


<div id = 'example3' class = 'rChart dimple'></div>
<script type="text/javascript">
  var opts = {
 "dom": "example3",
"width":    600,
"height":    600,
"xAxis": {
 "type": "addCategoryAxis",
"showPercent": false 
},
"yAxis": {
 "type": "addCategoryAxis",
"showPercent": false 
},
"zAxis": [],
"colorAxis": {
 "type": "addColorAxis",
"colorSeries": "View",
"palette": [ "#D7191C", "#FDAE61", "#FFFFBF", "#A6D96A", "#1A9641" ] 
},
"defaultColors": [],
"layers": [],
"legend": [],
"x": "View",
"y": "Asset",
"type": "bar",
"bounds": {
 "x":    240,
"y":     50,
"width":    360,
"height":    500 
},
"id": "example3" 
},
    data = [{"Asset":"U.S. Treasuries","View":3},{"Asset":"Curve Positions","View":6},{"Asset":"Non US Developed","View":3},{"Asset":"Emerging Markets","View":2},{"Asset":"Mortgage-Backed Securities","View":4},{"Asset":"Investment Grade Credit","View":3},{"Asset":"High Yield","View":3},{"Asset":"Municipals","View":4},{"Asset":"Currency","View":2}];
  var svg = dimple.newSvg("#" + opts.id, opts.width, opts.height);

  //data = dimple.filterData(data, "Owner", ["Aperture", "Black Mesa"])
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
    var axisopts = opts[position+"Axis"];
    
    if(axisopts.measure) {
      axis = myChart[axisopts.type](position,layer[position],axisopts.measure);
    } else {
      axis = myChart[axisopts.type](position, layer[position]);
    };
    if(!(axisopts.type === "addPctAxis")) axis.showPercent = axisopts.showPercent;
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
  if(d3.keys(opts.colorAxis).length > 0) {
    c = myChart[opts.colorAxis.type](opts.colorAxis.colorSeries,opts.colorAxis.palette) ;
  }
  
  //allow manipulation of default colors to use with dimple
  if(opts.defaultColors.length) {
    opts.defaultColors = opts.defaultColors[0];
    if (typeof(opts.defaultColors) == "function") {
      //assume this is a d3 scale
      //for now loop through first 20 but need a better way to handle
      defaultColorsArray = [];
      for (var n=0;n<20;n++) {
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
    var x = buildAxis("x", layer);
    x.hidden = hidden;
    
    var y = buildAxis("y", layer);
    y.hidden = hidden;
    
    //z for bubbles
    var z = null;
    if (!(typeof(layer.zAxis) === 'undefined') && layer.zAxis.type){
      z = buildAxis("z", layer);
    };
    
    //here think I need to evaluate group and if missing do null
    //as the group argument
    //if provided need to use groups from layer
    var s = new dimple.series(myChart, null, x, y, z, c, dimple.plot[layer.type], dimple.aggregateMethod.avg, dimple.plot[layer.type].stacked);
    
    if(layer.hasOwnProperty("groups")) {
      s.categoryFields = (typeof layer.groups === "object") ? layer.groups : [layer.groups]; 
    };
    
    //series offers an aggregate method that we will also need to check if available
    //options available are avg, count, max, min, sum
    if (!(typeof(layer.aggregate) === 'undefined')) {
      s.aggregate = eval(layer.aggregate);
    }
    if (!(typeof(layer.lineWeight) === 'undefined')) {
      s.lineWeight = eval(layer.lineWeight);
    }
    if (!(typeof(layer.barGap) === 'undefined')) {
      s.barGap = eval(layer.barGap);
    }
    
   /* if (!(typeof(layer.eventHandler) === 'undefined')) {
      layer.eventHandler = (layer.eventHandler.length === "undefined") ? layer.eventHandler : [layer.eventHandler];
      layer.eventHandler.forEach(function(evt){
        s.addEventHandler(evt.event, eval(evt.handler))
      })
    }*/
      
    myChart.series.push(s);
    return s;
  };
  
  buildSeries(opts, false);
  if (opts.layers.length > 0) {
    opts.layers.forEach(function(layer){
      buildSeries(layer, true);
    })
  }
  //unsure if this is best but if legend is provided (not empty) then evaluate
  if(d3.keys(opts.legend).length > 0) {
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

</script>


<div id = "example3"></div>

---
### Where are 1 and 5?
Now that our `xAxis` is categorical, we lost 1 and 5 since we don't have this view on any of the opportunities.  As of now, I do not think `dimplejs` allows us to manually specify a domain for our categorical axes, but we can fool `dimplejs` by providing a dummy 1 and 5 then deleting it with javascript.


```r
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
  d3.select('#example4').selectAll('#All_1_Currency_,#All_5_Currency_').remove()
</script>
  "
)
dP$show(chartId = "example4")
```


<div id = 'example4' class = 'rChart dimple'></div>
<script type="text/javascript">
  var opts = {
 "dom": "example4",
"width":    600,
"height":    600,
"xAxis": {
 "type": "addCategoryAxis",
"showPercent": false 
},
"yAxis": {
 "type": "addCategoryAxis",
"showPercent": false 
},
"zAxis": [],
"colorAxis": {
 "type": "addColorAxis",
"colorSeries": "View",
"palette": [ "#D7191C", "#FDAE61", "#FFFFBF", "#A6D96A", "#1A9641" ] 
},
"defaultColors": [],
"layers": [],
"legend": [],
"x": "View",
"y": "Asset",
"type": "bar",
"bounds": {
 "x":    240,
"y":     50,
"width":    360,
"height":    500 
},
"id": "example4" 
},
    data = [{"Asset":"U.S. Treasuries","View":3},{"Asset":"Curve Positions","View":6},{"Asset":"Non US Developed","View":3},{"Asset":"Emerging Markets","View":2},{"Asset":"Mortgage-Backed Securities","View":4},{"Asset":"Investment Grade Credit","View":3},{"Asset":"High Yield","View":3},{"Asset":"Municipals","View":4},{"Asset":"Currency","View":2},{"Asset":"Currency","View":1},{"Asset":"Currency","View":5}];
  var svg = dimple.newSvg("#" + opts.id, opts.width, opts.height);

  //data = dimple.filterData(data, "Owner", ["Aperture", "Black Mesa"])
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
    var axisopts = opts[position+"Axis"];
    
    if(axisopts.measure) {
      axis = myChart[axisopts.type](position,layer[position],axisopts.measure);
    } else {
      axis = myChart[axisopts.type](position, layer[position]);
    };
    if(!(axisopts.type === "addPctAxis")) axis.showPercent = axisopts.showPercent;
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
  if(d3.keys(opts.colorAxis).length > 0) {
    c = myChart[opts.colorAxis.type](opts.colorAxis.colorSeries,opts.colorAxis.palette) ;
  }
  
  //allow manipulation of default colors to use with dimple
  if(opts.defaultColors.length) {
    opts.defaultColors = opts.defaultColors[0];
    if (typeof(opts.defaultColors) == "function") {
      //assume this is a d3 scale
      //for now loop through first 20 but need a better way to handle
      defaultColorsArray = [];
      for (var n=0;n<20;n++) {
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
    var x = buildAxis("x", layer);
    x.hidden = hidden;
    
    var y = buildAxis("y", layer);
    y.hidden = hidden;
    
    //z for bubbles
    var z = null;
    if (!(typeof(layer.zAxis) === 'undefined') && layer.zAxis.type){
      z = buildAxis("z", layer);
    };
    
    //here think I need to evaluate group and if missing do null
    //as the group argument
    //if provided need to use groups from layer
    var s = new dimple.series(myChart, null, x, y, z, c, dimple.plot[layer.type], dimple.aggregateMethod.avg, dimple.plot[layer.type].stacked);
    
    if(layer.hasOwnProperty("groups")) {
      s.categoryFields = (typeof layer.groups === "object") ? layer.groups : [layer.groups]; 
    };
    
    //series offers an aggregate method that we will also need to check if available
    //options available are avg, count, max, min, sum
    if (!(typeof(layer.aggregate) === 'undefined')) {
      s.aggregate = eval(layer.aggregate);
    }
    if (!(typeof(layer.lineWeight) === 'undefined')) {
      s.lineWeight = eval(layer.lineWeight);
    }
    if (!(typeof(layer.barGap) === 'undefined')) {
      s.barGap = eval(layer.barGap);
    }
    
   /* if (!(typeof(layer.eventHandler) === 'undefined')) {
      layer.eventHandler = (layer.eventHandler.length === "undefined") ? layer.eventHandler : [layer.eventHandler];
      layer.eventHandler.forEach(function(evt){
        s.addEventHandler(evt.event, eval(evt.handler))
      })
    }*/
      
    myChart.series.push(s);
    return s;
  };
  
  buildSeries(opts, false);
  if (opts.layers.length > 0) {
    opts.layers.forEach(function(layer){
      buildSeries(layer, true);
    })
  }
  //unsure if this is best but if legend is provided (not empty) then evaluate
  if(d3.keys(opts.legend).length > 0) {
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

</script>



<script>
  d3.select('#example4').selectAll('#All_1_Currency_,#All_5_Currency_').remove()
</script>
  


<div id = "example4"></div>


---
### Sort It Out
I did not make the original chart, but I will assume that the ordering of the opportunity set (`yAxis`) was intentional.  `dimplejs` will assume natural sort order or alphabetical for text, but we can manually specify our sort order with a different variable or by providing an array.  The `data.frame` is in the correct order so let's give `dimplejs` that with the following code.


```r
#now our y Axis gets sorted in a way we might not like
dP$yAxis(
  orderRule = rev(views$Asset)
)
dP$show(chartId = "example5")
```


<div id = 'example5' class = 'rChart dimple'></div>
<script type="text/javascript">
  var opts = {
 "dom": "example5",
"width":    600,
"height":    600,
"xAxis": {
 "type": "addCategoryAxis",
"showPercent": false 
},
"yAxis": {
 "type": "addCategoryAxis",
"showPercent": false,
"orderRule": [ "Currency", "Municipals", "High Yield", "Investment Grade Credit", "Mortgage-Backed Securities", "Emerging Markets", "Non US Developed", "Curve Positions", "U.S. Treasuries" ] 
},
"zAxis": [],
"colorAxis": {
 "type": "addColorAxis",
"colorSeries": "View",
"palette": [ "#D7191C", "#FDAE61", "#FFFFBF", "#A6D96A", "#1A9641" ] 
},
"defaultColors": [],
"layers": [],
"legend": [],
"x": "View",
"y": "Asset",
"type": "bar",
"bounds": {
 "x":    240,
"y":     50,
"width":    360,
"height":    500 
},
"id": "example5" 
},
    data = [{"Asset":"U.S. Treasuries","View":3},{"Asset":"Curve Positions","View":6},{"Asset":"Non US Developed","View":3},{"Asset":"Emerging Markets","View":2},{"Asset":"Mortgage-Backed Securities","View":4},{"Asset":"Investment Grade Credit","View":3},{"Asset":"High Yield","View":3},{"Asset":"Municipals","View":4},{"Asset":"Currency","View":2},{"Asset":"Currency","View":1},{"Asset":"Currency","View":5}];
  var svg = dimple.newSvg("#" + opts.id, opts.width, opts.height);

  //data = dimple.filterData(data, "Owner", ["Aperture", "Black Mesa"])
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
    var axisopts = opts[position+"Axis"];
    
    if(axisopts.measure) {
      axis = myChart[axisopts.type](position,layer[position],axisopts.measure);
    } else {
      axis = myChart[axisopts.type](position, layer[position]);
    };
    if(!(axisopts.type === "addPctAxis")) axis.showPercent = axisopts.showPercent;
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
  if(d3.keys(opts.colorAxis).length > 0) {
    c = myChart[opts.colorAxis.type](opts.colorAxis.colorSeries,opts.colorAxis.palette) ;
  }
  
  //allow manipulation of default colors to use with dimple
  if(opts.defaultColors.length) {
    opts.defaultColors = opts.defaultColors[0];
    if (typeof(opts.defaultColors) == "function") {
      //assume this is a d3 scale
      //for now loop through first 20 but need a better way to handle
      defaultColorsArray = [];
      for (var n=0;n<20;n++) {
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
    var x = buildAxis("x", layer);
    x.hidden = hidden;
    
    var y = buildAxis("y", layer);
    y.hidden = hidden;
    
    //z for bubbles
    var z = null;
    if (!(typeof(layer.zAxis) === 'undefined') && layer.zAxis.type){
      z = buildAxis("z", layer);
    };
    
    //here think I need to evaluate group and if missing do null
    //as the group argument
    //if provided need to use groups from layer
    var s = new dimple.series(myChart, null, x, y, z, c, dimple.plot[layer.type], dimple.aggregateMethod.avg, dimple.plot[layer.type].stacked);
    
    if(layer.hasOwnProperty("groups")) {
      s.categoryFields = (typeof layer.groups === "object") ? layer.groups : [layer.groups]; 
    };
    
    //series offers an aggregate method that we will also need to check if available
    //options available are avg, count, max, min, sum
    if (!(typeof(layer.aggregate) === 'undefined')) {
      s.aggregate = eval(layer.aggregate);
    }
    if (!(typeof(layer.lineWeight) === 'undefined')) {
      s.lineWeight = eval(layer.lineWeight);
    }
    if (!(typeof(layer.barGap) === 'undefined')) {
      s.barGap = eval(layer.barGap);
    }
    
   /* if (!(typeof(layer.eventHandler) === 'undefined')) {
      layer.eventHandler = (layer.eventHandler.length === "undefined") ? layer.eventHandler : [layer.eventHandler];
      layer.eventHandler.forEach(function(evt){
        s.addEventHandler(evt.event, eval(evt.handler))
      })
    }*/
      
    myChart.series.push(s);
    return s;
  };
  
  buildSeries(opts, false);
  if (opts.layers.length > 0) {
    opts.layers.forEach(function(layer){
      buildSeries(layer, true);
    })
  }
  //unsure if this is best but if legend is provided (not empty) then evaluate
  if(d3.keys(opts.legend).length > 0) {
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

</script>



<script>
  d3.select('#example5').selectAll('#All_1_Currency_,#All_5_Currency_').remove()
</script>
  


<div id = "example5></div>


---

### Colored Labels
Not sure if this helps viewers understand our chart or not, but colored labels for the `xAxis` might get style points.  A little `d3.js` can help us make the change.


```r
#one last bit of cleanup
#label the axes as in the original
dP$setTemplate(
  afterScript = "
<script>
  //get rid of dummy data
  d3.select('#example6').selectAll('#All_1_Currency_,#All_5_Currency_').remove()
  //get rid of text labels on x axis
  d3.select('#example6').select('.axis:nth-child(2)').selectAll('.tick text').remove()
  //label with text from original
  d3.select('#example6').select('.axis:nth-child(2)').select('.tick').append('text')
    .text('Minimum Allocation')
    .attr('dy','1.5em')
    .style('fill',myChart.axes[0].colors[0])
  d3.select('#example6').select('.axis:nth-child(2)').select('.tick:last-of-type').append('text')
    .text('Maximum Allocation')
    .attr('text-anchor','end')
    .attr('dy','1.5em')
    .style('fill',myChart.axes[0].colors[4])
</script>
  "
)
dP$show(chartId = "example6")
```


<div id = 'example6' class = 'rChart dimple'></div>
<script type="text/javascript">
  var opts = {
 "dom": "example6",
"width":    600,
"height":    600,
"xAxis": {
 "type": "addCategoryAxis",
"showPercent": false 
},
"yAxis": {
 "type": "addCategoryAxis",
"showPercent": false,
"orderRule": [ "Currency", "Municipals", "High Yield", "Investment Grade Credit", "Mortgage-Backed Securities", "Emerging Markets", "Non US Developed", "Curve Positions", "U.S. Treasuries" ] 
},
"zAxis": [],
"colorAxis": {
 "type": "addColorAxis",
"colorSeries": "View",
"palette": [ "#D7191C", "#FDAE61", "#FFFFBF", "#A6D96A", "#1A9641" ] 
},
"defaultColors": [],
"layers": [],
"legend": [],
"x": "View",
"y": "Asset",
"type": "bar",
"bounds": {
 "x":    240,
"y":     50,
"width":    360,
"height":    500 
},
"id": "example6" 
},
    data = [{"Asset":"U.S. Treasuries","View":3},{"Asset":"Curve Positions","View":6},{"Asset":"Non US Developed","View":3},{"Asset":"Emerging Markets","View":2},{"Asset":"Mortgage-Backed Securities","View":4},{"Asset":"Investment Grade Credit","View":3},{"Asset":"High Yield","View":3},{"Asset":"Municipals","View":4},{"Asset":"Currency","View":2},{"Asset":"Currency","View":1},{"Asset":"Currency","View":5}];
  var svg = dimple.newSvg("#" + opts.id, opts.width, opts.height);

  //data = dimple.filterData(data, "Owner", ["Aperture", "Black Mesa"])
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
    var axisopts = opts[position+"Axis"];
    
    if(axisopts.measure) {
      axis = myChart[axisopts.type](position,layer[position],axisopts.measure);
    } else {
      axis = myChart[axisopts.type](position, layer[position]);
    };
    if(!(axisopts.type === "addPctAxis")) axis.showPercent = axisopts.showPercent;
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
  if(d3.keys(opts.colorAxis).length > 0) {
    c = myChart[opts.colorAxis.type](opts.colorAxis.colorSeries,opts.colorAxis.palette) ;
  }
  
  //allow manipulation of default colors to use with dimple
  if(opts.defaultColors.length) {
    opts.defaultColors = opts.defaultColors[0];
    if (typeof(opts.defaultColors) == "function") {
      //assume this is a d3 scale
      //for now loop through first 20 but need a better way to handle
      defaultColorsArray = [];
      for (var n=0;n<20;n++) {
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
    var x = buildAxis("x", layer);
    x.hidden = hidden;
    
    var y = buildAxis("y", layer);
    y.hidden = hidden;
    
    //z for bubbles
    var z = null;
    if (!(typeof(layer.zAxis) === 'undefined') && layer.zAxis.type){
      z = buildAxis("z", layer);
    };
    
    //here think I need to evaluate group and if missing do null
    //as the group argument
    //if provided need to use groups from layer
    var s = new dimple.series(myChart, null, x, y, z, c, dimple.plot[layer.type], dimple.aggregateMethod.avg, dimple.plot[layer.type].stacked);
    
    if(layer.hasOwnProperty("groups")) {
      s.categoryFields = (typeof layer.groups === "object") ? layer.groups : [layer.groups]; 
    };
    
    //series offers an aggregate method that we will also need to check if available
    //options available are avg, count, max, min, sum
    if (!(typeof(layer.aggregate) === 'undefined')) {
      s.aggregate = eval(layer.aggregate);
    }
    if (!(typeof(layer.lineWeight) === 'undefined')) {
      s.lineWeight = eval(layer.lineWeight);
    }
    if (!(typeof(layer.barGap) === 'undefined')) {
      s.barGap = eval(layer.barGap);
    }
    
   /* if (!(typeof(layer.eventHandler) === 'undefined')) {
      layer.eventHandler = (layer.eventHandler.length === "undefined") ? layer.eventHandler : [layer.eventHandler];
      layer.eventHandler.forEach(function(evt){
        s.addEventHandler(evt.event, eval(evt.handler))
      })
    }*/
      
    myChart.series.push(s);
    return s;
  };
  
  buildSeries(opts, false);
  if (opts.layers.length > 0) {
    opts.layers.forEach(function(layer){
      buildSeries(layer, true);
    })
  }
  //unsure if this is best but if legend is provided (not empty) then evaluate
  if(d3.keys(opts.legend).length > 0) {
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

</script>



<script>
  //get rid of dummy data
  d3.select('#example6').selectAll('#All_1_Currency_,#All_5_Currency_').remove()
  //get rid of text labels on x axis
  d3.select('#example6').select('.axis:nth-child(2)').selectAll('.tick text').remove()
  //label with text from original
  d3.select('#example6').select('.axis:nth-child(2)').select('.tick').append('text')
    .text('Minimum Allocation')
    .attr('dy','1.5em')
    .style('fill',myChart.axes[0].colors[0])
  d3.select('#example6').select('.axis:nth-child(2)').select('.tick:last-of-type').append('text')
    .text('Maximum Allocation')
    .attr('text-anchor','end')
    .attr('dy','1.5em')
    .style('fill',myChart.axes[0].colors[4])
</script>
  


<div id = "example6></div>

---

### Can Sort Help Convey?
Here is where some formal training might help, but I wanted to see if a different sort order might help.  Let's sort and in effect group opportunities by our view.


```r
#but if we want to sort our y Axis by view
#could do this
dP$yAxis(
  orderRule = views$Asset[order(views$View,decreasing=T)]
)
dP$show(chartId = "example7")
```


<div id = 'example7' class = 'rChart dimple'></div>
<script type="text/javascript">
  var opts = {
 "dom": "example7",
"width":    600,
"height":    600,
"xAxis": {
 "type": "addCategoryAxis",
"showPercent": false 
},
"yAxis": {
 "type": "addCategoryAxis",
"showPercent": false,
"orderRule": [ "Curve Positions", "Mortgage-Backed Securities", "Municipals", "U.S. Treasuries", "Non US Developed", "Investment Grade Credit", "High Yield", "Emerging Markets", "Currency" ] 
},
"zAxis": [],
"colorAxis": {
 "type": "addColorAxis",
"colorSeries": "View",
"palette": [ "#D7191C", "#FDAE61", "#FFFFBF", "#A6D96A", "#1A9641" ] 
},
"defaultColors": [],
"layers": [],
"legend": [],
"x": "View",
"y": "Asset",
"type": "bar",
"bounds": {
 "x":    240,
"y":     50,
"width":    360,
"height":    500 
},
"id": "example7" 
},
    data = [{"Asset":"U.S. Treasuries","View":3},{"Asset":"Curve Positions","View":6},{"Asset":"Non US Developed","View":3},{"Asset":"Emerging Markets","View":2},{"Asset":"Mortgage-Backed Securities","View":4},{"Asset":"Investment Grade Credit","View":3},{"Asset":"High Yield","View":3},{"Asset":"Municipals","View":4},{"Asset":"Currency","View":2},{"Asset":"Currency","View":1},{"Asset":"Currency","View":5}];
  var svg = dimple.newSvg("#" + opts.id, opts.width, opts.height);

  //data = dimple.filterData(data, "Owner", ["Aperture", "Black Mesa"])
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
    var axisopts = opts[position+"Axis"];
    
    if(axisopts.measure) {
      axis = myChart[axisopts.type](position,layer[position],axisopts.measure);
    } else {
      axis = myChart[axisopts.type](position, layer[position]);
    };
    if(!(axisopts.type === "addPctAxis")) axis.showPercent = axisopts.showPercent;
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
  if(d3.keys(opts.colorAxis).length > 0) {
    c = myChart[opts.colorAxis.type](opts.colorAxis.colorSeries,opts.colorAxis.palette) ;
  }
  
  //allow manipulation of default colors to use with dimple
  if(opts.defaultColors.length) {
    opts.defaultColors = opts.defaultColors[0];
    if (typeof(opts.defaultColors) == "function") {
      //assume this is a d3 scale
      //for now loop through first 20 but need a better way to handle
      defaultColorsArray = [];
      for (var n=0;n<20;n++) {
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
    var x = buildAxis("x", layer);
    x.hidden = hidden;
    
    var y = buildAxis("y", layer);
    y.hidden = hidden;
    
    //z for bubbles
    var z = null;
    if (!(typeof(layer.zAxis) === 'undefined') && layer.zAxis.type){
      z = buildAxis("z", layer);
    };
    
    //here think I need to evaluate group and if missing do null
    //as the group argument
    //if provided need to use groups from layer
    var s = new dimple.series(myChart, null, x, y, z, c, dimple.plot[layer.type], dimple.aggregateMethod.avg, dimple.plot[layer.type].stacked);
    
    if(layer.hasOwnProperty("groups")) {
      s.categoryFields = (typeof layer.groups === "object") ? layer.groups : [layer.groups]; 
    };
    
    //series offers an aggregate method that we will also need to check if available
    //options available are avg, count, max, min, sum
    if (!(typeof(layer.aggregate) === 'undefined')) {
      s.aggregate = eval(layer.aggregate);
    }
    if (!(typeof(layer.lineWeight) === 'undefined')) {
      s.lineWeight = eval(layer.lineWeight);
    }
    if (!(typeof(layer.barGap) === 'undefined')) {
      s.barGap = eval(layer.barGap);
    }
    
   /* if (!(typeof(layer.eventHandler) === 'undefined')) {
      layer.eventHandler = (layer.eventHandler.length === "undefined") ? layer.eventHandler : [layer.eventHandler];
      layer.eventHandler.forEach(function(evt){
        s.addEventHandler(evt.event, eval(evt.handler))
      })
    }*/
      
    myChart.series.push(s);
    return s;
  };
  
  buildSeries(opts, false);
  if (opts.layers.length > 0) {
    opts.layers.forEach(function(layer){
      buildSeries(layer, true);
    })
  }
  //unsure if this is best but if legend is provided (not empty) then evaluate
  if(d3.keys(opts.legend).length > 0) {
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

</script>



<script>
  //get rid of dummy data
  d3.select('#example7').selectAll('#All_1_Currency_,#All_5_Currency_').remove()
  //get rid of text labels on x axis
  d3.select('#example7').select('.axis:nth-child(2)').selectAll('.tick text').remove()
  //label with text from original
  d3.select('#example7').select('.axis:nth-child(2)').select('.tick').append('text')
    .text('Minimum Allocation')
    .attr('dy','1.5em')
    .style('fill',myChart.axes[0].colors[0])
  d3.select('#example7').select('.axis:nth-child(2)').select('.tick:last-of-type').append('text')
    .text('Maximum Allocation')
    .attr('text-anchor','end')
    .attr('dy','1.5em')
    .style('fill',myChart.axes[0].colors[4])
</script>
  


<div id = "example7"></div>

---

### Spread the Font Love
This is hard to show before and after, but I thought it would be nice to use the same fonts from html in our `dimplejs` charts.  `dimplejs` allows full custom formatting with [`noFormats`](https://github.com/PMSI-AlignAlytics/dimple/wiki/dimple.chart#noFormats), but I just want to change the font.  Let's use a little `d3.js` to change the font for our `svg text`.


```r
<script>
  d3.selectAll('svg text').style("font-family",d3.select("body").style("font-family"))
</script>
```


<script>
  d3.selectAll('svg text').style("font-family",d3.select("body").style("font-family"))
</script>

---

### More to Do

I still have many things I want to try to improve this chart and its interactivity, but we'll stop here.  If anybody really wants a part 2, please let me know.

---

### Thanks
As I hope you can tell, this post was more a function of the efforts of others than of my own.

Thanks specifically:
- [Ramnath Vaidyanathan](http://ramnathv.github.io/) for [rCharts](http://rcharts.io/site) and [slidify](http://slidify.org).
- [John Kiernander](https://twitter.com/jkiernander) for [dimplejs](http://dimplejs.org)
- Nameless Fixed Income Shop for the original chart.
- [Mike Bostock](http://bost.ocks.org/mike/) for everything.
- Google fonts [Raleway](http://www.google.com/fonts/specimen/Raleway) and [Oxygen](http://www.google.com/fonts/specimen/Oxygen)
