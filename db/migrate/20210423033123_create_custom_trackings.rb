class CreateCustomTrackings < ActiveRecord::Migration[5.2]
  def change
    create_table :custom_trackings do |t|
      t.string :page
      t.integer :count

      t.timestamps
    end
  end
end
