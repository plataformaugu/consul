class AddFieldsToBudget < ActiveRecord::Migration[5.2]
  def change
    add_column :budgets, :custom_description, :text
    add_column :budgets, :pdf_link, :string
  end
end
