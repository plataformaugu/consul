class CreateJoinTableProposalTopicCommune < ActiveRecord::Migration[6.0]
  def change
    create_join_table :proposal_topics, :communes do |t|
      # t.index [:proposal_topic_id, :commune_id]
      # t.index [:commune_id, :proposal_topic_id]
    end
  end
end
