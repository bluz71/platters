class App.AlbumsSelect
  constructor: ->
    @setEventHandlers()

  setEventHandlers: ->
    $(document).on "click",  "[data-behavior~=album-search-link]", @searchClick
    $(document).on "click",  "[data-behavior~=album-filter-link]", @filterClick
    $(document).on "submit", "[data-behavior~=album-filter-form]", @filterSubmit

  searchClick: (event) =>
    if $("[data-behavior~=album-search-form]").is(":hidden")
      $("[data-behavior~=album-letter-picker]").hide()
    else
      $("[data-behavior~=album-letter-picker]").show()
    $("[data-behavior~=album-filter]").slideUp(250)
    $("[data-behavior~=album-search]").slideToggle(250, @searchFocus)

  searchFocus: ->
    $("[data-behavior~=album-search-field]").focus()

  filterClick: (event) ->
    if $("[data-behavior~=album-filter]").is(":hidden")
      $("[data-behavior~=album-letter-picker]").hide()
    else
      $("[data-behavior~=album-letter-picker]").show()
    $("[data-behavior~=album-search]").slideUp(250)
    $("[data-behavior~=album-filter]").slideToggle()

  # Disable empty and default Album filter form values, doing so will declutter
  # the URL (and params hash) of unnecessary GET parameters.
  filterSubmit: (event) ->
    $("#genre").prop("disabled", true) unless $("#genre").val()
    $("#year").prop("disabled", true)  unless $("#year").val()
    $("[name=sort]").prop("disabled", true)  if $("[name=sort]:checked").val() == "title"
    $("[name=order]").prop("disabled", true) if $("[name=order]:checked").val() == "forward"



jQuery ->
  new App.AlbumsSelect()
