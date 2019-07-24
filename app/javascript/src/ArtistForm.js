class ArtistForm {
  constructor () {
    this.setEventHandlers()
    this.nameError = false
  }

  setEventHandlers () {
    $(document).on('blur', '[name="artist[name]"]', this.nameBlur)
    $(document).on('focus', '[name="artist[name]"]', this.nameFocus)
  }

  nameBlur = event => {
    const artistName = $('[name="artist[name]"]').val()
    if (!this.nameError && artistName.length === 0) {
      $('[data-behavior~=artist-form-errors]').append(
        `<li class='list-group-item list-group-item-danger' data-behavior='artist-form-error'>
           Name can't be blank
         </li>`
      )
      $('[data-behavior~=artist-name]').addClass('has-error')
      this.nameError = true
    }
  }

  nameFocus = event => {
    if (this.nameError) {
      $(
        '[data-behavior~=artist-form-error]:contains("Name can\'t be blank")'
      ).remove()
      $('[data-behavior~=artist-name]').removeClass('has-error')
      this.nameError = false
    }
  }
}

export default ArtistForm
