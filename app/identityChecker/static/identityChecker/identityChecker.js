function captureImages() {
    var count = 0;

    var timeleft = 25;
    var downloadTimer = setInterval(function(){
    if(timeleft % 5 == 0) {
        document.getElementById("countdown").innerHTML = 5 + " Seconds Until Photo is Taken";
    } 
    else {
        document.getElementById("countdown").innerHTML = timeleft % 5 + " Seconds Until Photo is Taken";
    }

      timeleft -= 1;
      if(timeleft == 19){
        context.drawImage(player, 0, 0, canvas.width, canvas.height);
      }
        
    if(timeleft == 14) {
        const canvas2 = document.getElementById('canvas2');
        const context2 = canvas2.getContext('2d');
        
        context2.drawImage(player, 0, 0, canvas2.width, canvas2.height);
    }
    
    if(timeleft == 9) {
        const canvas3 = document.getElementById('canvas3');
        const context3 = canvas3.getContext('2d');
        
        context3.drawImage(player, 0, 0, canvas3.width, canvas3.height);
    }
        
    if(timeleft == 4) {
        const canvas4 = document.getElementById('canvas4');
        const context4 = canvas4.getContext('2d');
        
        context4.drawImage(player, 0, 0, canvas4.width, canvas4.height);
    }
        
    if(timeleft < 0) {
        const canvas5 = document.getElementById('canvas5');
        const context5 = canvas5.getContext('2d');
        
        context5.drawImage(player, 0, 0, canvas5.width, canvas5.height);
        document.getElementById("countdown").innerHTML = "Finished"
        clearInterval(downloadTimer);

    }
        
    console.log("count: " + count);
    console.log("timeleft: " + timeleft);
    }, 1000);
}

function download(){    
    var download = document.getElementById("download");
    var image = canvas.toDataURL("image/png").replace("image/png", "image/octet-stream");

    download.setAttribute("href", image);
}