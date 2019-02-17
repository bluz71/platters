# frozen_string_literal: true

class Api::PasswordsController < ApplicationController
  before_action :set_user, only: [:update]

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
    @user.password = change_params[:password]
    if @user.save
      # Create a ship a new authorization token.
      auth_token = ApiAuth.encode(user: @user.id,
                                  email: @user.email,
                                  name: @user.name,
                                  slug: @user.slug,
                                  admin: @user.admin?)
      render json: {auth_token: auth_token}
    else
      head :not_acceptable
    end
  end

private

  def set_user
    @user = User.friendly.find(params[:user_id])

    # Affirm that the supplied confirmation token matches the database
    # confirmation token.
    head :bad_request if change_params[:token].to_s != @user.confirmation_token
  rescue ActiveRecord::RecordNotFound
    head :not_found
  end

  def reset_params
    params.require(:password_reset).permit(:email_address, :application_host)
  end

  def change_params
    params.require(:password_change).permit(:password, :token)
  end
end
