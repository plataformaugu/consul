class AddPublishedAtToProposalTopics < ActiveRecord::Migration[6.0]
  def change
    add_column :proposal_topics, :published_at, :datetime, null: true
  end
end
