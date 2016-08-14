class App.ArtistsSelect
  constructor: ->
    @setEventHandlers()

  setEventHandlers: ->
    $(document).on "click", "[data-behavior~=artist-search-link]", @searchClick

  searchClick: (event) =>
    $("[data-behavior~=artist-letter-picker]").toggle()
    $("[data-behavior~=artist-search]").slideToggle(250, @searchFocus)

  searchFocus: ->
    $("[data-behavior~=artist-search-field]").focus()

jQuery ->
  new App.ArtistsSelect()
