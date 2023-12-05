class AddBenefitsToInvestments < ActiveRecord::Migration[6.0]
  def change
    add_column :budget_investments, :benefits, :text
    add_column :budget_investment_translations, :benefits, :text
  end
end
