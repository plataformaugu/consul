class CreateRadiusSegmentations < ActiveRecord::Migration[5.2]
  def change
    create_table :radius_segmentations do |t|
      t.references :segmentation, foreign_key: true
      t.decimal :lat, precision: 15, scale: 13
      t.decimal :long, precision: 15, scale: 13
      t.integer :meters

      t.timestamps
    end
  end
end
