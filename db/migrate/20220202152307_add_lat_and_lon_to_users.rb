class AddLatAndLonToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :lat, :decimal, :precision => 15, :scale => 13
    add_column :users, :long, :decimal, :precision => 15, :scale => 13
  end
end
