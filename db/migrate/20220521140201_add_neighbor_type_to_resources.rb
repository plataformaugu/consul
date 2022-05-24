class AddNeighborTypeToResources < ActiveRecord::Migration[5.2]
  def change
    create_table :neighbor_types do |t|
      t.string :name
    end

    add_reference :users, :neighbor_type, index: true
    
    create_table :poll_neighbor_types do |t|
      t.references :poll, null: false, foreign_key: true
      t.references :neighbor_type, null: false, foreign_key: true
    end

    create_table :encuestum_neighbor_types do |t|
      t.references :encuestum, null: false, foreign_key: true
      t.references :neighbor_type, null: false, foreign_key: true
    end

    create_table :proposals_theme_neighbor_types do |t|
      t.references :proposals_theme, null: false, foreign_key: true
      t.references :neighbor_type, null: false, foreign_key: true
    end

    create_table :proposal_neighbor_types do |t|
      t.references :proposal, null: false, foreign_key: true
      t.references :neighbor_type, null: false, foreign_key: true
    end
  end
end
