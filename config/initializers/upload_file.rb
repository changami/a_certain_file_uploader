# Be sure to restart your server when you modify this file.

Rails.application.configure do
  # Set File Upload Directory Path
    begin
      # parse environment configuration path
      config.upload_dir = File.expand_path(config.upload_dir, Rails.root)
    rescue NoMethodError
      # set default path
      config.upload_dir = File.join(Rails.root, 'public/uploads')
    end

  # Set Space Quota
    begin
      # parse environment configuration quota
      if config.default_space_quota_mb.is_a?(Integer) == false
        config.default_space_quota_mb = config.default_space_quota_mb.to_s.to_i
      end
    rescue NoMethodError
      # set default quota
      config.default_space_quota_mb = 500 # 500MB
    end
end
