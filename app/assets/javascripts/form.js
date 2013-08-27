$(function() {

  if($('.editing').length > 0){
    $( ".form_fields").fadeTo(10, 1);
  }else{
    $("#firm_select").fadeTo(10,1);
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
      $( ".form_fields").fadeTo(500, 1);
      }else{
         $("#firm_select").animate({
        height: "toggle",
        opacity: 1
      }, 150);
        $( ".form_fields").fadeTo(500, 0);
        $(".box_to_clear").val("");
      }
    })

  $( "#organization_id" ).change(function() {
    if($( "#organization_id").val() == ""){

      $( ".form_fields").fadeTo(150, 1);
      }else{
        $( ".form_fields").fadeTo(150, 0);
      }
    })


});