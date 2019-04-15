var download = function(){
  var link = document.createElement('a');
  link.download = 'image.png';
  link.href = document.getElementById('canvas1').toDataURL()
  link.click();
}

var download2 = function(){
  var link = document.createElement('a');
  link.download = 'image2.png';
  link.href = document.getElementById('canvas2').toDataURL()
  link.click();
}

var download3 = function(){
  var link = document.createElement('a');
  link.download = 'image3.png';
  link.href = document.getElementById('canvas3').toDataURL()
  link.click();
}

var download4 = function(){
  var link = document.createElement('a');
  link.download = 'image4.png';
  link.href = document.getElementById('canvas4').toDataURL()
  link.click();
}

var download5 = function(){
  var link = document.createElement('a');
  link.download = 'image5.png';
  link.href = document.getElementById('canvas5').toDataURL()
  link.click();
}

function captureImages() {
    var count = 0;

    var timeleft = 10;
    var downloadTimer = setInterval(function(){
    if(timeleft % 2 == 0) {
        document.getElementById("countdown").innerHTML = 2 + " Seconds Until Photo is Taken";
    } 
    else {
        document.getElementById("countdown").innerHTML = timeleft % 2 + " Seconds Until Photo is Taken";
    }

      timeleft -= 1;
      if(timeleft == 7){
        context.drawImage(player, 0, 0, 160, 120);
        download();
      }
        
    if(timeleft == 5) {
        const canvas2 = document.getElementById('canvas2');
        const context2 = canvas2.getContext('2d');
        
        context2.drawImage(player, 0, 0, 160, 120);
        download2();
    }
    
    if(timeleft == 3) {
        const canvas3 = document.getElementById('canvas3');
        const context3 = canvas3.getContext('2d');
        
        context3.drawImage(player, 0, 0, 160, 120);
        download3();
    }
        
    if(timeleft == 1) {
        const canvas4 = document.getElementById('canvas4');
        const context4 = canvas4.getContext('2d');
        
        context4.drawImage(player, 0, 0, 160, 120);
        download4();
    }
        
    if(timeleft < 0) {
        const canvas5 = document.getElementById('canvas5');
        const context5 = canvas5.getContext('2d');
        
        context5.drawImage(player, 0, 0, 160, 120);
        download5();
        document.getElementById("countdown").innerHTML = "Finished"
        
        clearInterval(downloadTimer);

    }
        
    console.log("count: " + count);
    console.log("timeleft: " + timeleft);
    }, 1000);
}
