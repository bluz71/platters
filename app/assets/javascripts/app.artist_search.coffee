class App.ArtistSearch
  constructor: ->
    @setEventHandlers()

  setEventHandlers: ->
    $(document).on "click", "[data-behavior~=artist-search-link]", @artistSearchClick

  artistSearchClick: (event) =>
    $("[data-behavior~=artist-search-form]").slideToggle(@artistSearchFocus)

  artistSearchFocus: ->
    $("[data-behavior~=artist-search-field]").focus()

jQuery ->
  new App.ArtistSearch()
