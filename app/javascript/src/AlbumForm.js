class AlbumForm {
  constructor() {
    this.setEventHandlers();
    this.titleError = false;
  }

  setEventHandlers() {
    $(document).on('blur', '[name="album[title]"]', this.titleBlur);
    $(document).on('focus', '[name="album[title]"]', this.titleFocus);
    $(document).on('change', '[name="album[cover]"]', this.coverChange);
  }

  titleBlur = (event) => {
    const albumTitle = $('[name="album[title]"]').val();
    if (!this.titleError && albumTitle.length == 0) {
      $('[data-behavior~=album-form-errors]').append(
        `<li class='list-group-item list-group-item-danger' data-behavior='album-form-error'>
           Title can't be blank
         </li>`
      );
      $('[data-behavior~=album-title]').addClass('has-error');
      this.titleError = true;
    }
  }

  titleFocus = (event) => {
    if (this.titleError) {
      $(
        '[data-behavior~=album-form-error]:contains("Title can\'t be blank")'
      ).remove();
      $('[data-behavior~=album-title]').removeClass('has-error');
      this.titleError = false;
    }
  }

  coverChange(event) {
    // Clear out any cached cover images.
    $('[data-behavior~=cover-image]').remove();

    // Make sure cover is 2MB or less.
    const sizeInMegabytes = this.files[0].size / 1024 / 1024;
    if (sizeInMegabytes > 2) {
      $('[data-behavior~=album-form-errors]').append(
        `<li class='list-group-item list-group-item-danger' data-behavior='album-form-error'>
           Maximum cover size allowed is 2MB. Please choose a smaller cover
         </li>`
      );
      $('[data-behavior~=album-cover]').addClass('has-error');
    } else {
      $(
        '[data-behavior~=album-form-error]:contains("Maximum cover size allowed is 2MB")'
      ).remove();
      $('[data-behavior~=album-cover]').removeClass('has-error');
    }
  }
}

export default AlbumForm;
