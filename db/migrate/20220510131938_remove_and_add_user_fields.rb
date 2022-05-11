class RemoveAndAddUserFields < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :house_apartment
    remove_column :users, :street
    add_column :users, :address, :string
  end
end
