class ArtistsSelect {
  constructor() {
    this.setEventHandlers();
  }

  setEventHandlers() {
    $(document).on(
      'click',
      '[data-behavior~=artist-search-link]',
      this.searchClick
    );
  }

  searchClick = (event) => {
    $('[data-behavior~=artist-letter-picker]').toggle();
    $('[data-behavior~=artist-search]').slideToggle(250, this.searchFocus);
  };

  searchFocus = () => {
    $('[data-behavior~=artist-search-field]').focus();
  };
}

export default ArtistsSelect;
