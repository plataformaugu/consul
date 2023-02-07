class CreateNeighborhoodCouncilEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :neighborhood_council_events do |t|
      t.string :name
      t.string :place
      t.string :email
      t.string :phone_number
      t.references :neighborhood_council, foreign_key: true
      t.references :event, foreign_key: true

      t.timestamps
    end
  end
end
