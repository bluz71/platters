# Scroll handling is expensive, hence use a timer to handle infinite page
# scrolling.
#
# For more details:
#
#   https://stackoverflow.com/questions/3898130/check-if-a-user-has-scrolled-to-the-bottom
#   https://stackoverflow.com/questions/9613594/scroll-event-firing-too-many-times-i-only-want-it-to-fire-a-maximum-of-say-on
#   http://ejohn.org/blog/learning-from-twitter/

App.scrolledWithComments = false

# Enable and disable scroll handling dependent on whether the page has
# scrollable comments and do it even when Turbolinks navigation is in effect.
#
# The scroll event triggers very often, so only enable it for pages that need
# it.
$(document).on "turbolinks:load", ->
  $(window).off "scroll"
  App.scrolledWithComments = false
  if $("#comments").length 
    $(window).on "scroll", ->
      App.scrolledWithComments = true

class App.CommentsShowMore
  constructor: ->
    @setEventHandlers()

  setEventHandlers: ->
    setInterval(@scrollForMoreComments, 250)

  scrollForMoreComments: =>
    return unless App.scrolledWithComments
    App.scrolledWithComments = false
    if $(window).scrollTop() + $(window).height() == $(document).height()
      # The user has scrolled to the bottom of the page.
      @showMoreComments()

  showMoreComments: =>
    showMoreComments = $("[data-behavior~=show-more-comments]")
    return unless showMoreComments.length
    commentsUrl = showMoreComments.data("comments-url")
    currentPage = Number(showMoreComments.attr("data-current-page"))
    totalPages  = showMoreComments.data("total-pages")
    if currentPage < totalPages
      $.ajax(
        url: "#{commentsUrl}?page=#{currentPage + 1}",
        method: "GET",
        dataType: "html",
        success: @appendComments)

  appendComments: (comments) ->
    $("[data-behavior~=comments]").append(comments)
    showMoreComments = $("[data-behavior~=show-more-comments]")
    currentPage = Number(showMoreComments.attr("data-current-page"))
    showMoreComments.attr("data-current-page", currentPage + 1)

jQuery ->
  new App.CommentsShowMore()
