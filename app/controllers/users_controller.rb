# frozen_string_literal: true

class UsersController < Clearance::UsersController
  before_action :require_login, only: [:edit, :update, :destroy]
  before_action :set_user, only: [:edit, :update]
  invisible_captcha only: [:create], honeypot: :username, on_spam: :bot_detected

  # Differs from the Clearance default due to email confirmation in the success
  # path and the use of the flash in both success and failure paths.
  def create
    @user = user_from_params
    @user.email_confirmation_token = Clearance::Token.new

    if @user.save
      UserMailer.email_confirmation(@user).deliver_later
      # Note, using flash[:success], rather than the usual flash[:notice],
      # since we don't want the flash auto-hide behaviour defined in
      # app/javascript/packs/application.js
      flash[:success] =
        "Hello #{@user.name}, in order to complete your sign up, please follow "\
        "the instructions in the email that was just sent to you. Please check "\
        "your junk folder if you can not find the email."
      redirect_back_or url_after_create
    else
      flash.now[:alert] = "Account could not be created"
      render "users/new"
    end
  end

  # Clearance by default does not provide edit user functionality.
  def edit
  end

  # Clearance by default does not provide update user functionality.
  def update
    @user.slug = nil
    if @user.update(params.require(:user).permit(:name, :password))
      flash[:notice] = "Your account has been updated"
      redirect_to root_path
    else
      flash.now[:alert] = "Your account could not be updated"
      render "edit"
    end
  end

  # Clearance by default does not provide delete user functionality.
  def destroy
    user = current_user
    sign_out
    user.destroy
    flash[:notice] = "#{user.name} account has been deleted"
    redirect_to root_path
  end

  private

  # Differs from the Clearance default version due to "name" and
  # invisible_captcha honeypot fields.
  def user_from_params
    name = user_params.delete(:name)
    email = user_params.delete(:email)
    password = user_params.delete(:password)
    user_params.delete(:username) # Remove the honeypot field.

    Clearance.configuration.user_model.new(user_params).tap do |user|
      user.name = name
      user.email = email
      user.password = password
    end
  end

  def set_user
    @user = User.friendly.find(params[:id])
    return if @user == current_user

    flash[:alert] = "You can only access your own account"
    redirect_to root_path
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "The user '#{params[:id]}' does not exist"
    redirect_to root_path
  end

  def bot_detected
    flash[:alert] = "Bot detected"
    redirect_to root_path
  end
end
