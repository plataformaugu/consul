class RenameSurveyTypeColumn < ActiveRecord::Migration[5.2]
  def change
    rename_column :surveys, :type, :survey_type
  end
end
