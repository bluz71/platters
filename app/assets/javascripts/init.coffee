# Create a namespace to place all appliction JavaScript code under.
window.App ?= {}

# Initialize Bootstrap Tooltips.
App.init = ->
  $("[data-toggle=tooltip]").tooltip()

# Boostrap Tooltips need to be initialized on each page transistion.
$(document).on "page:change", ->
  App.init()
