# frozen_string_literal: true

class UsersController < Clearance::UsersController
  def create
    @user = user_from_params

    if @user.save
      sign_in @user
      flash[:notice] = "Welcome #{@user.name}, you have signed up successfully"
      redirect_back_or url_after_create
    else
      flash.now[:alert] = "Account could not be created"
      render template: "users/new"
    end
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
end
