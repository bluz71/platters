class AlbumForm
  constructor: ->
    @setEventHandlers()
    @errorSet = false

  setEventHandlers: ->
    $(document).on "change", "#album_cover", @coverSize

  coverSize: (event) ->
    size_in_megabytes = @files[0].size / 1024 / 1024
    if size_in_megabytes > 2
      $("[data-behavior~=album-form-errors]").append(
        """<li class='list-group-item list-group-item-danger' data-behavior='album-form-error'>
             Maximum cover size allowed is 2MB. Please choose a smaller cover
           </li>""")
      $("[data-behavior~=album-cover]").addClass("has-error")
    else
      $("[data-behavior~=album-form-error]:contains('Maximum cover size allowed is 2MB')").remove()
      $("[data-behavior~=album-cover]").removeClass("has-error")

jQuery ->
  new AlbumForm()
