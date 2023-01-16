class CreateJoinTableUserNeighborhoodCouncilEvent < ActiveRecord::Migration[5.2]
  def change
    create_join_table :users, :neighborhood_council_events do |t|
      # t.index [:user_id, :neighborhood_council_event_id]
      # t.index [:neighborhood_council_event_id, :user_id]
    end
  end
end
