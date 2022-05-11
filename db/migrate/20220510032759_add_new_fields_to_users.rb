class AddNewFieldsToUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :prevision
    remove_column :users, :occupation
    remove_column :users, :house_block
    remove_column :users, :neighborhood_unit
    add_column :users, :education, :string
    add_column :users, :has_tarjeta_vecino, :boolean
    add_column :users, :house_reference, :string
  end
end
