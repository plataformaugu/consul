class AddUniqueIndexToSegmentations < ActiveRecord::Migration[5.2]
  def change
    add_index :segmentations, [:entity_name, :entity_id], unique: true
  end
end
