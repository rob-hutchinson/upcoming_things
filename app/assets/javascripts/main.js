$.ajaxSetup( {
  beforeSend: function ( xhr ) {
    xhr.setRequestHeader( 'X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
  }
});

//Scroll Animation for About
$(function() {
    //caches a jQuery object containing the header element
    var animate = $("#progress");
    $(window).scroll(function() {
        var scroll = $(window).scrollTop();

        if (scroll >= 500) {
            animate.removeClass('display-none').addClass("display");
        } 
    });
});

