 $(function() {

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
        opacity: 0
      }, 500);
      $('#new_post').html('New Post');
      $('.post_edit_buttons').fadeIn(200);

    }
});

});