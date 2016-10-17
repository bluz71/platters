class App.AlbumShowAllTracks
  constructor: ->
    @setEventHandlers()

  setEventHandlers: ->
    $(document).on "click", "[data-behavior~=album-show-all-tracks]", @showAllTracksClick

  showAllTracksClick: (event) ->
    $(".tracks-gradient").remove()
    $("tr.hidden").removeClass("hidden").addClass("visible")
    $("[data-behavior~=album-show-all-tracks]").remove()

jQuery ->
  new App.AlbumShowAllTracks
