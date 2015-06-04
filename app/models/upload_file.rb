class UploadFile < ActiveRecord::Base
  belongs_to :user, :foreign_key => 'owner_id'

  before_validation :set_uuid

  validates :filename, :presence => true
  validates :uuid, :presence => true, :uniqueness => true

  private
  def set_uuid
    self.uuid = SecureRandom.uuid
  end
end
