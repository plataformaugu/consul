class CreateProposalTopics < ActiveRecord::Migration[6.0]
  def change
    create_table :proposal_topics do |t|
      t.string :title
      t.text :description
      t.string :image
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
