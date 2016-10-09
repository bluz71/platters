# Create a namespace to place all appliction JavaScript code under.
window.App ?= {}

App.init = ->
  # Auto-hide, then remove, flash messages.
  $(".alert").delay(4000).fadeOut 500, ->
    $(this).remove()

App.transistions = ->
  # Initialize Bootstrap Tooltips.
  $("[data-toggle=tooltip]").tooltip()

# On initial DOM load.
jQuery ->
  App.init()

# On every page change.
$(document).on "turbolinks:load", ->
  App.transistions()

# Catch any AJAX errors and display on the console. This is most useful for
# for JS responses to remote:true forms and links that contain syntax errors.
$(document).on "ajax:error", (event, xhr, status, error) ->
  console.log status.responseText
  console.log error
