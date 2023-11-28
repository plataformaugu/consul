class AddBenefitsToBudgets < ActiveRecord::Migration[6.0]
  def change
    add_column :budgets, :benefits, :text
    add_column :budget_translations, :benefits, :text
  end
end
