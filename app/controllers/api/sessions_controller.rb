# frozen_string_literal: true

class Api::SessionsController < ApplicationController
  before_action :set_user

  def create
    if @user.authenticated?(auth_params[:password])
      auth_token = ApiAuth.encode(user: @user.id,
                                  name: @user.name,
                                  admin: @user.admin?)
      render json: {auth_token: auth_token}
    else
      render json: {error: "invalid password"}, status: :unauthorized
    end
  end

private

  def set_user
    @user = User.find_by(email: auth_params[:email].downcase.strip)

    if @user.blank?
      head :not_found
    elsif @user.email_confirmed_at.blank?
      head :forbidden
    end
  end

  def auth_params
    params.require(:auth_user).permit(:email, :password)
  end
end
