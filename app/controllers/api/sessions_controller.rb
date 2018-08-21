# frozen_string_literal: true

class Api::SessionsController < ApplicationController
  before_action :set_user

  def create
    if @user.authenticate(auth_params[:password])
      token = ApiAuth.encode(user: user.id)
      render json: {jwt: token}
    else
      head :unauthorized
    end
  end

  private

    def set_user
      @user = User.find_by(email: auth_params[:email])
      head :not_found unless user.present? && user.email_confirmed_at.present?
    end

    def auth_params
      params.require(:user).permit(:email, :password)
    end
end
