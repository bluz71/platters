class AlbumForm
  constructor: ->
    @setEventHandlers()
    @errorSet = false
    console.log "In AlbumForm"

  setEventHandlers: ->
    $(document).on "change", "#album_cover", @coverSize

  coverSize: (event) ->
    size_in_kilobytes = @files[0].size / 1024
    alert("Maximum cover size allowed is 1MB. Please choose a smaller cover") if size_in_kilobytes > 1000

jQuery ->
  new AlbumForm()
