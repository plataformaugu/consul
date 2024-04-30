class AddGeoFieldsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :street_name, :string
    add_column :users, :house_number, :string
    add_column :users, :latitude, :decimal, :precision => 15, :scale => 13
    add_column :users, :longitude, :decimal, :precision => 15, :scale => 13
  end
end
