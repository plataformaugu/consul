class AddNeighborhoodCouncilToNew < ActiveRecord::Migration[5.2]
  def change
    add_reference :news, :neighborhood_council, index: true
  end
end
