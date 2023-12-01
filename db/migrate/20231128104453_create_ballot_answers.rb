class CreateBallotAnswers < ActiveRecord::Migration[6.0]
  def change
    create_table :ballot_answers do |t|
      t.references :ballot, foreign_key: true
      t.references :user, foreign_key: true
      t.text :answer, array: true, default: []

      t.timestamps
    end
  end
end
