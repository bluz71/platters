# Create a namespace to place all appliction JavaScript code under.
@App = {}

App.pageChange = ->
  # Initialize Bootstrap Tooltips.
  $("[data-toggle=tooltip]").tooltip()
  # Auto-hide, then remove, flash[:notice] messages.
  $(".alert-notice").delay(4500).fadeOut 500, ->
    $(this).remove()

# On every page change.
$(document).on "turbolinks:load", ->
  App.pageChange()

# Catch any AJAX errors and display on the console. This is most useful for
# for JS responses to remote:true forms and links that contain syntax errors.
$(document).on "ajax:error", (event, xhr, status, error) ->
  console.log status.responseText
  console.log error
