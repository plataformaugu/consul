class CreatePolygonSegmentations < ActiveRecord::Migration[5.2]
  def change
    create_table :polygon_segmentations do |t|
      t.references :segmentation, foreign_key: true
      t.text :coordinates, array: true, default: []

      t.timestamps
    end
  end
end
