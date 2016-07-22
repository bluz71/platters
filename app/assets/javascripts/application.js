//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require init
//= require app.album_form
//= require app.artist_form
//= require app.artist_search


// Catch any AJAX errors and display on the console. This is most useful for
// for JS responses to remote:true forms and links that contain syntax errors.
//
$(document).on("ajax:error", function(event, xhr, status, error) {
  console.log(status.responseText);
  return console.log(error);
});
