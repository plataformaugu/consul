class CreateNeighborhoodCouncils < ActiveRecord::Migration[5.2]
  def change
    create_table :neighborhood_councils do |t|
      t.string :name
      t.string :address
      t.string :phone_number
      t.string :email
      t.date :conformation_date
      t.references :sector, foreign_key: true

      t.timestamps
    end
  end
end
