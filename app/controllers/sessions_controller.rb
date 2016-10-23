# frozen_string_literal: true

class SessionsController < Clearance::SessionsController
  # Uses alert flash in the failure path which differs from the Clearance
  # default.
  def create
    @user = authenticate(params)

    sign_in(@user) do |status|
      if status.success?
        redirect_back_or url_after_create
      else
        flash.now[:alert] = status.failure_message
        render "sessions/new", status: :unauthorized
      end
    end
  end
end
