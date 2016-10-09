# frozen_string_literal: true

class UsersController < Clearance::UsersController
  def create
    @user = user_from_params

    if @user.save
      sign_in @user
      flash[:notice] = "Welcome #{@user.email}, you have signed up successfully"
      redirect_back_or url_after_create
    else
      flash.now[:alert] = "Account could not be created"
      render template: "users/new"
    end
  end
end
