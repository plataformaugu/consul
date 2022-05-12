class AdddIsInitiativeToProposals < ActiveRecord::Migration[5.2]
  def change
    add_column :proposals, :is_initiative, :boolean, default: false
  end
end
