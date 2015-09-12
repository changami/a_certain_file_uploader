class AddQuotaMbToUser < ActiveRecord::Migration
  def change
    add_column :users, :quota_mb, :integer
  end
end
