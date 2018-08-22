# frozen_string_literal: true

class Api::SessionsController < ApplicationController
  before_action :set_user

  def create
    if @user.authenticated?(auth_params[:password])
      auth_token = ApiAuth.encode(user: @user.id, admin: @user.admin?)
      render json: {auth_token: token}
    else
      render json: {error: "Invalid password"}, status: :unauthorized
    end
  end

  private

    def set_user
      @user = User.find_by(email: auth_params[:email])
      head :not_found unless @user.present?
      head :forbidden unless @user.email_confirmed_at.present?
    end

    def auth_params
      params.require(:user).permit(:email, :password)
    end
end
