class AddFieldsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :country, :string
    add_column :users, :has_disability, :boolean
    add_column :users, :indigenous_town, :string
    add_column :users, :where_do_you_live, :string
    add_column :users, :sexual_orientation, :string
  end
end
