class CreateJoinTableSegmentationsNeighborTypes < ActiveRecord::Migration[5.2]
  def change
    create_join_table :segmentations, :neighbor_types do |t|
      # t.index [:segmentation_id, :neighbor_type_id]
      # t.index [:neighbor_type_id, :segmentation_id]
    end
  end
end
