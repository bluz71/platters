Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

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

  # Use Redis for caching, make sure 'db_number' (0 in this case) does not
  # conflict with the Sidekiq Redis db_number (see initializers/sidekiq.rb).
  #
  # Use the following command to list all current Redis keys:
  #   % redis-cli --scan
  config.cache_store = :redis_store, "#{ENV['REDIS_PROVIDER']}/0/cache", { expires_in: 1.day }

  # Enable/disable caching in the development environment.
  config.action_controller.perform_caching = false

  # Default host for Action Mailer.
  host = "localhost:3000"
  config.action_mailer.default_url_options = {host: host}

  # Insert Rack::Attack into middleware. This will use the cache_store set
  # above.
  config.middleware.use Rack::Attack

  # Simple Rails log rotation. Up to two 50MB-sized log chunks, 1 current
  # and 1 old will be kept.
  config.logger = ActiveSupport::Logger.new(config.paths["log"].first,
                                            1, 50 * 1024 * 1024)
end
