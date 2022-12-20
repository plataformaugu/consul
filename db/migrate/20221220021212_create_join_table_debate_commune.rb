class CreateJoinTableDebateCommune < ActiveRecord::Migration[6.0]
  def change
    create_join_table :debates, :communes do |t|
      # t.index [:debate_id, :commune_id]
      # t.index [:commune_id, :debate_id]
    end
  end
end
