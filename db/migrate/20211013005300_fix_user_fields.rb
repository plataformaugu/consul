class FixUserFields < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :disability, :string, null: true
    add_column :users, :comuna, :string, null: true
    add_column :users, :sexual_orientation, :string, null: true
  end
end
