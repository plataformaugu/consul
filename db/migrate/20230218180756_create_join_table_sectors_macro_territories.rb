class CreateJoinTableSectorsMacroTerritories < ActiveRecord::Migration[5.2]
  def change
    create_join_table :sectors, :macro_territories do |t|
      # t.index [:sector_id, :macro_territory_id]
      # t.index [:macro_territory_id, :sector_id]
    end
  end
end
