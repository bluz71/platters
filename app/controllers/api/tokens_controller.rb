# frozen_string_literal: true

class Api::TokensController < ApplicationController
  before_action :require_login
  before_action :confirm_token

  def new
    auth_token = ApiAuth.encode(current_user)
    render json: {auth_token: auth_token}
  end

private

  def require_login
    # Tokens are short-lived, it is possible that a user will request a new
    # token after their current token has expired, hence, we should allow
    # expired signatures here (and here only).
    api_token_allow_expired_signature
    head :bad_request unless signed_in?
  end

  def confirm_token
    if !api_token ||
       api_token["refreshExp"] != current_user.api_token_refresh_expiry.to_i ||
       Time.current.utc + 90.seconds > current_user.api_token_refresh_expiry
      # Abort token refreshing if:
      #  - There is no token provided with the request
      #  - Token refresh expiry does not match value stored in the database
      #  - Token has expired or is about to expire
      head :unauthorized
    end
  end
end
