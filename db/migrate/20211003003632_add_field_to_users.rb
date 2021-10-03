class AddFieldToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :custom_age, :integer, null: true
  end
end
