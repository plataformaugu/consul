class CreateBallots < ActiveRecord::Migration[6.0]
  def change
    create_table :ballots do |t|
      t.string :title
      t.text :description
      t.string :ballot_type
      t.text :choices, array: true, default: []
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
