class CreateSocialOrganizations < ActiveRecord::Migration[6.0]
  def change
    create_table :social_organizations do |t|
      t.string :name
      t.text :description
      t.string :email
      t.string :url
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
