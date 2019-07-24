class AlbumsSelect {
  constructor () {
    this.setEventHandlers()
  }

  setEventHandlers () {
    $(document).on(
      'click',
      '[data-behavior~=album-search-link]',
      this.searchClick
    )
    $(document).on(
      'click',
      '[data-behavior~=album-filter-link]',
      this.filterClick
    )
    $(document).on(
      'submit',
      '[data-behavior~=album-filter-form]',
      this.filterSubmit
    )
  }

  searchClick = event => {
    if ($('[data-behavior~=album-search]').is(':hidden')) {
      $('[data-behavior~=album-letter-picker]').hide()
    } else {
      $('[data-behavior~=album-letter-picker]').show()
    }
    $('[data-behavior~=album-filter]').slideUp(250)
    $('[data-behavior~=album-search]').slideToggle(250, this.searchFocus)
  }

  searchFocus = () => {
    $('[data-behavior~=album-search-field]').focus()
  }

  filterClick (event) {
    if ($('[data-behavior~=album-filter]').is(':hidden')) {
      $('[data-behavior~=album-letter-picker]').hide()
    } else {
      $('[data-behavior~=album-letter-picker]').show()
    }
    $('[data-behavior~=album-search]').slideUp(250)
    $('[data-behavior~=album-filter]').slideToggle()
  }

  // Disable empty, or default, album filter form values, doing so will
  // declutter the URL, and params hash, of unnecessary GET parameters.
  filterSubmit (event) {
    if (!$('[name=genre]').val()) {
      $('[name=genre]').prop('disabled', true)
    }
    if (!$('[name=year]').val()) {
      $('[name=year]').prop('disabled', true)
    }
    if ($('[name=sort]:checked').val() === 'title') {
      $('[name=sort]').prop('disabled', true)
    }
    if ($('[name=order]:checked').val() === 'forward') {
      $('[name=order]').prop('disabled', true)
    }
  }
}

export default AlbumsSelect
