class AddPublishedAtToBudgetInvestment < ActiveRecord::Migration[6.0]
  def change
    add_column :budget_investments, :published_at, :datetime, null: true
  end
end
