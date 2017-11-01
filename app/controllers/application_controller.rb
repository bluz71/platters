# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Clearance::Controller
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception, unless: -> { request.format.json? }

  private

    def require_admin
      return if signed_in? && current_user.admin?

      deny_access("Administrator rights are required for this action")
    end
end
