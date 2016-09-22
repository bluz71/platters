require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Platters
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    ##
    ## Customizations.
    ##

    # Use Sidekiq for asynchronous job processing.
    config.active_job.queue_adapter = :sidekiq

    # Simple Rails log rotation. Up to four 100MB-sized log chunks, 1 current
    # and 3 old, will be kept.
    config.logger = ActiveSupport::Logger.new(config.paths["log"].first,
                                              3, 100 * 1024 * 1024)
    # Use Redis for caching, make sure 'db_number' (0 in this case) does not
    # conflict with the Sidekiq Redis db_number (see initializers/sidekiq.rb).
    config.cache_store = :redis_store, "#{ENV["REDIS_PROVIDER"]}/0/cache", { expires_in: 1.day }
  end
end
