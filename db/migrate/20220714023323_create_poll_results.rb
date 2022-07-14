class CreatePollResults < ActiveRecord::Migration[5.2]
  def change
    create_table :poll_results do |t|
      t.json :votes_by_sector
      t.json :votes_by_gender
      t.json :votes_by_age_group
      t.references :poll, foreign_key: true

      t.timestamps
    end
  end
end
