class AddIdDireccionFieldToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :id_direccion, :integer
  end
end
