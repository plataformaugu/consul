class AddIsTarjetaVecinoActiveToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :is_tarjeta_vecino_active, :boolean, :default => false
  end
end
