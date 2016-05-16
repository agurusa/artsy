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
      $(".hidden").removeClass("hidden")
    })
  })

  $(".see_artwork").on("click", function(event){
    console.log("made it to ajax...")
    event.preventDefault();
    var url = $(this).attr("href");
    $.ajax({
      method: "GET",
      url: url,

    }).done(function(response){
      console.log("past ajax...")
      console.log(response)
      $(".images").html(response)
      $(".see_artwork").addClass("hidden")
    })
  })

});
