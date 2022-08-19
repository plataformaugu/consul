class AddTvFieldsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :tarjeta_vecino_code, :string, null: true
    add_column :users, :tarjeta_vecino_start_date, :date, null: true
  end
end
