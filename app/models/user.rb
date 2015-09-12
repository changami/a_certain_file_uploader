class User < ActiveRecord::Base
  has_many :upload_files, :class_name => 'UploadFile', :dependent => :destroy
  has_many :operation_histories, :dependent => :destroy

  has_secure_password

  validates :quota_mb, numericality: { only_integer: true, greater_than_or_equal_to: 0, allow_nil: true }

  def is_default_space_quota?
    self.quota_mb.blank?
  end

  def space_quota
    if self.is_default_space_quota?
      ACertainFileUploader::Application.config.default_space_quota_mb * (1024 ** 2)
    else
      self.quota_mb * (1024 ** 2)
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
