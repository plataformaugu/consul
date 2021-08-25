class ChangeUsersFields < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :nationality, :text
    change_column :users, :region, :text
    change_column :users, :education, :text
    change_column :users, :indigenous, :text
  end
end
