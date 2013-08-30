var postTags = function(){
  $("#post_tags").tokenInput("/tags.json"), {
    crossDomain: false,
    prePopulate: $("#post_tags").data("pre"),
    preventDuplicates: true,
    theme: "facebook",
    };
}





// $(function() {

//   postTags();


// });