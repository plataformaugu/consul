class CreateJoinTableSegmentationsMacroTerritories < ActiveRecord::Migration[5.2]
  def change
    create_join_table :segmentations, :macro_territories do |t|
      # t.index [:segmentation_id, :macro_territory_id]
      # t.index [:macro_territory_id, :segmentation_id]
    end
  end
end
