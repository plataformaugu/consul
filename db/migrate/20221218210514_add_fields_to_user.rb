class AddFieldsToUser < ActiveRecord::Migration[6.0]
  def change
    add_reference :users, :commune, index: true, null: true
    add_column :users, :social_organization, :string, null: true
  end
end
