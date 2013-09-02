 $(function() {

if($('#admin_user_search').length == 0){
  $('#q_title_or_content_or_tags_name_or_comments_content_cont').on('keyup', function(){
    $('#post_search').submit();
  })
}

if($('#admin_user_search').length == 0){

   $('#q_user_first_name_or_user_last_name_or_user_investment_styles_name_or_user_email_or_user_business_or_user_firm_name_cont').on('keyup', function(){
    $('#post_search').submit();
  })
 }

  $(function() {

    $( ".datepicker" ).datepicker({
      changeMonth: true,
      changeYear: true,
      dateFormat: "yy-mm-dd",
      onSelect: function(date) {
        $('#post_search').submit();
      }
    });
  });

  $('#clear_form').on('click', function(){
    $('#q_title_or_content_or_tags_name_or_comments_content_cont').val("");
    $('#q_user_first_name_or_user_last_name_or_user_investment_styles_name_or_user_email_or_user_business_or_user_firm_name_cont').val("");
    $('.hasDatepicker').val('');
    $('#post_search').submit();

  })









 $('#new_post').on('click', function(){

    if ($('#remote_post_form').css('display') === 'none'){
      $('.post_edit_buttons').fadeOut(200);
      if($(".token-input-input-token").length < 1){
        postTags();
      }


       $('#remote_post_form').animate({
        height: "toggle",
        opacity: 1
      }, 500);

      $('#new_post').html('Hide Form')
    }else{
      $('#remote_post_form').animate({
        height: "toggle",
        opacity: 0,
      }, 500);
      $('#new_post').html('New Post');
      $('.post_edit_buttons').fadeIn(200);

    }
});

});