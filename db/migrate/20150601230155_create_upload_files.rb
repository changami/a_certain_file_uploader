class CreateUploadFiles < ActiveRecord::Migration
  def change
    create_table :upload_files do |t|
      t.integer :owner_id, :index => true
      t.string :filename
      t.string :description

      t.string :uuid, :unique => true

      t.timestamps
    end
  end
end
