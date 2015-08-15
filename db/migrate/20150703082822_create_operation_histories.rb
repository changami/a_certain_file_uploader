class CreateOperationHistories < ActiveRecord::Migration
  def change
    create_table :operation_histories do |t|
      t.references :user, index: true, null: false
      t.integer :operation, default: 0, null: false
      t.string :filename
      t.references :upload_file, index: true

      t.timestamps
    end
  end
end
