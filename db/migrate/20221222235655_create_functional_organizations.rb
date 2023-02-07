class CreateFunctionalOrganizations < ActiveRecord::Migration[5.2]
  def change
    create_table :functional_organizations do |t|
      t.string :name
      t.date :conformation_date
      t.string :president_name
      t.string :phone_number
      t.string :email
      t.string :address
      t.string :mission
      t.string :view
      t.string :whatsapp
      t.string :twitter
      t.string :facebook
      t.string :instagram
      t.string :url
      t.references :main_theme, foreign_key: true

      t.timestamps
    end
  end
end
