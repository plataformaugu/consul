class ChangeFieldsToNeighborhoodCouncilEvent < ActiveRecord::Migration[5.2]
  def change
    add_column :neighborhood_council_events, :title, :string
    add_column :neighborhood_council_events, :description, :text
    add_column :neighborhood_council_events, :start_time, :datetime
    add_column :neighborhood_council_events, :end_time, :datetime
    remove_column :neighborhood_council_events, :name
    remove_column :neighborhood_council_events, :event_id
  end
end
