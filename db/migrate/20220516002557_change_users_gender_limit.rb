class ChangeUsersGenderLimit < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :gender, :string, :limit => 20
  end
end
