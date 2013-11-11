window.onload = function(){
  $.getJSON(document.location.href + "/json", function(data){

    var position = $("#graph").position();

    var xValues = data.map(function(item, index){
      return index + 1;
    });

    var r = Raphael(position.left, position.top, 640, 480);
    r.linechart(50,50, 640-50, 480-50, 
      xValues, 
      data, 
      {nostroke:true, axis:"0 0 0 1", symbol: "circle", smooth: true});
  });
};
