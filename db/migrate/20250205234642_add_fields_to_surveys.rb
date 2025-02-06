class AddFieldsToSurveys < ActiveRecord::Migration[5.2]
  def change
    add_column :surveys, :start_time, :datetime
    add_column :surveys, :end_time, :datetime
    add_column :surveys, :published_at, :datetime, null: true
  end
end
