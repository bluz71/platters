# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Clearance::Controller
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception, unless: -> { request.format.json? }

  private

    # Needed to handle dual-authentication: cookie-based for HTML access using
    # the Clearance Gem and JWT-based for API access using custom application
    # code.
    alias clearance_current_user current_user
    alias clearance_signed_in? signed_in?

    def current_user
      if request.format.json?
        @api_user ||= User.find(api_id_token["user"]) if api_id_token
      else
        clearance_current_user
      end
    end

    def signed_in?
      if request.format.json?
        current_user.present?
      else
        clearance_signed_in?
      end
    end

    def require_admin
      return if signed_in? && current_user.admin?

      # XXX, API request may require a :forbidden HTTP response.
      deny_access("Administrator rights are required for this action")
    end

    # API HTTP Authorization helpers.

    def api_id_token
      @api_id_token ||= api_auth_token_decode
    end

    def api_auth_token_decode
      token = api_http_auth_token
      return if token.blank?

      id_token = ApiAuth.decode(token)
      id_token if ApiAuth.valid_payload?(id_token)
    rescue JWT::ExpiredSignature
      logger.warn "Expired API token, #{token}"
      nil
    rescue JWT::DecodeError
      logger.warn "API token decode error, #{token}"
      nil
    end

    def api_http_auth_token
      auth = "Authorization"
      request.headers[auth].split(' ').last if request.headers[auth].present?
    end
end
