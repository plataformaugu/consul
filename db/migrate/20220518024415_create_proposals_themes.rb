class CreateProposalsThemes < ActiveRecord::Migration[5.2]
  def change
    create_table :proposals_themes do |t|
      t.string :title
      t.text :description
      t.string :image
      t.date :start_date
      t.date :end_date
      t.boolean :is_public

      t.timestamps
    end

    add_reference :proposals_themes, :sector, index: true

    create_table :proposals_theme_sectors do |t|
      t.references :proposals_theme, null: false, foreign_key: true
      t.references :sector, null: false, foreign_key: true
    end
  end
end
