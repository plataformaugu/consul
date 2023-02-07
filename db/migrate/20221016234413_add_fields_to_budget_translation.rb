class AddFieldsToBudgetTranslation < ActiveRecord::Migration[5.2]
  def change
    add_column :budget_translations, :custom_description, :text
    add_column :budget_translations, :pdf_link, :string
  end
end
