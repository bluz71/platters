class App.ArtistFilters
  constructor: ->
    @setEventHandlers()

  setEventHandlers: ->
    $(document).on "click", "[data-behavior~=artist-search-link]", @artistSearchClick

  artistSearchClick: (event) =>
    $("[data-behavior~=artist-letter-picker]").toggle()
    $("[data-behavior~=artist-search-form]").slideToggle(250, @artistSearchFocus)

  artistSearchFocus: ->
    $("[data-behavior~=artist-search-field]").focus()

jQuery ->
  new App.ArtistFilters()
