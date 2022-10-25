class AddSectorsToBudgetHeadings < ActiveRecord::Migration[5.2]
  def change
    create_table :budget_heading_sectors do |t|
      t.references :budget_heading, null: false, foreign_key: true
      t.references :sector, null: false, foreign_key: true
    end
  end
end
