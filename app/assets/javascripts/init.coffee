# Create a namespace to place all appliction JavaScript code under.
window.App ?= {}

# Initialize Bootstrap Tooltips on every page transistion.
# Auto-hide, then remove, flash messages.
App.init = ->
  $("[data-toggle=tooltip]").tooltip()
  $(".alert").delay(3000).fadeOut 500, ->
    $(this).remove()

$(document).on "turbolinks:load", ->
  App.init()

# Catch any AJAX errors and display on the console. This is most useful for
# for JS responses to remote:true forms and links that contain syntax errors.
$(document).on "ajax:error", (event, xhr, status, error) ->
  console.log status.responseText
  console.log error
