class UserForm {
  constructor () {
    this.setEventHandlers()
    this.nameError = false
    this.validNameRe = /^[\w-]+$/

    // Bind 'this' for callback functions.
    this.nameBlur = this.nameBlur.bind(this)
    this.nameFocus = this.nameFocus.bind(this)
  }

  setEventHandlers () {
    $(document).on('blur', '#user_name', this.nameBlur)
    $(document).on('focus', '#user_name', this.nameFocus)
  }

  nameBlur (event) {
    const username = $('#user_name').val()
    if (!this.nameError && (username.length < 4 || username.length > 20)) {
      $('[data-behavior~=user-form-errors]').append(
        `<li class='list-group-item list-group-item-danger' data-behavior='user-form-error'>
           Account name must be between 4 and 20 characters long
         </li>`
      )
      $('[data-behavior~=user-name]').addClass('has-error')
      this.nameError = true
    }
    if (!this.nameError && !username.match(this.validNameRe)) {
      $('[data-behavior~=user-form-errors]').append(
        `<li class='list-group-item list-group-item-danger' data-behavior='user-form-error'>
           Account name must contain only letters, digits and hypens
         </li>`
      )
      $('[data-behavior~=user-name]').addClass('has-error')
      this.nameError = true
    }
  }

  nameFocus (event) {
    if (this.nameError) {
      $('[data-behavior~=user-form-error]').remove()
      $('[data-behavior~=user-name]').removeClass('has-error')
      this.nameError = false
    }
  }
}

export default UserForm
