class ApplicationMailer < ActionMailer::Base
  default from: ENV["MAILGUN_SMTP_LOGIN"],
          reply_to: ENV["CONTACT_EMAIL"]
  layout "mailer"
end
