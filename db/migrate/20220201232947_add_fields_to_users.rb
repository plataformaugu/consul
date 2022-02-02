class AddFieldsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :civil_status, :string
    add_column :users, :profession, :string
    add_column :users, :occupation, :string
    add_column :users, :prevision, :string
    add_column :users, :children_amount, :integer
    add_column :users, :pets_amount, :integer
  end
end
