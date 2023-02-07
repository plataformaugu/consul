class AddTypeToNews < ActiveRecord::Migration[5.2]
  def change
    add_column :news, :news_type, :string
    add_column :news, :summary, :text
    add_column :news, :miniature, :string
  end
end
