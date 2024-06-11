class CreateSurveys < ActiveRecord::Migration[6.0]
  def change
    create_table :surveys do |t|
      t.string :title
      t.text :body
      t.string :image

      t.timestamps
    end

    create_table :survey_items do |t|
      t.string :title
      t.string :item_type
      t.json :data
      t.integer :position
      t.boolean :required, default: true

      t.references :survey, foreign_key: true, index: true
    end

    create_table :survey_item_answers do |t|
      t.json :data

      t.references :survey_item, foreign_key: true, index: true
      t.references :user, foreign_key: true, index: true
    end
  end
end
