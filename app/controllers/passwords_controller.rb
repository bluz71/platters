# frozen_string_literal: true

class PasswordsController < Clearance::PasswordsController
  private

    # User lookup is FriendID'd, hence we need to find user by name and not id.
    def find_user_by_id_and_confirmation_token
      user_param = Clearance.configuration.user_id_parameter
      token = session[:password_reset_token] || params[:token]

      Clearance.configuration.user_model.
        find_by_name_and_confirmation_token params[user_param], token.to_s
    end
end
