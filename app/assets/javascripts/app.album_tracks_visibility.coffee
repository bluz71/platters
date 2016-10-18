class App.AlbumTracksVisibility
  constructor: ->
    @setEventHandlers()

  setEventHandlers: ->
    $(document).on "click", "[data-behavior~=album-show-all-tracks]", @tracksVisibilityClick
    $(document).on "click", "[data-behavior~=album-show-less-tracks]", @tracksVisibilityClick

  tracksVisibilityClick: (event) ->
    $(".tracks-gradient").toggle()
    $("[data-behavior~=track-toggle-visibility]").toggleClass("invisible").toggleClass("visible")
    $("[data-behavior~=album-show-all-tracks]").toggleClass("invisible")
    $("[data-behavior~=album-show-less-tracks]").toggleClass("invisible")

jQuery ->
  new App.AlbumTracksVisibility()
