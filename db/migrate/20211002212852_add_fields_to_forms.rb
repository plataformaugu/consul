class AddFieldsToForms < ActiveRecord::Migration[5.2]
  def change
    add_column :forms, :q31, :string, null: true
    add_column :forms, :q32, :string, null: true
    add_column :forms, :q32o, :string, null: true
    add_column :forms, :q33, :string, null: true
    add_column :forms, :q34, :string, null: true
    add_column :forms, :q34o, :string, null: true
    add_column :forms, :q4, :string, null: true
  end
end
