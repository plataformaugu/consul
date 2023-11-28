class AddIsMunicipalToProposals < ActiveRecord::Migration[6.0]
  def change
    add_column :proposals, :is_municipal, :boolean, default: false
  end
end
