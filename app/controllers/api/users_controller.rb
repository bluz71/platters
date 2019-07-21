# frozen_string_literal: true

class Api::UsersController < ApplicationController
  before_action :set_user, only: [:update, :destroy]
  before_action :check_honeypot, only: [:create]

  def create
    @user = user_from_params
    @user.email_confirmation_token = Clearance::Token.new

    if @user.save
      application_host = params[:user][:application_host]
      ApiMailer.email_confirmation(@user, application_host).deliver_later
      head :ok
    else
      render json: {errors: @user.errors.full_messages}, status: :not_acceptable
    end
  end

  def update
    @user.slug = nil
    if @user.update(update_params)
      # Create and ship a new authorization token whilst making sure NEVER to
      # extend token refresh expiry. We do that since a bad-actor may have
      # hijacked someone's account, for instance via a lost or stolen laptop,
      # hence we only allow extension of the refresh expiry via full logins or
      # email-based password changes, and not via this means.
      auth_token = ApiAuth.encode(@user, @user.api_token_refresh_expiry)
      render json: {auth_token: auth_token}
    else
      render json: {errors: @user.errors.full_messages}, status: :not_acceptable
    end
  end

  def destroy
    @user.destroy
    head :ok
  end

  private

  def set_user
    @user = User.friendly.find(params[:id])

    # Affirm that the request user matches the JWT authenticated user. This is
    # needed to prevent bad actors spoofing other users.
    head :bad_request if @user != current_user
  rescue ActiveRecord::RecordNotFound
    head :not_found
  end

  def update_params
    params.require(:user).permit(:name, :password)
  end

  def user_from_params
    user          = User.new
    user.email    = params[:user][:email].downcase.strip
    user.password = params[:user][:password]
    user.name     = params[:user][:name]
    user
  end

  def check_honeypot
    head :forbidden if params[:user][:username].present?
  end
end
