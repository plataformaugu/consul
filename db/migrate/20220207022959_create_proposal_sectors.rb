class CreateProposalSectors < ActiveRecord::Migration[5.2]
  def change
    create_table :proposal_sectors do |t|
      t.references :proposal, null: false, foreign_key: true
      t.references :sector, null: false, foreign_key: true
    end
  end
end
