Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  #config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Asset digests allow you to set far-future HTTP expiration dates on all assets,
  # yet still be able to expire them through the digest params.
  config.assets.digest = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  ##
  ## Customizations.
  ##

  # Use Sidekiq for asynchronous job processing.
  config.active_job.queue_adapter = :sidekiq

  # Bullet configuration, look for N+1 queries and report.
  config.after_initialize do
	Bullet.enable = true
	Bullet.console = true
	Bullet.rails_logger = true
	Bullet.add_footer = true
    Bullet.add_whitelist(type: :n_plus_one_query, class_name: "Comment", association: :commentable)
    Bullet.add_whitelist(type: :unused_eager_loading, class_name: "Comment", association: :commentable)
    Bullet.add_whitelist(type: :unused_eager_loading, class_name: "Comment", association: :user)
    Bullet.add_whitelist(type: :n_plus_one_query, class_name: "Album", association: :artist)
  end

  # Enable caching in the development environment.
  config.action_controller.perform_caching = false

  # Default host for Action Mailer.
  host = "localhost:3000"
  config.action_mailer.default_url_options = {host: host}

  # Simple Rails log rotation. Up to two 50MB-sized log chunks, 1 current
  # and 1 old will be kept.
  config.logger = ActiveSupport::Logger.new(config.paths["log"].first,
                                            1, 50 * 1024 * 1024)
end
