$(document).ready(function() {
  $('.carousel').carousel();
  $.ajax({
    method: "GET",
    url: "/pie",
    async:false,
    dataType: "json"
  }).done(function(response){
    console.log(response)
    var chart = new Highcharts.Chart({
        chart: {
          renderTo: 'pie',
            plotBackgroundColor: null,
            plotBorderWidth: null,
            plotShadow: false,
            type: 'pie'
        },
        title: {
            text: 'Color to Word Associations'
        },
        tooltip: {
            pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
        },
        plotOptions: {
            pie: {
                allowPointSelect: true,
                cursor: 'pointer',
                dataLabels: {
                    enabled: true,
                    format: '<b>{point.name}</b>: {point.percentage:.1f} %',
                    style: {
                        color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'
                    }
                }
            }
        },
        series: [{
            name: 'Brands',
            colorByPoint: true,
            data: response
        }]
    });
  })

});
