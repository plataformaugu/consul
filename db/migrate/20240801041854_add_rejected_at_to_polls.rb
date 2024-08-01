class AddRejectedAtToPolls < ActiveRecord::Migration[6.0]
  def change
    add_column :polls, :rejected_at, :datetime, null: true
  end
end
