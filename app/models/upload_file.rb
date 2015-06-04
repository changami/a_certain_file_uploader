class UploadFile < ActiveRecord::Base
  belongs_to :user, :foreign_key => 'owner_id'

  validates :filename, :presence => true
end
