class AddGroupToUsers < ActiveRecord::Migration[5.2]
  def change
    add_reference :users, :group, foreign_key: true
    add_column :users, :is_individual, :boolean, null: true
  end
end
