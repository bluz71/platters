class App.ArtistForm
  constructor: ->
    @setEventHandlers()
    @nameError = false

  setEventHandlers: ->
    $(document).on "blur", "#artist_name", @nameBlur
    $(document).on "focus", "#artist_name", @nameFocus

  nameBlur: (event) =>
    artistName = $("#artist_name").val()
    if !@nameError && artistName.length == 0
      $("[data-behavior~=artist-form-errors]").append(
        """<li class='list-group-item list-group-item-danger' data-behavior='artist-form-error'>
             Name can't be blank
           </li>""")
      $("[data-behavior~=artist-name]").addClass("has-error")
      @nameError = true

  nameFocus: (event) =>
    if @nameError
      $("[data-behavior~=artist-form-error]:contains('Name can\\'t be blank')").remove()
      $("[data-behavior~=artist-name]").removeClass("has-error")
      @nameError = false

jQuery ->
  new App.ArtistForm()
