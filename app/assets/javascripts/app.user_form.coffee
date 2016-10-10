class App.UserForm
  constructor: ->
    @setEventHandlers()
    @nameError = false
    @validNameRe = /^[\w-]+$/

  setEventHandlers: ->
    $(document).on "blur", "#user_name", @nameBlur
    $(document).on "focus", "#user_name", @nameFocus

  nameBlur: (event) =>
    username = $("#user_name").val()
    if !@nameError && (username.length < 4 || username.length > 20)
      $("[data-behavior~=user-form-errors]").append(
        """<li class='list-group-item list-group-item-danger' data-behavior='user-form-error'>
             Account name must be between 4 and 20 characters long
           </li>""")
      $("[data-behavior~=user-name]").addClass("has-error")
      @nameError = true
    if !@nameError && (!username.match(@validNameRe))
      $("[data-behavior~=user-form-errors]").append(
        """<li class='list-group-item list-group-item-danger' data-behavior='user-form-error'>
             Account name must contain only letters, digits and hypens
           </li>""")
      $("[data-behavior~=user-name]").addClass("has-error")
      @nameError = true

  nameFocus: (event) =>
    if @nameError
      $("[data-behavior~=user-form-error]").remove()
      $("[data-behavior~=user-name]").removeClass("has-error")
      @nameError = false

jQuery ->
  new App.UserForm()
