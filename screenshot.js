var casper = require('casper').create();

casper.start('http://timelyportfolio.github.io/rCharts_dimple/gallery/example11_bar_horiz_stack_grp.html', function() {
    this.captureSelector('example11.png', '.rChart');
});

casper.run();
