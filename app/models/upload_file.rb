class UploadFile < ActiveRecord::Base
  belongs_to :user, :foreign_key => 'owner_id'

  validates :filename, :presence => true
  validates :extension, :presence => true
end
