
// alert fade

$(document).ready(function(){

  function fadeAlert(){
    $('#notice').fadeIn();
  }

  function removeAlert(){
    $('.alert-fade').fadeOut();
  }

  window.setTimeout(fadeAlert,500);
  window.setTimeout(removeAlert,6000);

});

