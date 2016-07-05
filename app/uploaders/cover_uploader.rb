class CoverUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  process resize_to_fit: [450, 450]
  process quality: 85

  version :small do
    process resize_to_fill: [250, 250]
    process quality: 50
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_white_list
    ["jpg"]
  end
end
