class CreateJoinTablePollCommune < ActiveRecord::Migration[6.0]
  def change
    create_join_table :polls, :communes do |t|
      # t.index [:poll_id, :commune_id]
      # t.index [:commune_id, :poll_id]
    end
  end
end
