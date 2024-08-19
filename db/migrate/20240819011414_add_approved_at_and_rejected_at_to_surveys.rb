class AddApprovedAtAndRejectedAtToSurveys < ActiveRecord::Migration[6.0]
  def change
    add_column :surveys, :approved_at, :datetime, null: true
    add_column :surveys, :rejected_at, :datetime, null: true
  end
end
