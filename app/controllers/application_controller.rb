# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Clearance::Controller
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception, unless: -> { request.format.json? }

  # Needed to handle dual-authentication: cookie-based for HTML access using
  # the Clearance Gem and JWT-based for API access using custom application
  # code.
  alias_method :clearance_current_user, :current_user
  alias_method :clearance_signed_in?, :signed_in?

  protected

    def current_user
      clearance_current_user
    end

    def signed_in?
      clearance_signed_in?
    end

  private

    def require_admin
      return if signed_in? && current_user.admin?

      deny_access("Administrator rights are required for this action")
    end
end
