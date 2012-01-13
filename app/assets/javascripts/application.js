// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
//
$(document).ready(function() {  
  $("#flash_notice, #flash_error").fadeIn(500).delay(6000).fadeOut(500);

  $("div.wrapper").hover( 
    function() { $(this).children('.hover_nav').show(); },
    function() { $(this).children('.hover_nav').hide(); }
  );

  $('.view_user').each(function(index) { $(this).parent().parent().attr('target', "_blank") });
});
