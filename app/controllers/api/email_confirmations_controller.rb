# frozen_string_literal: true

class Api::EmailConfirmationsController < ApplicationController
  def update
    user = User.find_by(name: params[:name],
                        email_confirmation_token: params[:token])
    if user.present?
      user.confirm_email
      # User is confirmed, create and ship a new token with new refresh
      # expiry.
      auth_token = ApiAuth.encode(user)
      render json: {auth_token: auth_token}
    else
      head :not_acceptable
    end
  end
end
