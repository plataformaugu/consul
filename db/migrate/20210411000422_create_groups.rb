class CreateGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :groups do |t|
      t.string :name, :default => ''
      t.string :description, :default => ''

      t.timestamps
    end
  end
end
