var casper = require('casper').create({viewportSize:{width:3200,height:1800}});

//casper.start("gallery/example01_bar_vert.html", function() {
//    this.capture('example.png', {
//        top: 0,
//        left: 0,
//        width: 1024,
//        height: 768
//    });
//});

casper.start('gallery/example11_bar_horiz_stack_grp.html', function() {
this.captureSelector('example11.png', '.rChart');
});


casper.run();