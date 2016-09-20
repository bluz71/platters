# Create a namespace to place all appliction JavaScript code under.
window.App ?= {}

# Must initialize Bootstrap Tooltips on every page transistion.
App.init = ->
  $("[data-toggle=tooltip]").tooltip()

$(document).on "page:change", ->
  App.init()

# Initialize desired Turbolinks behaviours on first page load. 
jQuery ->
  Turbolinks.pagesCached(15)
  Turbolinks.enableTransitionCache()
  Turbolinks.enableProgressBar()

# Catch any AJAX errors and display on the console. This is most useful for
# for JS responses to remote:true forms and links that contain syntax errors.
$(document).on "ajax:error", (event, xhr, status, error) ->
  console.log status.responseText
  console.log error
