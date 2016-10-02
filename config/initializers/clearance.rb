#class EmailConfirmationGuard < Clearance::SignInGuard
#  def call
#    if unconfirmed?
#      failure("You must confirm your email address.")
#    else
#      next_guard
#    end
#  end
#
#  def unconfirmed?
#    signed_in? && !current_user.confirmed_at
#  end
#end

Clearance.configure do |config|
  config.routes = false
  config.mailer_sender = ENV["MAILER_SENDER"]
  #config.sign_in_guards = [EmailConfirmationGuard]
end
