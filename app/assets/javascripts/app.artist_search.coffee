class App.ArtistSearch
  constructor: ->
    @setEventHandlers()

  setEventHandlers: ->
    $(document).on "click", "[data-behavior~=artist-search-link]", @artistSearchClick

  artistSearchClick: (event) ->
    $("[data-behavior~=artist-search-form]").slideToggle()

jQuery ->
  new App.ArtistSearch()
