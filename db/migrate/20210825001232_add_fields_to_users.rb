class AddFieldsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :age, :integer, null: true
    add_column :users, :nationality, :string, null: true
    add_column :users, :region, :string, null: true
    add_column :users, :education, :string, null: true
    add_column :users, :indigenous, :string, null: true
    add_column :users, :disability, :boolean, null: true
  end
end
