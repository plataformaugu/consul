class AddNewModels < ActiveRecord::Migration[5.2]
  def change
    create_table :news do |t|
      t.string :title
      t.text :body
      t.string :image
      t.date :highlight_until
      t.references :main_theme, foreign_key: true

      t.timestamps
    end

    create_table :news_like do |t|
      t.references :user, foreign_key: true

      t.timestamps
    end
    
    create_table :news_dislike do |t|
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
