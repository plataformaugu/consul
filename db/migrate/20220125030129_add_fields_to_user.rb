class AddFieldsToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :maiden_name, :string
    add_column :users, :street, :string
    add_column :users, :house_number, :string
    add_column :users, :house_apartment, :string
    add_column :users, :house_block, :string
  end
end
