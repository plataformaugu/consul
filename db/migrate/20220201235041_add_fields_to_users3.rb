class AddFieldsToUsers3 < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :comuna, :string
  end
end
