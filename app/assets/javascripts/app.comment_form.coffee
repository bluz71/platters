class App.CommentForm
  constructor: ->
    @setEventHandlers()

  setEventHandlers: ->
    $(document).on "keyup", "[data-behavior~=write-comment]", @commentKeyup

  commentKeyup: (event) ->
    comment = $("[data-behavior~=write-comment]").val()
    charsRemaining = 280 - comment.length
    if charsRemaining > 0
      $("[data-behavior~=comment-length]")
        .removeClass("comment-error")
        .html("<i class='fa fa-plus-square-o'></i> #{charsRemaining}")
      if charsRemaining == 280
        $("[data-behavior~=post-comment]").prop("disabled", true)
      else
        $("[data-behavior~=post-comment]").prop("disabled", false)
    else if charsRemaining == 0
      $("[data-behavior~=comment-length]")
        .removeClass("comment-error")
        .html("<i class='fa fa-plus-square-o'></i> #{charsRemaining}")
      $("[data-behavior~=post-comment]").prop("disabled", false)
    else
      # Must be negative.
      charsRemaining = -charsRemaining
      $("[data-behavior~=comment-length]")
        .addClass("comment-error")
        .html("<i class='fa fa-minus-square-o'></i> #{charsRemaining}")
      $("[data-behavior~=post-comment]").prop("disabled", true)

jQuery ->
  new App.CommentForm()
