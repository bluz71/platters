Sidekiq.configure_server do |config|
  config.redis = { url: "#{ENV['REDIS_PROVIDER']}/12" }
end

Sidekiq.configure_client do |config|
  config.redis = { url: "#{ENV['REDIS_PROVIDER']}/12" }
end
