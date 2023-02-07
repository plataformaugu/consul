class AddPublishedAtToDebates < ActiveRecord::Migration[5.2]
  def change
    add_column :debates, :published_at, :datetime, null: true
  end
end
