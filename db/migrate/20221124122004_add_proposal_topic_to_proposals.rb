class AddProposalTopicToProposals < ActiveRecord::Migration[6.0]
  def change
    add_reference :proposals, :proposal_topic, index: true
  end
end
