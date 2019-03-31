function captureImages() {
    var count = 0;

    var timeleft = 5;
    var downloadTimer = setInterval(function(){
      document.getElementById("countdown").innerHTML = timeleft + " Seconds Until Photo is Taken";
      timeleft -= 1;
      if(timeleft < 0){
        clearInterval(downloadTimer);

      }
    }, 1000);
    document.getElementById("countdown").innerHTML = "Finished";
}

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
        clearInterval(downloadTimer);
        context.drawImage(player, 0, 0, canvas.width, canvas.height);
        document.getElementById("countdown").innerHTML = "Finished"

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