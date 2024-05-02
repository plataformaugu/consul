class CreateSector < ActiveRecord::Migration[6.0]
  def change
    create_table :sectors do |t|
      t.integer :internal_id
      t.string :name

      t.timestamps
    end

    add_reference :users, :sector, index: true
  end
end
