var postTags = function(){
  $("#post_tags").tokenInput("/tags.json"), {
    crossDomain: false,
    prePopulate: $("#post_tags").data("pre"),
    preventDuplicates: true,
    theme: "facebook",
    };
}





$(function() {

  if($('.fire_off_tokens').length > 0){

     postTags();
  }




});