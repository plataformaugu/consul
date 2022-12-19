class CreateCommunes < ActiveRecord::Migration[6.0]
  def change
    create_table :communes do |t|
      t.string :name
      t.text :description
      t.references :province, foreign_key: true
      t.string :image

      t.timestamps
    end
  end
end
