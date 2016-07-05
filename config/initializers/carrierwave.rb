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
  elsif Rails.env.test?
    config.storage = :file
    config.enable_processing = false
    config.root = Rails.root.join("spec")
  else
    config.storage = :file
  end
end
