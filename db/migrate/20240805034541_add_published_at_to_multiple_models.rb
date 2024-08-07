class AddPublishedAtToMultipleModels < ActiveRecord::Migration[6.0]
  def change
    add_column :polls, :published_at, :datetime, null: true
    add_column :news, :published_at, :datetime, null: true
    add_column :events, :published_at, :datetime, null: true
  end
end
