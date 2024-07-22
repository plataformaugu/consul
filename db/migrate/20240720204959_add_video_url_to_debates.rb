class AddVideoUrlToDebates < ActiveRecord::Migration[6.0]
  def change
    add_column :debates, :video_url, :string
  end
end
