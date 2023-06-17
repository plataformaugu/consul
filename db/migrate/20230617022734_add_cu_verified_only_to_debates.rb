class AddCuVerifiedOnlyToDebates < ActiveRecord::Migration[6.0]
  def change
    add_column :debates, :cu_verified_only, :boolean, null: false, default: false
  end
end
