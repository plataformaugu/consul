class AddConfirmedAtToBudgetBallot < ActiveRecord::Migration[6.0]
  def change
    add_column :budget_ballots, :confirmed_at, :datetime, null: true
  end
end
