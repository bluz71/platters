# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Clearance::Controller
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

    def require_admin
      unless signed_in? && current_user.admin?
        deny_access("Administrator log in is required to continue")
      end
    end
end
