class AddLimitDateToProposals < ActiveRecord::Migration[5.2]
  def change
    add_column :proposals, :limit_date, :date, null: true
  end
end
