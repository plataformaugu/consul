class CreatePollSectors < ActiveRecord::Migration[5.2]
  def change
    add_reference :polls, :sector, index: true

    create_table :poll_sectors do |t|
      t.references :poll, null: false, foreign_key: true
      t.references :sector, null: false, foreign_key: true
    end
  end
end
