class CreateJoinTableSegmentationsSectors < ActiveRecord::Migration[5.2]
  def change
    create_join_table :segmentations, :sectors do |t|
      # t.index [:segmentation_id, :sector_id]
      # t.index [:sector_id, :segmentation_id]
    end
  end
end
