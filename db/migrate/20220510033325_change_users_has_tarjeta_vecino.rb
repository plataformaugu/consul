class ChangeUsersHasTarjetaVecino < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :has_tarjeta_vecino, :boolean, :default => false
  end
end
