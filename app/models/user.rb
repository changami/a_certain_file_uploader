class User < ActiveRecord::Base
  has_many :upload_files, :class_name => 'UploadFile', :dependent => :destroy
  has_many :operation_histories, :dependent => :destroy

  has_secure_password
end
