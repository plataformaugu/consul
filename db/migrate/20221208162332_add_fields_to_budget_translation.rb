class AddFieldsToBudgetTranslation < ActiveRecord::Migration[6.0]
  def change
    add_column :budget_translations, :custom_description, :text
    add_column :budget_translations, :pdf_link, :string
  end
end
