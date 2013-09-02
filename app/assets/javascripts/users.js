$(function() {

if($('#admin_user_search').length == 0){

  $('#q_first_name_or_last_name_or_investment_styles_name_or_email_or_business_or_firm_name_cont').on('keyup', function(){
    $('.user_search').submit();
  })
}



  $.getJSON('/tag_count.json', function(data){
    $("#user_tag_cloud").jQCloud(data, {
      // delayedMode: true,
      removeOverflowing: false
    });
  }) //closes the getJSON


  $.getJSON('/tag_count_post.json', function(data){
    $("#post_tag_cloud").jQCloud(data, {
      delayedMode: true,
    });
  }) //closes the getJSON

});