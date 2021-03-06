# encoding: utf-8

class TeamLogoUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    if ENV['LOCAL_STORAGE']
      "uploads/team_logo/#{model.id}"
    else
      Rails.env.production? ? "team_logo/#{model.id}" : "#{Rails.env}/team_logo/#{model.id}"
    end
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  def scale(width, height)
    process scale: [300, 300]
  end

  # Create different versions of your uploaded files:
  version :large do
    process resize_to_fill: [90, 90]
  end

  version :main do
    process resize_to_fill: [50, 50]
  end

  version :micro do
    process resize_to_fill: [20, 20]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
