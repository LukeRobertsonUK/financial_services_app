$(function() {

  if($('.editing').length > 0){
    $("#form_with_firm_fields").fadeIn(10)
  }else{
    $("#firm_select").fadeIn(10);
  }

  $(".clicker").on('click', function(){
    $("#new_password").animate({
        height: "toggle",
        opacity: 1
      }, 150);
  });


   $( "#editing" ).change(function() {
    if($( "#editing").val() == "true"){
      $("#firm_select").animate({
        height: "toggle",
        opacity: 1
      }, 150);
      $( "#form_with_firm_fields").fadeIn(250);
      }else{
         $("#firm_select").animate({
        height: "toggle",
        opacity: 1
      }, 150);
        $( "#form_with_firm_fields").fadeOut(250);
        $(".box_to_clear").val("");
      }
    })

  $( "#organization_id" ).change(function() {
    if($( "#organization_id").val() == ""){
      $( "#form_with_firm_fields").fadeIn(250);
      }else{
        $( "#form_with_firm_fields").fadeOut(250);
        $(".box_to_clear").val("");
      }
    })


});