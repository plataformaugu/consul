class AddHouseTypeToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :house_type, :string
  end
end
