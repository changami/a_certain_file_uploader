class User < ActiveRecord::Base
  has_many :upload_files, :class_name => 'UploadFile', :dependent => :destroy

  has_secure_password

  def is_default_space_quota?
    self.quota.blank?
  end

  def space_quota
    if self.is_default_space_quota?
      ACertainFileUploader::Application.config.default_space_quota
    else
      self.quota
    end
  end

  def space_usage
    amount = 0
    UploadFile.where(user: self).find_each do |file|
      amount += File.size?(File.join(ACertainFileUploader::Application.config.upload_dir, file.uuid))
    end
    amount
  end
end
