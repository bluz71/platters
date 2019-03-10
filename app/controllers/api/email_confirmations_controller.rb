# frozen_string_literal: true

class Api::EmailConfirmationsController < ApplicationController
  def update
    user = User.find_by(name: params[:name],
                        email_confirmation_token: params[:token])
    if user.present?
      user.confirm_email
      # User is confirmed, create and ship a new authorization token.
      auth_token = ApiAuth.encode(user: user.id,
                                  email: user.email,
                                  name: user.name,
                                  slug: user.slug,
                                  admin: user.admin?)
      render json: {auth_token: auth_token}
    else
      head :not_acceptable
    end
  end
end
