class OperationHistory < ActiveRecord::Base
  belongs_to :user
  belongs_to :upload_file

  enum operation: { other: 0, upload: 1, remove: 2 }
end
