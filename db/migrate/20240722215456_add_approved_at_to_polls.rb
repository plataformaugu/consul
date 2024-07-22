class AddApprovedAtToPolls < ActiveRecord::Migration[6.0]
  def change
    add_column :polls, :approved_at, :datetime, null: true
  end
end
