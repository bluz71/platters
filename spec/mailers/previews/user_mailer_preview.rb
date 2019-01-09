# Preview all emails at http://localhost:3000/rails/mailers
class AppMailerPreview < ActionMailer::Preview
  # Preview this email at:
  #   http://localhost:3000/rails/mailers/app_mailer/email_confirmation
  def email_confirmation
    UserMailer.email_confirmation(User.last)
  end

  # Preview this email at:
  #   http://localhost:3000/rails/mailers/app_mailer/change_password
  def change_password
    ClearanceMailer.change_password(User.last)
  end
end
