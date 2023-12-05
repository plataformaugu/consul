class ReapplyMigrationToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :balloted_heading_id, :integer, default: nil unless column_exists?(:users, :balloted_heading_id)
  end
end
