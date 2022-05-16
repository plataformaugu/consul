class RemoveHouseNumberFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :house_number
  end
end
