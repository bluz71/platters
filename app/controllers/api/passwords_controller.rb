# frozen_string_literal: true

class Api::PasswordsController < ApplicationController
  def create
    user = User.find_by(email: password_params[:email_address].downcase.strip)
    if user
      user.forgot_password!
      application_host = password_params[:application_host]
      ApiMailer.change_password(user, application_host).deliver_later
      head :ok
    else
      head :not_found
    end
  end

private

  def password_params
    params.require(:password_reset).permit(:email_address, :application_host)
  end
end
