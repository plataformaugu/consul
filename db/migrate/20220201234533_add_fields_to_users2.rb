class AddFieldsToUsers2 < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :neighborhood_unit, :string
    add_column :users, :nationality, :string
  end
end
