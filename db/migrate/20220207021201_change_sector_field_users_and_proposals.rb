class ChangeSectorFieldUsersAndProposals < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :sector
    remove_column :proposals, :sector

    add_reference :users, :sector, index: true
    add_reference :proposals, :sector, index: true
  end
end
