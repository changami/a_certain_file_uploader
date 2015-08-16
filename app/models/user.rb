class User < ActiveRecord::Base
  has_many :upload_files, :class_name => 'UploadFile', :dependent => :destroy

  has_secure_password

  def space_quota
    if self.quota.present?
      self.quota
    else
      ACertainFileUploader::Application.config.default_space_quota
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
