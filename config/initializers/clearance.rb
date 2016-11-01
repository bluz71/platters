class ConfirmedUserGuard < Clearance::SignInGuard
  def call
    if confirmed?
      next_guard
    else
      failure("Incorrect log in credentials, or unconfirmed email address.")
    end
  end

  def confirmed?
    signed_in? && current_user.email_confirmed_at.present?
  end
end

Clearance.configure do |config|
  config.routes = false
  config.mailer_sender = ENV["MAILER_SENDER"]
  config.sign_in_guards = [ConfirmedUserGuard]
end
