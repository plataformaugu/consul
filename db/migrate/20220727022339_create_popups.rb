class CreatePopups < ActiveRecord::Migration[5.2]
  def change
    create_table :popups do |t|
      t.string :image
      t.string :url
      t.boolean :is_active

      t.timestamps
    end
  end
end
