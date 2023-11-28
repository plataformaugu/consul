class CreateGenderSegmentation < ActiveRecord::Migration[6.0]
  def change
    create_table :gender_segmentations do |t|
      t.references :segmentation, foreign_key: true
      t.string :type

      t.timestamps
    end
  end
end
