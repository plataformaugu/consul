class CreateMainThemes < ActiveRecord::Migration[5.2]
  def change
    create_table :main_themes do |t|
      t.string :name
      t.text :description, null: true
      t.string :primary_color, null: true
      t.string :secondary_color, null: true
      t.string :icon, null: true
      t.string :image, null: true
      t.string :extra_image, null: true

      t.timestamps
    end

    add_reference :polls, :main_theme, index: true
    add_reference :proposals, :main_theme, index: true
  end
end
