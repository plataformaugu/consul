class AddCuConfirmedAtToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :cu_confirmed_at, :datetime, null: true
  end
end
