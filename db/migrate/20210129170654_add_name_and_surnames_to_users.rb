class AddNameAndSurnamesToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :surnames, :string, null: true
  end
end
