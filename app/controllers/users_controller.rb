# frozen_string_literal: true

class UsersController < Clearance::UsersController
  before_action :require_login, only: [:edit, :update, :destroy]
  before_action :set_user, only: [:edit, :update]

  def create
    @user = user_from_params

    if @user.save
      sign_in @user
      flash[:notice] = "Welcome #{@user.name}, you have signed up successfully"
      redirect_back_or url_after_create
    else
      flash.now[:alert] = "Account could not be created"
      render "users/new"
    end
  end

  def edit
  end

  def update
    if @user.update(params.require(:user).permit(:name, :password))
      flash[:notice] = "Your account has been updated"
      redirect_to root_path
    else
      flash.now[:alert] = "Your account could not be updated"
      render "edit"
    end
  end

  def destroy
    user = current_user
    sign_out
    user.destroy
    flash[:notice] = "#{user.name} account has been deleted"
    redirect_to root_path
  end

  private

    def user_from_params
      name = user_params.delete(:name)
      email = user_params.delete(:email)
      password = user_params.delete(:password)

      Clearance.configuration.user_model.new(user_params).tap do |user|
        user.name = name
        user.email = email
        user.password = password
      end
    end

    def set_user
      @user = User.find(params[:id])
      if @user != current_user
        flash[:alert] = "You can only access your own account"
        redirect_to root_path
      end
    end
end
