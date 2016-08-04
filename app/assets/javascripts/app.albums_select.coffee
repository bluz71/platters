class App.AlbumsSelect
  constructor: ->
    @setEventHandlers()

  setEventHandlers: ->
    $(document).on "click", "[data-behavior~=album-search-link]", @searchClick
    $(document).on "click", "[data-behavior~=album-filters-link]", @filtersClick

  searchClick: (event) =>
    $("[data-behavior~=album-letter-picker]").hide()
    $("[data-behavior~=album-search-form]").slideToggle(250, @searchFocus)
    $("[data-behavior~=album-filters-form]").slideUp(250)

  searchFocus: ->
    $("[data-behavior~=album-search-field]").focus()

  filtersClick: (event) ->
    $("[data-behavior~=album-letter-picker]").hide()
    $("[data-behavior~=album-search-form]").slideUp(250)
    $("[data-behavior~=album-filters-form]").slideToggle()

jQuery ->
  new App.AlbumsSelect()
