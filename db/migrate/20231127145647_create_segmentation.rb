class CreateSegmentation < ActiveRecord::Migration[6.0]
  def change
    create_table :segmentations do |t|
      t.string :entity_name
      t.integer :entity_id
      t.string :age_type

      t.timestamps
    end
  end
end
