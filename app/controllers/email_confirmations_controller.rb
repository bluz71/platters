# frozen_string_literal: true

class EmailConfirmationsController < ApplicationController
  def update
    user = User.find_by(name: params[:name], email_confirmation_token: params[:token])
    if user.present?
      user.confirm_email
      sign_in user
      flash[:notice] = "Welcome #{user.name}, you have now completed the sign up process"
      redirect_to root_path
    else
      flash[:alert] = "Email confirmation details are invalid"
      redirect_to root_path
    end
  end
end
