# The test environment is used exclusively to run your application's
# test suite. You never need to work with it otherwise. Remember that
# your test database is "scratch space" for the test suite and is wiped
# and recreated between test runs. Don't rely on the data there!

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  config.cache_classes = false

  # Do not eager load code on boot. This avoids loading your whole application
  # just for the purpose of running a single test. If you are using a tool that
  # preloads Rails for running tests, you may have to set it to true.
  config.eager_load = false

  # Configure public file server for tests with Cache-Control for performance.
  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    'Cache-Control' => "public, max-age=#{1.hour.to_i}"
  }

  # Show full error reports and disable caching.
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false
  config.cache_store = :null_store

  # Raise exceptions instead of rendering exception templates.
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment.
  config.action_controller.allow_forgery_protection = false
  config.action_mailer.perform_caching = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

  # Print deprecation notices to the stderr.
  config.active_support.deprecation = :stderr

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  ##
  ## Customizations.
  ##

  # All jobs, such as emailing, should run inline when in test mode.
  config.active_job.queue_adapter = :test

  # Default host for Action Mailer.
  host = "localhost:3000"
  config.action_mailer.default_url_options = {host: host}

  # Sign in as a designated user.
  config.middleware.use Clearance::BackDoor

  # Simple Rails log rotation. Up to two 10MB-sized log chunks, 1 current
  # and 1 old will be kept.
  config.logger = ActiveSupport::Logger.new(config.paths["log"].first,
                                            1, 10 * 1024 * 1024)

  # Automatically link labels and form elements by ID in form_with.
  # Reference: https://github.com/rails/rails/pull/29439
  config.action_view.form_with_generates_ids = true
end
