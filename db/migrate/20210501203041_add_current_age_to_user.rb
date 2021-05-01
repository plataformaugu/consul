class AddCurrentAgeToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :current_age, :integer, default: 0
  end
end
