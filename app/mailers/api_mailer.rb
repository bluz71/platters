class ApiMailer < ApplicationMailer
  def change_password(user, application_host)
    @user             = user
    @application_host = application_host

    mail(to: @user.email, subject: "Platters change password")
  end
end
