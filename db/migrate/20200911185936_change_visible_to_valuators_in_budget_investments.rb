class ChangeVisibleToValuatorsInBudgetInvestments < ActiveRecord::Migration[5.0]
  def change
    change_column_default(:budget_investments, :visible_to_valuators, from: false, to: true)
  end
end
