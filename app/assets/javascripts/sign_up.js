$(function() {

  $("#your_details_button").on('click', function(){

    if($(".your_details").css('display') === 'none' ){

      $(".your_details").animate({
          height: "toggle",
          opacity: 1
        }, 300);

       if($(".investment_interests").css('display') !== 'none' ){
        $(".investment_interests").animate({
          height: "toggle",
          opacity: 0
          }, 300);
        }

        if($(".your_firm").css('display') !== 'none' ){
        $(".your_firm").animate({
          height: "toggle",
          opacity: 0
          }, 300);
        }

        if($(".password_section").css('display') !== 'none' ){
        $(".password_section").animate({
          height: "toggle",
          opacity: 0
          }, 300);
        }

      }else{

       $(".your_details").animate({
          height: "toggle",
          opacity: 0
        }, 300);
    }

  });


  $("#investment_interests_button").on('click', function(){
    if($(".investment_interests").css('display') === 'none' ){

      $(".investment_interests").animate({
          height: "toggle",
          opacity: 1
        }, 300);

       if($(".your_details").css('display') !== 'none' ){
        $(".your_details").animate({
          height: "toggle",
          opacity: 0
          }, 300);
        }

        if($(".your_firm").css('display') !== 'none' ){
        $(".your_firm").animate({
          height: "toggle",
          opacity: 0
          }, 300);
        }

        if($(".password_section").css('display') !== 'none' ){
        $(".password_section").animate({
          height: "toggle",
          opacity: 0
          }, 300);
        }


      }else{

       $(".investment_interests").animate({
          height: "toggle",
          opacity: 0
        }, 300);
    }

  });


  $("#your_firm_button").on('click', function(){
    if($(".your_firm").css('display') === 'none' ){

      $(".your_firm").animate({
          height: "toggle",
          opacity: 1
        }, 300);

       if($(".your_details").css('display') !== 'none' ){
        $(".your_details").animate({
          height: "toggle",
          opacity: 0
          }, 300);
        }

        if($(".investment_interests").css('display') !== 'none' ){
        $(".investment_interests").animate({
          height: "toggle",
          opacity: 0
          }, 300);
        }

        if($(".password_section").css('display') !== 'none' ){
        $(".password_section").animate({
          height: "toggle",
          opacity: 0
          }, 300);
        }

      }else{

       $(".your_firm").animate({
          height: "toggle",
          opacity: 0
        }, 300);
    }

  });


    $("#password_section_button").on('click', function(){
    if($(".password_section").css('display') === 'none' ){

      $(".password_section").animate({
          height: "toggle",
          opacity: 1
        }, 300);

       if($(".your_details").css('display') !== 'none' ){
        $(".your_details").animate({
          height: "toggle",
          opacity: 1
          }, 300);
        }

        if($(".investment_interests").css('display') !== 'none' ){
        $(".investment_interests").animate({
          height: "toggle",
          opacity: 0
          }, 300);
        }

        if($(".your_firm").css('display') !== 'none' ){
        $(".your_firm").animate({
          height: "toggle",
          opacity: 0
          }, 300);
        }

      }else{

       $(".password_section").animate({
          height: "toggle",
          opacity: 0
        }, 300);
    }

  });




})