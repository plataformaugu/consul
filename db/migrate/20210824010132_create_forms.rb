class CreateForms < ActiveRecord::Migration[5.2]
  def change
    create_table :forms do |t|
      t.string :q1
      t.text :q1o
      t.string :q21
      t.text :q21o
      t.string :q22
      t.text :q22o
      t.string :q23
      t.text :q23o
      t.text :q3
      t.text :q41
      t.text :q42
      t.text :q43
      t.text :q5

      t.timestamps
    end
  end
end
