# Be sure to restart your server when you modify this file.

# Set File Upload Directory Path
begin
  # parse environment configuration path
  Rails.application.config.upload_dir = File.expand_path(Rails.application.config.upload_dir, Rails.root)
rescue NoMethodError
  # set default path
  Rails.application.config.upload_dir = File.join(Rails.root, 'public/uploads')
end
