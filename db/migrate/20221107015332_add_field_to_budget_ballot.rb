class AddFieldToBudgetBallot < ActiveRecord::Migration[5.2]
  def change
    add_column :budget_ballots, :confirmed_at, :datetime
  end
end
