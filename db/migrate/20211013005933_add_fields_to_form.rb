class AddFieldsToForm < ActiveRecord::Migration[5.2]
  def change
    add_column :forms, :q42, :string, null: true
    add_column :forms, :q43, :string, null: true
  end
end
