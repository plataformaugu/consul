class CreateGroupUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :group_users do |t|
      t.string :name
      t.string :email
      t.string :rut
      t.references :group, foreign_key: true

      t.timestamps
    end
  end
end
