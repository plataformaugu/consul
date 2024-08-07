class AddPublishedAtToSurveys < ActiveRecord::Migration[6.0]
  def change
    add_column :surveys, :published_at, :datetime, null: true
  end
end
