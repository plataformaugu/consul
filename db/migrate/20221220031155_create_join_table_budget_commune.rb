class CreateJoinTableBudgetCommune < ActiveRecord::Migration[6.0]
  def change
    create_join_table :budgets, :communes do |t|
      # t.index [:budget_id, :commune_id]
      # t.index [:commune_id, :budget_id]
    end
  end
end
