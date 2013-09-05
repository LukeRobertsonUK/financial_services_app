    var checkFriendRequests = function(){

      if($('#investment_interests_button').length === 0){

          if($('.landing_page').length === 0){
            $.getJSON('/friends.json', function(data){
              if(data > 0){
                $('#friends_alert').addClass('highlight');

              }else{
                $('#friends_alert').removeClass('highlight');

              }
             }) //closes getJSON
          }
        }


    } //closes checkFriendRequests


    var checkRequestDisplay = function(){

      if($('.new_friend_box').length > 0){

        $('#incoming_friend_requests_block').fadeIn(300);
        $('#requests').fadeIn(300);

    }else{
        $('#incoming_friend_requests_block').fadeOut(300);
        $('#requests').fadeOut(300);
    }
}





$(function() {

    checkRequestDisplay();

    checkFriendRequests();
    setInterval(function(){
     setTimeout(function(){
    checkFriendRequests();
        }, 10000);
   }, 10000);


  });