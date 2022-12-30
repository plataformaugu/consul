class CreateDirectives < ActiveRecord::Migration[5.2]
  def change
    create_table :directives do |t|
      t.string :full_name
      t.string :position
      t.string :profession
      t.string :email
      t.string :phone_number
      t.references :neighborhood_council, foreign_key: true

      t.timestamps
    end
  end
end
