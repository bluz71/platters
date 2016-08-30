# Create a namespace to place all appliction JavaScript code under.
window.App ?= {}

# Must initialize Bootstrap Tooltips on every page transistion.
App.init = ->
  $("[data-toggle=tooltip]").tooltip()

$(document).on "page:change", ->
  App.init()

# Initialize Turbolinks progress bar on first page load. 
jQuery ->
  Turbolinks.enableProgressBar()
