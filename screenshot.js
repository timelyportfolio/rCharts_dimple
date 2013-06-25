var casper = require('casper').create();

casper.start('gallery/example11_bar_horiz_stack_grp.html', function() {
this.captureSelector('example11.png', '.container');
});

casper.run();