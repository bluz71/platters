class App.AlbumsSelect
  constructor: ->
    @setEventHandlers()

  setEventHandlers: ->
    $(document).on "click", "[data-behavior~=album-search-link]", @searchClick
    $(document).on "click", "[data-behavior~=album-filters-link]", @filtersClick

  searchClick: (event) =>
    if $("[data-behavior~=album-search-form]").is(":hidden")
      $("[data-behavior~=album-letter-picker]").hide()
    else
      $("[data-behavior~=album-letter-picker]").show()
    $("[data-behavior~=album-filters-form]").slideUp(250)
    $("[data-behavior~=album-search-form]").slideToggle(250, @searchFocus)

  searchFocus: ->
    $("[data-behavior~=album-search-field]").focus()

  filtersClick: (event) ->
    if $("[data-behavior~=album-filters-form]").is(":hidden")
      $("[data-behavior~=album-letter-picker]").hide()
    else
      $("[data-behavior~=album-letter-picker]").show()
    $("[data-behavior~=album-search-form]").slideUp(250)
    $("[data-behavior~=album-filters-form]").slideToggle()

jQuery ->
  new App.AlbumsSelect()
