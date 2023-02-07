class AddFieldsToBudgetInvestments < ActiveRecord::Migration[5.2]
  def change
    add_column :budget_investments, :confirmed_at, :datetime
    add_column :budget_investments, :pdf_link, :string
    add_reference :budget_investments, :main_theme, index: true

    create_table :budget_investment_sectors do |t|
      t.references :budget_investment, null: false, foreign_key: true
      t.references :sector, null: false, foreign_key: true
    end
  end
end
