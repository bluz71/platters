# frozen_string_literal: true

class Api::PasswordsController < ApplicationController
  def create
    user = User.find_by(email: reset_params[:email_address].downcase.strip)
    if user
      user.forgot_password!
      application_host = reset_params[:application_host]
      ApiMailer.change_password(user, application_host).deliver_later
      head :ok
    else
      head :not_found
    end
  end

  def update
    @user = find_user
  end

private

  def reset_params
    params.require(:password_reset).permit(:email_address, :application_host)
  end

  def change_params
    params.require(:password_change).permit(:password, :token)
  end

  def find_user
    user = User.friendly.find(change_params[:password])
    change_token = change_params[:token]

    # Confirm that the supplied confirmation token matches the database
    # confirmation token.
    head :bad_request if change_token.to_s != user.confirmation_token

    user
  rescue ActiveRecord::RecordNotFound
    head :not_found
  end
end
