function getName(){
    var name = document.getElementById('first_name').value + '_' + document.getElementById('last_name').value;
    return name;
}


function download(){
  var name = getName();
  var link = document.createElement('a');
  link.download = name + '_1' + '.png';
  link.href = document.getElementById('canvas1').toDataURL()
  link.click();
}

function download2(){
  var name = getName();
  var link = document.createElement('a');
  link.download = name + '_2' + '.png';
  link.href = document.getElementById('canvas2').toDataURL()
  link.click();
}

function download3(){
  var name = getName();
  var link = document.createElement('a');
  link.download = name + '_3' + '.png';
  link.href = document.getElementById('canvas3').toDataURL()
  link.click();
}

function download4(){
  var name = getName();
  var link = document.createElement('a');
  link.download = name + '_4' + '.png';
  link.href = document.getElementById('canvas4').toDataURL()
  link.click();
}

function download5(){
  var name = getName();
  var link = document.createElement('a');
  link.download = name + '_5' + '.png';
  link.href = document.getElementById('canvas5').toDataURL()
  link.click();
}

function download6(){
  var name = getName();
  var link = document.createElement('a');
  link.download = name + '_6' + '.png';
  link.href = document.getElementById('canvas6').toDataURL()
  link.click();
}

function download7(){
  var name = getName();
  var link = document.createElement('a');
  link.download = name + '_7' + '.png';
  link.href = document.getElementById('canvas7').toDataURL()
  link.click();
}

function download8(){
  var name = getName();
  var link = document.createElement('a');
  link.download = name + '_8' + '.png';
  link.href = document.getElementById('canvas8').toDataURL()
  link.click();
}

function captureImages() {
    var count = 0;

    var timeleft = 16;
    var downloadTimer = setInterval(function(){
    if(timeleft % 2 == 0) {
        document.getElementById("countdown").innerHTML = 2 + " Seconds Until Photo is Taken";
    } 
    else {
        document.getElementById("countdown").innerHTML = timeleft % 2 + " Seconds Until Photo is Taken";
    }

      timeleft -= 1;
      if(timeleft == 13){
        context.drawImage(player, 0, 0, 160, 120);
        download();
      }
        
    if(timeleft == 11) {
        const canvas2 = document.getElementById('canvas2');
        const context2 = canvas2.getContext('2d');
        
        context2.drawImage(player, 0, 0, 160, 120);
        download2();
    }
    
    if(timeleft == 9) {
        const canvas3 = document.getElementById('canvas3');
        const context3 = canvas3.getContext('2d');
        
        context3.drawImage(player, 0, 0, 160, 120);
        download3();
    }
        
    if(timeleft == 7) {
        const canvas4 = document.getElementById('canvas4');
        const context4 = canvas4.getContext('2d');
        
        context4.drawImage(player, 0, 0, 160, 120);
        download4();
    }
        
    if(timeleft == 5) {
        const canvas5 = document.getElementById('canvas5');
        const context5 = canvas5.getContext('2d');
        
        context5.drawImage(player, 0, 0, 160, 120);
        download5();
        

    }
        
    if(timeleft == 3) {
        const canvas6 = document.getElementById('canvas6');
        const context6 = canvas6.getContext('2d');
        
        context6.drawImage(player, 0, 0, 160, 120);
        download6();

    }
        
    if(timeleft == 1) {
        const canvas7 = document.getElementById('canvas7');
        const context7 = canvas7.getContext('2d');
        
        context7.drawImage(player, 0, 0, 160, 120);
        download7();
    }
        
    if(timeleft < 0) {
        const canvas8 = document.getElementById('canvas8');
        const context8 = canvas8.getContext('2d');
        
        context8.drawImage(player, 0, 0, 160, 120);
        download8();
        document.getElementById("countdown").innerHTML = "Finished"
        
        clearInterval(downloadTimer);

    }
        
    console.log("count: " + count);
    console.log("timeleft: " + timeleft);
    }, 1000);
}


function captureOneImage() {
    var count = 0;

    var timeleft = 2;
    var downloadTimer = setInterval(function(){
      document.getElementById("countdown").innerHTML = timeleft + " Seconds Until Photo is Taken";

      timeleft -= 1;
        
    if(timeleft < 0) {
        const canvas1 = document.getElementById('canvas1');
        const context1 = canvas1.getContext('2d');
        
        context1.drawImage(player, 0, 0, 160, 120);
        download();
        document.getElementById("countdown").innerHTML = "Finished"
        
        clearInterval(downloadTimer);

    }
        
    console.log("count: " + count);
    console.log("timeleft: " + timeleft);
    }, 1000);
}


