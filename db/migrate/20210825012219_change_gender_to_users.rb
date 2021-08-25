class ChangeGenderToUsers < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :gender, :string, :limit => 55
  end
end
