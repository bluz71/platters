class ApiMailer < ApplicationMailer
  def email_confirmation(user, application_host)
    @user = user
    @application_host = application_host

    mail(to: @user.email, subject: "Platters App email confirmation")
  end

  def change_password(user, application_host)
    @user = user
    @application_host = application_host

    mail(to: @user.email, subject: "Platters App change password")
  end
end
