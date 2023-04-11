class AddTvUpdatedAtToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :tarjeta_vecino_updated_at, :date, null: true
  end
end
