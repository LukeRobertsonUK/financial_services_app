$(function() {


  $.getJSON('/users.json', function(data){
    $("#user_tag_cloud").jQCloud(data, {
      delayedMode: true,
    });
  }) //closes the getJSON

  console.log("hello")
});