class AddShowResultsAndShowStatsToSurveys < ActiveRecord::Migration[6.0]
  def change
    add_column :surveys, :show_results, :boolean, default: false
    add_column :surveys, :show_stats, :boolean, default: false
  end
end
