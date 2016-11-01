class UserMailer < ApplicationMailer
  def email_confirmation(user)
    @user = user

    mail(to: @user.email, subject: "Platters email confirmation")
  end
end
