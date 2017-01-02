# Use Redis for caching, make sure 'db_number' (0 in this case) does not
# conflict with the Sidekiq Redis db_number (see initializers/sidekiq.rb).
Rails.application.config.cache_store = :redis_store, "#{ENV["REDIS_PROVIDER"]}/0/cache", { expires_in: 1.day }

