class AddFieldsToDebate < ActiveRecord::Migration[5.2]
  def change
    add_column :debates, :is_finished, :boolean, default: false
    add_column :debates, :image, :string

    add_reference :debates, :main_theme, index: true

    create_table :debate_sectors do |t|
      t.references :debate, null: false, foreign_key: true
      t.references :sector, null: false, foreign_key: true
    end
    
    create_table :debate_neighbor_types do |t|
      t.references :debate, null: false, foreign_key: true
      t.references :neighbor_type, null: false, foreign_key: true
    end
  end
end
