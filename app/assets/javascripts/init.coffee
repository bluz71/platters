# Create a namespace to place all appliction JavaScript code under.
window.App ?= {}

# Must initialize Bootstrap Tooltips on every page transistion.
App.init = ->
  $("[data-toggle=tooltip]").tooltip()

$(document).on "turbolinks:load", ->
  App.init()

# Catch any AJAX errors and display on the console. This is most useful for
# for JS responses to remote:true forms and links that contain syntax errors.
$(document).on "ajax:error", (event, xhr, status, error) ->
  console.log status.responseText
  console.log error
