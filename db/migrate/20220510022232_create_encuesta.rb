class CreateEncuesta < ActiveRecord::Migration[5.2]
  def change
    create_table :encuesta do |t|
      t.string :name
      t.text :description
      t.string :image
      t.text :code

      t.timestamps
    end
  end
end
