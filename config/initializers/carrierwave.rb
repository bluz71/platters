module CarrierWave
  module MiniMagick
    def quality(percentage)
      manipulate! do |img|
        img.quality(percentage.to_s)
        img = yield(img) if block_given?
        img
      end
    end
  end
end

CarrierWave.configure do |config|
  if Rails.env.production?
    config.storage = :fog
    config.fog_credentials = {
      provider:           "Rackspace",
      rackspace_username: ENV["RACKSPACE_USERNAME"],
      rackspace_api_key:  ENV["RACKSPACE_API_KEY"],
      rackspace_region:   :syd
    }
    config.fog_directory = ENV["RACKSPACE_CONTAINER"]
    config.asset_host =    ENV["RACKSPACE_ASSET_HOST"]
  elsif Rails.env.test?
    config.storage = :file
    config.enable_processing = false
    config.root = Rails.root.join("spec")
  else # development
    config.storage = :file
  end
end
