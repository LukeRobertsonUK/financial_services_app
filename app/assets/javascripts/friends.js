
function runConnectedSortable(){
  $( ".connectedSortable" ).sortable({
  connectWith: ".connectedSortable",

  start: function(event, ui) {
    $(ui.item).addClass("myClass");
  },

   stop: function(event, ui) {
    $(ui.item).removeClass("myClass");
    $(ui.item).effect("highlight");
    var user_id = ui.item.data("user_id");
    var new_preference = ui.item.parent().data("field");
    $.post('/friendships/' + user_id + '/update_sharing_pref', {
      'new_preference': new_preference,
      });
      $(ui.item).effect("highlight");
      }
  }).disableSelection();

};









//document is ready
$(function() {
  runConnectedSortable();


  });