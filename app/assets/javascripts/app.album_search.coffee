class App.AlbumSearch
  constructor: ->
    @setEventHandlers()

  setEventHandlers: ->
    $(document).on "click", "[data-behavior~=album-search-link]", @albumSearchClick

  albumSearchClick: (event) =>
    $("[data-behavior~=album-search-form]").slideToggle(@albumSearchFocus)

  albumSearchFocus: ->
    $("[data-behavior~=album-search-field]").focus()

jQuery ->
  new App.AlbumSearch()
