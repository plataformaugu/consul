class AddPublishedAtToDebate < ActiveRecord::Migration[6.0]
  def change
    add_column :debates, :published_at, :datetime, null: true
    add_column :debates, :image, :string
    add_column :debates, :is_finished, :boolean, default: false
  end
end
