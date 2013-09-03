
function runConnectedSortable(){
  $( ".connectedSortable" ).sortable({
  connectWith: ".connectedSortable",

  start: function(event, ui) {
    $(ui.item).addClass("myClass");
  },

   stop: function(event, ui) {
    $(ui.item).removeClass("myClass");

    var user_id = ui.item.data("user_id");
    var new_preference = ui.item.parent().data("field");
    $.post('/users/' + user_id + '/friendships/update_sharing_pref', {
      'new_preference': new_preference,
      });

      }
  }).disableSelection();

};



//document is ready
$(function() {
  runConnectedSortable();

  // $('#view_incoming_friend_requests').on('click', function(){

  //   if($("#incoming_friend_requests_block").css('display') === 'none' ){
  //     $('#incoming_friend_requests_block').fadeIn(200);
  //   }else{
  //     $('#incoming_friend_requests_block').fadeOut(200);
  //   }

  // })












  });