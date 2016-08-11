class App.AlbumsSelect
  constructor: ->
    @setEventHandlers()

  setEventHandlers: ->
    $(document).on "click", "[data-behavior~=album-search-link]", @searchClick
    $(document).on "click", "[data-behavior~=album-filter-link]", @filterClick

  searchClick: (event) =>
    if $("[data-behavior~=album-search-form]").is(":hidden")
      $("[data-behavior~=album-letter-picker]").hide()
    else
      $("[data-behavior~=album-letter-picker]").show()
    $("[data-behavior~=album-filter-form]").slideUp(250)
    $("[data-behavior~=album-search-form]").slideToggle(250, @searchFocus)

  searchFocus: ->
    $("[data-behavior~=album-search-field]").focus()

  filterClick: (event) ->
    if $("[data-behavior~=album-filter-form]").is(":hidden")
      $("[data-behavior~=album-letter-picker]").hide()
    else
      $("[data-behavior~=album-letter-picker]").show()
    $("[data-behavior~=album-search-form]").slideUp(250)
    $("[data-behavior~=album-filter-form]").slideToggle()

jQuery ->
  new App.AlbumsSelect()
