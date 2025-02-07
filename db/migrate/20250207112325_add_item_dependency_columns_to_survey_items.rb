class AddItemDependencyColumnsToSurveyItems < ActiveRecord::Migration[5.2]
  def change
    add_reference :survey_items, :item_dependency, index: true, references: :survey_items
    add_column :survey_items, :item_dependency_answer, :string
  end
end
