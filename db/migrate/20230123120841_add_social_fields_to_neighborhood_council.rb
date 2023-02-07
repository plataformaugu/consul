class AddSocialFieldsToNeighborhoodCouncil < ActiveRecord::Migration[5.2]
  def change
    add_column :neighborhood_councils, :whatsapp, :string
    add_column :neighborhood_councils, :facebook, :string
    add_column :neighborhood_councils, :twitter, :string
    add_column :neighborhood_councils, :instagram, :string
    add_column :neighborhood_councils, :url, :string
  end
end
