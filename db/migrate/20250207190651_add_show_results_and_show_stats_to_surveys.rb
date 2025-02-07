class AddShowResultsAndShowStatsToSurveys < ActiveRecord::Migration[5.2]
  def change
    add_column :surveys, :show_results, :boolean, default: false
    add_column :surveys, :show_stats, :boolean, default: false
  end
end
