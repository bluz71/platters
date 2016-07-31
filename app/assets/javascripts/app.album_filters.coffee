class App.AlbumFilters
  constructor: ->
    @setEventHandlers()

  setEventHandlers: ->
    $(document).on "click", "[data-behavior~=album-search-link]", @albumSearchClick

  albumSearchClick: (event) =>
    $("[data-behavior~=album-letter-picker]").toggle()
    $("[data-behavior~=album-search-form]").slideToggle(250, @albumSearchFocus)

  albumSearchFocus: ->
    $("[data-behavior~=album-search-field]").focus()

jQuery ->
  new App.AlbumFilters()
