class AddSectorToUsersAndProposals < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :sector, :string
    add_column :proposals, :sector, :string
  end
end
