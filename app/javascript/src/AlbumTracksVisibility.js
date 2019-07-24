class AlbumTracksVisibility {
  constructor () {
    this.setEventHandlers()
  }

  setEventHandlers () {
    $(document).on(
      'click',
      '[data-behavior~=album-show-all-tracks]',
      this.tracksVisibilityClick
    )
    $(document).on(
      'click',
      '[data-behavior~=album-show-less-tracks]',
      this.tracksVisibilityClick
    )
  }

  tracksVisibilityClick (event) {
    $('.tracks-gradient').toggle()
    $('[data-behavior~=track-toggle-visibility]')
      .toggleClass('invisible')
      .toggleClass('visible')
    $('[data-behavior~=album-show-all-tracks]').toggleClass('invisible')
    $('[data-behavior~=album-show-less-tracks]').toggleClass('invisible')
    if ($('[data-behavior~=album-show-less-tracks]').is(':hidden')) {
      const tag = $('#tracks-visibility-anchor')
      tag.get(0).scrollIntoView(false)
    }
  }
}

export default AlbumTracksVisibility
