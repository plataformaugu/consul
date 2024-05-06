class CreateSegmentations < ActiveRecord::Migration[6.0]
  def change
    create_table :segmentations do |t|
      t.string :entity_name
      t.integer :entity_id
      t.string :age_type
      t.string :geo_type
      t.boolean :in_census, default: false

      t.timestamps
    end

    add_index :segmentations, [:entity_name, :entity_id], unique: true

    create_table :gender_segmentations do |t|
      t.references :segmentation, foreign_key: true
      t.string :gender

      t.timestamps
    end

    create_table :age_segmentations do |t|
      t.references :segmentation, foreign_key: true
      t.integer :age

      t.timestamps
    end

    create_table :age_range_segmentations do |t|
      t.references :segmentation, foreign_key: true
      t.integer :min_age
      t.integer :max_age

      t.timestamps
    end

    create_join_table :segmentations, :sectors do |t|
      # t.index [:segmentation_id, :sector_id]
      # t.index [:sector_id, :segmentation_id]
    end
  end
end
