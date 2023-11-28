class CreateAgeSegmentation < ActiveRecord::Migration[6.0]
  def change
    create_table :age_segmentations do |t|
      t.references :segmentation, foreign_key: true
      t.integer :age

      t.timestamps
    end
  end
end
