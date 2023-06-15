class CreateAgeRangeSegmentations < ActiveRecord::Migration[5.2]
  def change
    create_table :age_range_segmentations do |t|
      t.references :segmentation, foreign_key: true
      t.integer :min_age
      t.integer :max_age

      t.timestamps
    end
  end
end
