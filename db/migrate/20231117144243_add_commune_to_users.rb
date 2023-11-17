class AddCommuneToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :commune, :string
  end
end
