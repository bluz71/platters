# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Clearance::Controller
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception, unless: -> { request.format.json? }
  # XXX, extract JWT for every API action.
  # before_action :extract_auth_token, if: -> { request.format.json? }

  private

    # Needed to handle dual-authentication: cookie-based for HTML access using
    # the Clearance Gem and JWT-based for API access using custom application
    # code.
    alias clearance_current_user current_user
    alias clearance_signed_in? signed_in?

    def current_user
      if request.format.json?
        # XXX, EXTRACT JWT token and lookup user.
        # Do early exit if no JWT exists in the request.
        # Memoize @api_user to save DB access.
      end
      clearance_current_user
    end

    def signed_in?
      current_user.present? if request.format.json?
      clearance_signed_in?
    end

    def require_admin
      return if signed_in? && current_user.admin?

      # XXX, API request may require a :forbidden HTTP response.
      deny_access("Administrator rights are required for this action")
    end
end
