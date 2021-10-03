class RemoveUnusedFormFields < ActiveRecord::Migration[5.2]
  def change
    remove_column :forms, :q3
    remove_column :forms, :q41
    remove_column :forms, :q42
    remove_column :forms, :q43
    remove_column :forms, :q5
  end
end
