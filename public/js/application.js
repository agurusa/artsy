$(document).ready(function() {

  $(".feelings").on("submit", function(event){
    event.preventDefault();
    var data = $(this).serialize();
    $.ajax({
      method: "POST",
      url: "/sentence",
      data: data

    }).done(function(response){
      $("ul").html(response)
    })
  })

});
