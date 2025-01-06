class AddDisableNewProposalsToProposalTopics < ActiveRecord::Migration[6.0]
  def change
    add_column :proposal_topics, :proposal_creation_disabled, :boolean, default: false
  end
end
