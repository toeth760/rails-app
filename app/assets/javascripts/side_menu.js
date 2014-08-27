$( document  ).ready(function( $  ) {
  $("body").on('mousemove', function(e) {
    if (e.pageX <= 100 && $(".side-menu").hasClass('hidden')) {
            console.log('SHOWING');
                  $('.side-menu').removeClass('hidden');
                        $('.side-menu').animate({right: "0", left: 0});
                            
    } 

  });


  $(".side-menu").on('mouseleave', function(e) {
    if($(".side-menu").hasClass('hidden') == false) {
            console.log('HIDING');
                  $('.side-menu').removeClass('hidden');
                  $('.side-menu').animate({right: "0", left: "-402px"}, 400, function() {
                            $(".side-menu").addClass('hidden');
                                  
                  });
                      
    }

  });
});
